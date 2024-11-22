import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class BookingModel extends Equatable {
  final String bookingId;
  final String annexDocId;
  final String userId;
  final DateTime timestamp; // Use DateTime for the timestamp

  const BookingModel({
    required this.bookingId,
    required this.annexDocId,
    required this.userId,
    required this.timestamp,
  });

  // Convert Firestore document to BookingModel
  static BookingModel fromJson(Map<String, dynamic> json, String bookingId) {
    return BookingModel(
      bookingId: bookingId,
      annexDocId: json['annexDocId'],
      userId: json['userId'],
      // Check if timestamp is a Firestore Timestamp and convert to DateTime
      timestamp: (json['timestamp'] as Timestamp).toDate(),
    );
  }

  @override
  List<Object?> get props => [bookingId, annexDocId, userId, timestamp];
}
