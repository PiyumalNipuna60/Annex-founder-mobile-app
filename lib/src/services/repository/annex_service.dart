import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart'; // For getting file name

import '../../model/annex/annex_model.dart';

class AnnexService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Upload a single image to Firebase Storage and return its URL
  Future<String> uploadImage(File image, String userId) async {
    String fileName = basename(image.path);
    try {
      // Create a reference to Firebase Storage location
      Reference storageRef =
          _storage.ref().child('annex_images/$userId/$fileName');

      // Upload the image file to Firebase
      UploadTask uploadTask = storageRef.putFile(image);
      TaskSnapshot taskSnapshot = await uploadTask;

      // Get the download URL for the uploaded image
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      throw Exception("Failed to upload image: $e");
    }
  }

  // Save annex details to Firestore
  Future<void> addAnnexDetails(AnnexModel annexModel) async {
    try {
      await _firestore.collection('annexes').add(annexModel.toJson());
    } catch (e) {
      throw Exception("Failed to add annex details: $e");
    }
  }

  Future<List<AnnexModel>> getAnnexDetails(String userId) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('annexes')
          .where('userId', isEqualTo: userId)
          .get();

      List<AnnexModel> annexes = snapshot.docs.map((doc) {
        // Call the fromJson method with both the JSON data and the document ID
        return AnnexModel.fromJson(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();

      return annexes;
    } catch (e) {
      throw Exception("Failed to get annex details: $e");
    }
  }

  Future<void> updateAnnexDetails(AnnexModel annexModel) async {
    try {
      if (annexModel.docId == null) {
        throw Exception("Annex model must have an ID to update");
      }

      await _firestore
          .collection('annexes')
          .doc(annexModel.docId)
          .update(annexModel.toJson());
    } catch (e) {
      throw Exception("Failed to update annex details: $e");
    }
  }

  Future<List<AnnexModel>> allAnnexDetails(String userId) async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('annexes').get();

      List<AnnexModel> annexes = snapshot.docs.map((doc) {
        return AnnexModel.fromJson(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();

      return annexes;
    } catch (e) {
      print("Error fetching annex details: $e");
      throw Exception("Failed to get annex details: $e");
    }
  }

  Future<void> bookAnnex(String userId, String annexDocId) async {
    try {
      // Create a reference to the bookings collection
      final bookingCollection = _firestore.collection('bookings');

      // Create a new booking document
      await bookingCollection.add({
        'userId': userId,
        'annexDocId': annexDocId,
        'timestamp': FieldValue.serverTimestamp(),
        // Add additional fields if necessary, e.g., booking date, status, etc.
      });

      print('Booking successful for annex ID: $annexDocId by user ID: $userId');
    } catch (e) {
      throw Exception("Failed to book annex: $e");
    }
  }

  Future<void> updateAnnexStatus(int? annexStatus, String? docId) async {
    try {
      // Check for null parameters
      if (annexStatus == null || docId == null) {
        throw Exception("Both annexStatus and docId must be provided");
      }

      // Perform the update
      await _firestore
          .collection('annexes')
          .doc(docId)
          .update({'annexStatus': annexStatus}); // Use a map for the update
    } catch (e) {
      throw Exception("Failed to update annex status: $e");
    }
  }

  Future<List<AnnexModel>> allProvincesDetails(String province) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('annexes')
          .where("province", isEqualTo: province)
          .get();

      List<AnnexModel> annexes = snapshot.docs.map((doc) {
        return AnnexModel.fromJson(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();

      return annexes;
    } catch (e) {
      print("Error fetching annex details: $e");
      throw Exception("Failed to get annex details: $e");
    }
  }
}
