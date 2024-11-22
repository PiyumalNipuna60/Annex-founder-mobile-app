import 'dart:developer';
import 'package:annex_finder/src/model/user_model/user_model.dart';
import 'package:annex_finder/src/services/repository/auth/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebasesUser implements MyUsers {
  FirebasesUser({
    FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firebaseFirestore,
  })  : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        userCollection = firebaseFirestore?.collection("users") ??
            FirebaseFirestore.instance.collection("users");

  final FirebaseAuth _firebaseAuth;
  final CollectionReference userCollection;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  Stream<User?> get user {
    return _firebaseAuth.authStateChanges();
  }

  @override
  Future<bool> userRegister(
      String email, String password, String fullName) async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Check if the user already exists before creating a new entry
      bool userExists = await checkIfUserExists(userCredential.user!.uid);
      if (!userExists) {
        MyUser myUser = MyUser(
          userId: userCredential.user!.uid,
          imageUrl: userCredential.user!.photoURL ?? "",
          email: userCredential.user!.email!,
          phoneNumber: userCredential.user!.phoneNumber ?? "",
          address: "",
          fullName: fullName,
          userType: "user",
          createAt: DateTime.now(),
          updateAt: DateTime.now(),
          status: 0,
          isBlocked: false,
        );

        await userCollection.doc(myUser.userId).set(myUser.toJson());
      }
      return true;
    } on FirebaseAuthException catch (e) {
      log('Registration Error: ${e.message}');
      return false;
    }
  }

  @override
  Future<bool> userLogin(String emailAddress, String password) async {
    try {
      final UserCredential credential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );
      return credential.user != null;
    } catch (e) {
      log('Login Error: ${e.toString()}');
      return false;
    }
  }

  @override
  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }

  // Facebook Sign-In Method
  @override
  Future<bool> facebookSignIn() async {
    User? currentUser = _firebaseAuth.currentUser;
    if (currentUser != null) {
      final LoginResult result = await FacebookAuth.instance.login();

      if (result.status == LoginStatus.success) {
        final AuthCredential credential =
            FacebookAuthProvider.credential(result.accessToken!.tokenString);
        return _signInWithCredential(credential);
      }
    }

    return false;
  }

  // Facebook Sign-Up Method
  @override
  Future<bool> facebookSignUp() async {
    final LoginResult result = await FacebookAuth.instance.login();

    if (result.status == LoginStatus.success) {
      final AuthCredential credential =
          FacebookAuthProvider.credential(result.accessToken!.tokenString);
      return _signUpWithCredential(credential);
    }
    return false;
  }

  @override
  Future<bool> googleSignIn() async {
    User? currentUser = _firebaseAuth.currentUser;
    if (currentUser != null) {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        return _signInWithCredential(credential);
      }
    }

    return false;
  }

  @override
  Future<bool> googleSignUp() async {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

    if (googleUser != null) {
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      return _signUpWithCredential(credential);
    }
    return false;
  }

  Future<bool> _signInWithCredential(AuthCredential credential) async {
    try {
      final UserCredential userCredential =
          await _firebaseAuth.signInWithCredential(credential);

      // Check if user already exists in Firestore
      bool userExists = await checkIfUserExists(userCredential.user!.uid);
      if (!userExists) {
        log('User exists in Firebase Auth but not in Firestore');
      }

      return userCredential.user != null;
    } catch (e) {
      log('Sign-in Error: ${e.toString()}');
      return false;
    }
  }

  // Reusable sign-up method using credential
  Future<bool> _signUpWithCredential(AuthCredential credential) async {
    try {
      final UserCredential userCredential =
          await _firebaseAuth.signInWithCredential(credential);
      final bool userExists = await checkIfUserExists(userCredential.user!.uid);

      if (!userExists) {
        MyUser myUser = MyUser(
          userId: userCredential.user!.uid,
          imageUrl: userCredential.user!.photoURL ?? "",
          email: userCredential.user!.email!,
          fullName: userCredential.user!.displayName ?? "",
          phoneNumber: userCredential.user!.phoneNumber ?? "",
          address: "",
          userType: "user",
          createAt: DateTime.now(),
          updateAt: DateTime.now(),
          status: 0,
          isBlocked: false,
        );

        await userCollection.doc(myUser.userId).set(myUser.toJson());
        return true;
      }
      return false; // Don't create user if it already exists
    } catch (e) {
      log('Sign-Up Error: ${e.toString()}');
      return false;
    }
  }

  Future<bool> checkIfUserExists(String userId) async {
    try {
      final userDoc = await userCollection.doc(userId).get();
      return userDoc.exists;
    } catch (e) {
      log('Error checking if user exists: $e');
      return false;
    }
  }

  @override
  Future<void> blockUser(String userId) async {
    try {
      await userCollection.doc(userId).update({
        'is_blocked': true,
      });
    } catch (e) {
      log('Error blocking user: $e');
      throw Exception('Unable to block user.');
    }
  }

  @override
  Future<bool> isUserBlocked(String userId) async {
    try {
      DocumentSnapshot userDoc = await userCollection.doc(userId).get();

      if (userDoc.exists) {
        return (userDoc.data() as Map<String, dynamic>)['is_blocked'] ?? false;
      }
    } catch (e) {
      log('Error checking if user is blocked: $e');
    }
    return false;
  }

  @override
  Future<void> unblockUser(String userId) async {
    try {
      await userCollection.doc(userId).update({
        'is_blocked': false,
      });
    } catch (e) {
      log('Error unblocking user: $e');
      throw Exception('Unable to unblock user.');
    }
  }

  @override
  Future<MyUser?> getCurrentUserProfile() async {
    try {
      User? currentUser = _firebaseAuth.currentUser;

      if (currentUser == null) {
        return null; // Return null if no user is logged in
      }

      DocumentSnapshot userDoc =
          await userCollection.doc(currentUser.uid).get();

      if (userDoc.exists) {
        // Return MyUser directly, no need to cast
        return MyUser.fromDocument(
            userDoc.data() as Map<String, dynamic>, currentUser.uid);
      }
    } catch (e) {
      log('Error fetching user profile: $e');
    }
    return null; // Return null if user not found or any error occurred
  }

  @override
  Future<MyUser?> getCurrentUserUpdate(String userId, MyUser myUser) async {
    try {
      DocumentSnapshot doc = await userCollection.doc(userId).get();

      if (doc.exists) {
        await userCollection.doc(userId).update(myUser.toJson());

        // Fetch and return the updated user data
        DocumentSnapshot updatedDoc = await userCollection.doc(userId).get();
        return MyUser.fromDocument(
            updatedDoc.data() as Map<String, dynamic>, userId);
      }
      return null; // Return null if user does not exist
    } catch (error) {
      // Handle error
      throw Exception("Failed to fetch or update user: $error");
    }
  }

  Future<List<MyUser>> getAllUsers() async {
    try {
      QuerySnapshot snapshot = await userCollection.get();

      List<MyUser> userList = snapshot.docs.map((doc) {
        return MyUser.fromDocument(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();

      return userList; 
    } catch (error) {
      //  error
      throw Exception("Failed to fetch users: $error");
    }
  }
}
