import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../model/booking_model.dart';

class BookingService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String currentUserId = FirebaseAuth.instance.currentUser!.uid;

  Future<List<BookingModel>> getUserBookings() async {
    final snapshot = await _firestore
        .collection('bookings')
        .where('userId', isEqualTo: currentUserId)
        .get();

    return snapshot.docs.map((doc) {
      return BookingModel.fromJson(doc.data(), doc.id);
    }).toList();
  }
}
