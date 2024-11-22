import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import '../../../../model/annex/annex_model.dart';
import '../../../../model/booking_model.dart';
import '../../../../services/repository/booking_service.dart';

class BookingScreen extends StatelessWidget {
  const BookingScreen({super.key});

  Future<List<BookingModel>> _getUserBookings() async {
    BookingService bookingService = BookingService();
    return await bookingService.getUserBookings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Bookings'),
      ),
      body: FutureBuilder<List<BookingModel>>(
        future: _getUserBookings(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No bookings found.'));
          }

          final bookings = snapshot.data!;

          return ListView.builder(
            itemCount: bookings.length,
            itemBuilder: (context, index) {
              final booking = bookings[index];
              final formattedDate =
                  DateFormat.yMMMd().format(booking.timestamp);

              return FutureBuilder<AnnexModel?>(
                future: _getAnnexDetails(booking.annexDocId),
                builder: (context, annexSnapshot) {
                  if (annexSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return ListTile(
                      title: const Text('Loading annex details...'),
                    );
                  }

                  if (annexSnapshot.hasError || !annexSnapshot.hasData) {
                    return ListTile(
                      title: const Text('Annex details not available.'),
                    );
                  }

                  final annex = annexSnapshot.data!;
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      elevation: 5,
                      child: InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, '/booking_screen',
                              arguments: {
                                'annexId': booking.annexDocId,
                              });
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Annex Image
                            ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(15.0),
                                topRight: Radius.circular(15.0),
                              ),
                              child: Image.network(
                                annex.imageUrls![0], // Main annex image
                                height: 200,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Annex Title
                                  Text(
                                    annex.title!,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  // Booking Date
                                  Text(
                                    'Booked on: $formattedDate',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  // Annex Location
                                  Text(
                                    '${annex.location}, ${annex.city}, ${annex.province}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  Future<AnnexModel?> _getAnnexDetails(String annexDocId) async {
    final doc = await FirebaseFirestore.instance
        .collection('annexes')
        .doc(annexDocId)
        .get();

    if (doc.exists) {
      return AnnexModel.fromJson(doc.data()!, doc.id);
    }

    return null;
  }
}
