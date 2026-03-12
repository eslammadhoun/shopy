import 'package:cloud_firestore/cloud_firestore.dart';

class DeliveryAddress {
  final String id;
  final double lat;
  final double long;
  final String nickname;
  final String fullAddress;
  final bool isDefault;
  final Timestamp createdAt;

  const DeliveryAddress({
    required this.id,
    required this.lat,
    required this.long,
    required this.nickname,
    required this.fullAddress,
    required this.isDefault,
    required this.createdAt,
  });
}
