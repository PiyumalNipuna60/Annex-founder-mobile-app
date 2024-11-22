import 'package:equatable/equatable.dart';

class AnnexModel extends Equatable {
  final String? docId;
  final String? userId; // Required
  final String? title; // Required
  final String? location; // Required
  final String? city; // Required
  final double? rating; // Default to 0.0
  final String? province; // Required
  final String? description; // Required
  final String? price; // Required
  final List<String>? imageUrls; // Required
  final String? provinceImage;
  final DateTime? createdAt; // Required
  final DateTime? updatedAt;
  final int? annexStatus;

  const AnnexModel({
    this.docId,
    this.userId,
    this.title,
    this.location,
    this.city,
    double? rating,
    this.province,
    this.description,
    this.price,
    this.imageUrls,
    this.provinceImage,
    this.createdAt,
    this.updatedAt,
    this.annexStatus,
  }) : rating = rating ?? 0.0; // Default rating to 0.0

  AnnexModel copyWith({
    String? docId,
    String? userId,
    String? title,
    String? location,
    String? city,
    double? rating,
    String? province,
    String? description,
    String? price,
    List<String>? imageUrls,
    String? provinceImage,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? annexStatus,
  }) {
    return AnnexModel(
      docId: docId ?? this.docId,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      location: location ?? this.location,
      city: city ?? this.city,
      rating: rating ?? this.rating,
      province: province ?? this.province,
      description: description ?? this.description,
      price: price ?? this.price,
      imageUrls: imageUrls ?? this.imageUrls,
      provinceImage: provinceImage ?? this.provinceImage,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      annexStatus: annexStatus ?? this.annexStatus,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'title': title,
      'location': location,
      'city': city,
      'rating' : rating,
      'province': province,
      'description': description,
      'price': price,
      'imageUrls': imageUrls,
      'provinceImage': provinceImage,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'annexStatus': annexStatus,
    };
  }

  static AnnexModel fromJson(Map<String, dynamic> json, String docId) {
    return AnnexModel(
      docId: docId,
      userId: json['userId'] ?? '',
      title: json['title'] ?? '',
      location: json['location'] ?? '',
      city: json['city'] ?? '',
      rating: json['rating']?.toDouble() ?? 0.0, // Ensure it's a double
      province: json['province'] ?? '',
      description: json['description'] ?? '',
      price: json['price'] ?? '',
      imageUrls: List<String>.from(json['imageUrls'] ?? []), // Handle null
      provinceImage: json['provinceImage'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      annexStatus: json['annexStatus'],
    );
  }

  @override
  List<Object?> get props => [
        docId,
        userId,
        title,
        location,
        city,
        rating,
        province,
        description,
        price,
        imageUrls,
        provinceImage,
        createdAt,
        updatedAt,
        annexStatus,
      ];
}
