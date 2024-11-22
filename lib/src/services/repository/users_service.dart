import 'package:cloud_firestore/cloud_firestore.dart';
import '../../model/user_model/user_model.dart';

class UsersService {
  // Firestore instance
  final FirebaseFirestore firebaseFirestore;

  // Collection reference for users
  final CollectionReference<Map<String, dynamic>> userCollection;

  // Constructor
  UsersService({FirebaseFirestore? firebaseFirestore})
      : firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance,
        userCollection = (firebaseFirestore ?? FirebaseFirestore.instance)
            .collection("users");

  // Fetch all users from the Firestore collection
  Future<List<MyUser>> getAllUsers() async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await userCollection.get();

      List<MyUser> userList = snapshot.docs.map((doc) {
        return MyUser.fromDocument(doc.data(), doc.id);
      }).toList();

      return userList;
    } catch (error) {
      // Handle error
      throw Exception("Failed to fetch users: $error");
    }
  }
}
