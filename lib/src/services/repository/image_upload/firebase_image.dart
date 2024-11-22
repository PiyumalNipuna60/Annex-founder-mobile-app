import 'dart:io';  
import 'package:firebase_storage/firebase_storage.dart';  
import 'package:firebase_auth/firebase_auth.dart';  
import 'image.dart';  

class FirebaseImageUpload implements UserImage {
  @override
  Future<String?> uploadUserImage(File imageFile) async {
    try {
      
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        return null;  
      }

      final storageRef = FirebaseStorage.instance
          .ref()
          .child('profile_images/${user.uid}.jpg');

      UploadTask uploadTask = storageRef.putFile(imageFile);

      final snapshot = await uploadTask.whenComplete(() {});
      final downloadUrl = await snapshot.ref.getDownloadURL();

      return downloadUrl;  
    } catch (e) {
      print('Failed to upload image: $e');
      return null;  
    }
  }
}
