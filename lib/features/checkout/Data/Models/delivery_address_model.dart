import 'package:cloud_firestore/cloud_firestore.dart';

class DeliveryAddressModel {
  String id;
  final double lat;
  final double long;
  final String nickname;
  final String fullAddress;
  final bool isDefault;
  final Timestamp createdAt;

  DeliveryAddressModel({
    required this.id,
    required this.lat,
    required this.long,
    required this.nickname,
    required this.fullAddress,
    required this.isDefault,
    required this.createdAt,
  });

  factory DeliveryAddressModel.fromJson(Map<String, dynamic> json) {
    return DeliveryAddressModel(
      id: json['address_id'],
      lat: json['lat'],
      long: json['long'],
      nickname: json['address_nick_name'],
      fullAddress: json['full_address'],
      isDefault: json['is_marked_as_default'],
      createdAt: json['createdAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'address_id': id,
        'lat': lat,
        'long': long,
        'address_nick_name': nickname,
        'full_address': fullAddress,
        'is_marked_as_default': isDefault,
        'createdAt': createdAt
    };
  }
}
