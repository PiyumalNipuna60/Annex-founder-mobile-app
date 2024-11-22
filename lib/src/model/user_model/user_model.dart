import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class MyUser extends Equatable {
  final String? userId;
  final String? imageUrl;
  final String? email;
  final String? phoneNumber;
  final String? address;
  final String? fullName;
  final String? userType;
  final DateTime? createAt;
  final DateTime? updateAt;
  final int? status;
  final bool isBlocked;

  const MyUser({
    required this.userId,
    required this.imageUrl,
    required this.email,
    required this.phoneNumber,
    required this.address,
    required this.fullName,
    required this.userType,
    required this.createAt,
    required this.updateAt,
    required this.status,
    required this.isBlocked,
  });

  factory MyUser.fromDocument(Map<String, dynamic> doc, String userId) {
    return MyUser(
      userId: userId,
      imageUrl: doc['image_url'] ?? '',
      email: doc['email'],
      phoneNumber: doc['phone_number'],
      address: doc['address'],
      fullName: doc['full_name'] ?? '',
      userType: doc['user_type'] ?? '',
      createAt: (doc['create_at'] as Timestamp).toDate(),
      updateAt: (doc['update_at'] as Timestamp).toDate(),
      status: doc['status'] ?? 0,
      isBlocked: doc['is_blocked'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'image_url': imageUrl,
      'email': email,
      'phone_number': phoneNumber,
      'address': address,
      'full_name': fullName,
      'user_type': userType,
      'create_at': createAt,
      'update_at': updateAt,
      'status': status,
      'is_blocked': isBlocked,
    };
  }

  MyUser copyWith({
    String? userId,
    String? imageUrl,
    String? email,
    String? phoneNumber,
    String? address,
    String? fullName,
    String? userType,
    DateTime? createAt,
    DateTime? updateAt,
    int? status,
    bool? isBlocked,
  }) {
    return MyUser(
      userId: userId ?? this.userId,
      imageUrl: imageUrl ?? this.imageUrl,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? phoneNumber,
      address: address ?? address,
      fullName: fullName ?? this.fullName,
      userType: userType ?? this.userType,
      createAt: createAt ?? this.createAt,
      updateAt: updateAt ?? this.updateAt,
      status: status ?? this.status,
      isBlocked: isBlocked ?? this.isBlocked,
    );
  }

  @override
  List<Object?> get props => [
        userId,
        imageUrl,
        email,
        phoneNumber,
        address,
        fullName,
        userType,
        createAt,
        updateAt,
        status,
        isBlocked,
      ];
}
