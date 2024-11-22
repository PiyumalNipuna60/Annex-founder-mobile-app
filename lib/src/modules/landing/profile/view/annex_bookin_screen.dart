import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AnnexBookingsScreen extends StatefulWidget {
  final String annexDocId;

  AnnexBookingsScreen({required this.annexDocId});

  @override
  _AnnexBookingsScreenState createState() => _AnnexBookingsScreenState();
}

class _AnnexBookingsScreenState extends State<AnnexBookingsScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> _fetchUsersByAnnexId() async {
    List<Map<String, dynamic>> userDetails = [];

    try {
      // Fetch bookings for the specified annexDocId
      QuerySnapshot bookingsSnapshot = await _firestore
          .collection('bookings')
          .where('annexDocId', isEqualTo: widget.annexDocId)
          .get();

      for (var bookingDoc in bookingsSnapshot.docs) {
        String userId = bookingDoc['userId'];

        // Fetch user details for each userId
        DocumentSnapshot userDoc =
            await _firestore.collection('users').doc(userId).get();

        if (userDoc.exists) {
          userDetails.add(userDoc.data() as Map<String, dynamic>);
        }
      }
    } catch (e) {
      print("Error fetching users: $e");
    }

    return userDetails;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Booked Users for Annex'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchUsersByAnnexId(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No bookings found.'));
          }

          final users = snapshot.data!;

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];

              return Card(
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundImage: user['image_url'] != null &&
                                user['image_url'].isNotEmpty
                            ? NetworkImage(user['image_url'])
                            : AssetImage('assets/images/placeholder.png')
                                as ImageProvider<
                                    Object>, // Fallback to placeholder
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user['full_name'],
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text('Email: ${user['email']}'),
                            Text('Address: ${user['address']}'),
                            Text('Phone: ${user['phone_number']}'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
