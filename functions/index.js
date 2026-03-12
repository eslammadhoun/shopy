const { onCall, onRequest, HttpsError } = require("firebase-functions/v2/https");
const { defineSecret } = require("firebase-functions/params");
const admin = require("firebase-admin");
const Stripe = require("stripe");

admin.initializeApp();
const stripeSecret = defineSecret("STRIPE_SECRET");
const stripeWebhookSecret = defineSecret("STRIPE_WEBHOOK_SECRET");

exports.changePassword = onCall(async (request) => {
  try {
    const { email, newPassword } = request.data;

    if (!email || !newPassword) {
      throw new HttpsError("invalid-argument", "Email and new password required");
    }

    const userRecord = await admin.auth().getUserByEmail(email);

    if (!userRecord) {
      throw new HttpsError("not-found", "User not found");
    }

    await admin.auth().updateUser(userRecord.uid, { password: newPassword });

    return { success: true, message: "Password changed successfully" };
  } catch (error) {
    console.error(error);

    if (error.code === "auth/user-not-found") {
      throw new HttpsError("not-found", "User not found");
    }

    throw new HttpsError("internal", error.message || "Server error");
  }
});

exports.addCard = onCall(
  { secrets: [stripeSecret], region: "us-central1" },
  async (request) => {
    const stripe = new Stripe(await stripeSecret.value());
    try {
      if (!request.auth) throw new HttpsError("unauthenticated", "User not authenticated");

      const uid = request.auth.uid;
      const paymentMethodId = request.data.paymentMethodId;
      if (!paymentMethodId) throw new HttpsError("invalid-argument", "Missing paymentMethodId");

      // Get User Data From Firestore
      const userRef = admin.firestore().collection("Shopy_Users").doc(uid);
      const userDoc = await userRef.get();
      if (!userDoc.exists) throw new HttpsError("not-found", "User not found");

      let userData = userDoc.data();
      let stripeCustomerId = userData.stripeCustomerId;

      // create customer if no one is exists
      if (!stripeCustomerId) {
        const customer = await stripe.customers.create({
          email: userData.email,
          metadata: { firebaseUID: uid },
        });
        stripeCustomerId = customer.id;
        await userRef.update({ stripeCustomerId });
      }

      // Get Payment Method Data
      const paymentMethod = await stripe.paymentMethods.retrieve(paymentMethodId);
      const newCard = {
        id: paymentMethod.id,
        last4: paymentMethod.card.last4,
        brand: paymentMethod.card.brand,
        exp_month: paymentMethod.card.exp_month,
        exp_year: paymentMethod.card.exp_year,
      };

      // Check For Duplication
      const existingCardsSnap = await userRef.collection("Payment_Methods").get();
      const isDuplicate = existingCardsSnap.docs.some(doc => {
        const card = doc.data();
        return card.last4 === newCard.last4 &&
          card.brand === newCard.brand &&
          card.exp_month === newCard.exp_month &&
          card.exp_year === newCard.exp_year;
      });

      if (isDuplicate) throw new HttpsError("already-exists", "This card is already added.");

      // connect payment method to customer id
      await stripe.paymentMethods.attach(paymentMethodId, { customer: stripeCustomerId });

      // store the payment method in Firestore Database
      await userRef.collection("Payment_Methods").add(newCard);

      return { success: true, card: newCard };
    } catch (error) {
      console.error("ERROR:", error);
      if (error instanceof HttpsError) {
        throw error;
      }
      throw new HttpsError("internal", error.message || error.toString());
    }
  }
);

exports.getCustomerCards = onCall(
  { secrets: [stripeSecret] },
  async (request) => {
    const stripe = new Stripe(await stripeSecret.value());
    const customerId = request.data.customerId;

    const paymentMethods = await stripe.paymentMethods.list({
      customer: customerId,
      type: "card",
    });

    return paymentMethods.data;
  }
);

exports.createPaymentIntent = onCall(
  { secrets: [stripeSecret], region: "us-central1" },
  async (request) => {
    const stripe = new Stripe(await stripeSecret.value());

    try {
      if (!request.auth)
        throw new HttpsError("unauthenticated", "User not authenticated");

      const uid = request.auth.uid;
      const { amount, paymentMethodId, items } = request.data;

      if (!amount || !paymentMethodId)
        throw new HttpsError("invalid-argument", "Missing parameters");

      const userRef = admin.firestore().collection("Shopy_Users").doc(uid);
      const userDoc = await userRef.get();

      if (!userDoc.exists)
        throw new HttpsError("not-found", "User not found");

      const stripeCustomerId = userDoc.data().stripeCustomerId;

      if (!stripeCustomerId)
        throw new HttpsError("failed-precondition", "Stripe customer not found");

      const paymentIntent = await stripe.paymentIntents.create({
        amount: amount,
        currency: "usd",
        customer: stripeCustomerId,
        payment_method: paymentMethodId,
        confirm: true,
        off_session: true,
        metadata: {
          userId: uid,
          items: JSON.stringify(request.data.items),
        },
      });

      if (paymentIntent.status !== "succeeded") {
        throw new HttpsError("internal", "Payment not completed");
      }

      return {
        success: true,
        paymentIntentId: paymentIntent.id,
      };
    } catch (error) {
      console.error("Stripe Error:", error);

      // Stripe specific errors
      if (error.type === "StripeCardError") {
        throw new HttpsError("failed-precondition", error.message);
      }

      if (error.type === "StripeInvalidRequestError") {
        throw new HttpsError("invalid-argument", error.message);
      }

      if (error.type === "StripeAuthenticationError") {
        throw new HttpsError("permission-denied", "Stripe authentication failed");
      }

      if (error.type === "StripeAPIError") {
        throw new HttpsError("internal", "Stripe API error");
      }

      if (error.type === "StripeConnectionError") {
        throw new HttpsError("unavailable", "Network error, try again");
      }

      if (error instanceof HttpsError) throw error;
      throw new HttpsError("internal", "Unexpected error occurred");
    }
  }
);

exports.stripeWebhook = onRequest(
  {
    secrets: [stripeSecret, stripeWebhookSecret],
    region: "us-central1",
    rawBody: true,
  },
  async (req, res) => {
    const stripe = new Stripe(await stripeSecret.value());
    const endpointSecret = await stripeWebhookSecret.value();
    let event;

    try {
      const sig = req.headers["stripe-signature"];

      event = stripe.webhooks.constructEvent(
        req.rawBody,
        sig,
        endpointSecret
      );
    } catch (err) {
      console.error("Webhook signature verification failed.", err);
      return res.status(400).send(`Webhook Error: ${err.message}`);
    }

    if (event.type === "payment_intent.succeeded") {
      const paymentIntent = event.data.object;
      const paymentIntentId = paymentIntent.id;
      const metadata = paymentIntent.metadata;
      const items = JSON.parse(metadata.items);

      const orderRef = admin
        .firestore()
        .collection("Shopy_Users")
        .doc(metadata.userId)
        .collection("Orders")
        .doc(paymentIntentId);

      const existingOrder = await orderRef.get();
      if (existingOrder.exists) {
        return res.status(200).send("Order already exists");
      }

      await orderRef.set({
        orderId: paymentIntentId,
        userId: metadata.userId,
        paymentIntentId: paymentIntentId,
        paymentMethodId: paymentIntent.payment_method,
        customerId: paymentIntent.customer,
        totalAmount: paymentIntent.amount / 100,
        currency: paymentIntent.currency,
        items: items,
        isCompleted: false,
        orderStatus: "pending",
        createdAt: admin.firestore.FieldValue.serverTimestamp(),
        isPaid: true,
      });
      
      // reference to user cart
      const cartRef = admin
        .firestore()
        .collection("Shopy_Users")
        .doc(metadata.userId)
        .collection("cart_products");

      // get all cart items
      const cartSnapshot = await cartRef.get();

      // batch delete
      const batch = admin.firestore().batch();

      cartSnapshot.docs.forEach((doc) => {
        batch.delete(doc.ref);
      });

      await batch.commit();
    }


    res.status(200).send("Received");
  }
);