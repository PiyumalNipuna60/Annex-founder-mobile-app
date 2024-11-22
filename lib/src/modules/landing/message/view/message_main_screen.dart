import 'package:annex_finder/src/services/repository/users_service.dart';
import 'package:flutter/material.dart';
import '../../../../model/user_model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MessageMainScreen extends StatefulWidget {
  const MessageMainScreen({super.key});

  @override
  State<MessageMainScreen> createState() => _MessageMainScreenState();
}

class _MessageMainScreenState extends State<MessageMainScreen> {
  final UsersService _usersService = UsersService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // State variables
  List<MyUser> _allUsers = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchAllUsers(); // Fetch users when the widget is initialized
  }

  Future<void> _fetchAllUsers() async {
    setState(() {
      _isLoading = true; // Start loading
      _errorMessage = null; // Reset error message
    });

    try {
      final allUsers = await _usersService.getAllUsers(); // Await the future

      // Get the current user's ID
      String currentUserId = _firebaseAuth.currentUser?.uid ?? "";

      // Filter out the current user
      _allUsers =
          allUsers.where((user) => user.userId != currentUserId).toList();

      // Check if the widget is still mounted before calling setState
      if (mounted) {
        setState(() {
          _isLoading = false; // Loading complete
        });
      }
    } catch (e) {
      // Check if the widget is still mounted before calling setState
      if (mounted) {
        setState(() {
          _isLoading = false; // Loading complete even in error case
          _errorMessage = 'Error fetching users: $e'; // Set error message
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error fetching users: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Messages')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(child: Text(_errorMessage!))
              : ListView.builder(
                  itemCount: _allUsers.length,
                  itemBuilder: (context, index) {
                    final user = _allUsers[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 16),
                      elevation: 4,
                      child: ListTile(
                        leading: CircleAvatar(
                          radius: 30,
                          backgroundImage: user.imageUrl!.isNotEmpty
                              ? NetworkImage(user.imageUrl!)
                              : const AssetImage('assets/default_avatar.png')
                                  as ImageProvider, // Placeholder
                        ),
                        title: Text(
                          user.fullName!,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(user.email!),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          // Navigate to messenger screen
                          Navigator.pushNamed(context, '/message_screen',
                              arguments: {
                                'current_id':
                                    FirebaseAuth.instance.currentUser!.uid,
                                'user_id': user.userId,
                                'user_name': user.fullName,
                              });
                        },
                      ),
                    );
                  },
                ),
    );
  }
}
