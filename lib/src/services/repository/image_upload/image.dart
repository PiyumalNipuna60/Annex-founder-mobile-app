import 'dart:io';

abstract class UserImage {
  Future<String?> uploadUserImage(File imageFile);
}
