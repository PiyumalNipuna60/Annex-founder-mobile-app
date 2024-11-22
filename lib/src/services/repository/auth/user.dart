import 'package:firebase_auth/firebase_auth.dart';

import '../../../model/user_model/user_model.dart';

abstract class MyUsers {
  Stream<User?> get user;

  Future<bool> userLogin(String emailAddress, String password);

  Future<bool> googleSignIn();

  Future<bool> googleSignUp();

  Future<bool> facebookSignIn();

  Future<bool> facebookSignUp();

  Future<MyUser?> getCurrentUserProfile();
  Future<MyUser?> getCurrentUserUpdate(String userId,MyUser myUser);

  Future<void> blockUser(String userId);

  Future<void> unblockUser(String userId);

  Future<bool> isUserBlocked(String userId);

  Future<bool> userRegister(String email, String password, String fullName);

  Future<void> logout();
}
