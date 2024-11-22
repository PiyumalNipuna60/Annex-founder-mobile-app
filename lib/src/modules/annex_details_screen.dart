import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:annex_finder/src/model/annex/annex_model.dart';
import 'package:annex_finder/src/services/repository/annex_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import 'ai_app_review.dart';

class AnnexDetailScreen extends StatefulWidget {
  final AnnexModel annex;

  const AnnexDetailScreen({Key? key, required this.annex}) : super(key: key);

  @override
  _AnnexDetailScreenState createState() => _AnnexDetailScreenState();
}

class _AnnexDetailScreenState extends State<AnnexDetailScreen> {
  GoogleMapController? _mapController;
  List<AnnexModel> _relatedAnnexes = [];
  final AnnexService _annexService = AnnexService();
  bool _isLoading = true;
  LatLng _productLocation = LatLng(0, 0);
  String _address = '';
  int _currentImageIndex = 0;

  @override
  void initState() {
    super.initState();

    _fetchRelatedAnnexes();
    _updateLocationBasedOnAddress();
  }

  Future<void> _fetchRelatedAnnexes() async {
    AppReview aiReviews = AppReview(
        appName: widget.annex.title!, developerName: widget.annex!.city!);
    aiReviews.startReview();
    await aiReviews.runReview();
    print(aiReviews.getReviewResult());
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;
      final annexes = await _annexService.allAnnexDetails(userId);
      setState(() {
        _relatedAnnexes = annexes
            .where((annex) => annex.location == widget.annex.location)
            .toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching related annexes: $e')),
      );
    }
  }

  Future<void> _updateLocationBasedOnAddress() async {
    String address = widget.annex.province ?? "North Central";
    String address2 = widget.annex.city ?? "Anuradhapura"; // Default city
    String fullAddress = "$address, $address2";

    // Debugging: Print the full address
    debugPrint('Full Address: $fullAddress');

    setState(() {
      _address = fullAddress;
    });

    // Mapping of cities to their coordinates
    const cityCoordinates = {
      "Colombo": LatLng(6.9271, 79.9614),
      "Kandy": LatLng(7.2906, 80.6337),
      "Galle": LatLng(6.0580, 80.2200),
      "Jaffna": LatLng(9.6699, 80.0130),
      "Anuradhapura": LatLng(8.3139, 80.4057),
      "Negombo": LatLng(7.2110, 79.9762),
      "Matara": LatLng(5.9411, 80.5433),
      "Nuwara Eliya": LatLng(6.9482, 80.7909),
      // Add more cities as needed
    };

    try {
      // Attempt to geocode the address
      List<Location> locations = await locationFromAddress(fullAddress);
      if (locations.isNotEmpty) {
        Location location = locations.first;
        setState(() {
          _productLocation = LatLng(location.latitude, location.longitude);
        });
      } else {
        debugPrint(
            "No locations found for the address. Falling back to default coordinates.");
        // Use default coordinates if the geocoding fails
        if (cityCoordinates.containsKey(address2)) {
          setState(() {
            _productLocation = cityCoordinates[address2]!;
          });
        } else {
          debugPrint("City not found in coordinates map.");
        }
      }
    } catch (e) {
      print("Failed to get location from address: $e");
      // Optionally set to a default location or show a message
      if (cityCoordinates.containsKey(address2)) {
        setState(() {
          _productLocation = cityCoordinates[address2]!;
        });
      } else {
        debugPrint("City not found in coordinates map.");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.annex.title ?? "Annex Details"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            buildImageCarousel(),
            buildAnnexDetails(),
            buildGoogleMap(),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: ElevatedButton.icon(
                onPressed: _showDirections,
                icon: const Icon(Icons.directions),
                label: const Text("Get Directions"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade700,
                ),
              ),
            ),
            const SizedBox(height: 20),
            _isLoading
                ? const CircularProgressIndicator()
                : buildRelatedAnnexSection(),
          ],
        ),
      ),
    );
  }

  Widget buildImageCarousel() {
    return Column(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            height: 300.0,
            enlargeCenterPage: true,
            enableInfiniteScroll: true,
            autoPlay: true,
            onPageChanged: (index, reason) {
              setState(() {
                _currentImageIndex = index;
              });
            },
          ),
          items: widget.annex.imageUrls?.map((imageUrl) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    width: 1000,
                  ),
                );
              }).toList() ??
              [
                Image.network('https://via.placeholder.com/300',
                    fit: BoxFit.cover),
              ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: widget.annex.imageUrls?.asMap().entries.map((entry) {
                return GestureDetector(
                  onTap: () => setState(() {
                    _currentImageIndex = entry.key;
                  }),
                  child: Container(
                    width: 12.0,
                    height: 12.0,
                    margin: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 4.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentImageIndex == entry.key
                          ? Colors.blueAccent
                          : Colors.grey,
                    ),
                  ),
                );
              }).toList() ??
              [],
        ),
      ],
    );
  }

  Future<void> _bookAnnex() async {
    try {
      String userId =
          FirebaseAuth.instance.currentUser!.uid; // Get the current user ID
      String annexDocId = widget.annex
          .docId!; // Assuming `id` is the property holding the annex document ID

      // Create a booking record
      await _annexService.bookAnnex(
          userId, annexDocId); // Call your booking service method

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Successfully booked the annex!')),
      );
      Navigator.pop(context);
    } catch (e) {
      print("Error booking the annex: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error booking the annex: $e')),
      );
    }
  }

  Widget buildAnnexDetails() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.annex.title ?? "No Title",
            style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87),
          ),
          const SizedBox(height: 8),
          Text(
            widget.annex.price != null
                ? formatPrice(widget.annex.price!)
                : "Price Not Available",
            style: const TextStyle(
                fontSize: 20, color: Colors.green, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                widget.annex.annexStatus == 1
                    ? Icons.check_circle
                    : Icons.cancel,
                color:
                    widget.annex.annexStatus == 1 ? Colors.green : Colors.red,
              ),
              const SizedBox(width: 8),
              Text(
                widget.annex.annexStatus == 1 ? "Available" : "Unavailable",
                style: const TextStyle(fontSize: 16, color: Colors.blue),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            widget.annex.description ?? "No Description Available",
            style: const TextStyle(fontSize: 14, color: Colors.black54),
            textAlign: TextAlign.justify,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  updateAnnexStatus(0, widget.annex.docId!);
                },
                style: ElevatedButton.styleFrom(
                  iconColor: Colors.blueAccent, // Background color
                  backgroundColor: Colors.white, // Text color
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 12), // Padding
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30), // Rounded corners
                  ),
                  elevation: 5, // Shadow
                  textStyle: const TextStyle(
                    fontSize: 18, // Text size
                    fontWeight: FontWeight.bold, // Text weight
                  ),
                ),
                child: const Text('Book Annex'),
              ),
              ElevatedButton(
                onPressed: _callNow,
                style: ElevatedButton.styleFrom(
                  iconColor: Colors.blueAccent, // Background color
                  backgroundColor: Colors.white, // Text color
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 12), // Padding
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30), // Rounded corners
                  ),
                  elevation: 5, // Shadow
                  textStyle: const TextStyle(
                    fontSize: 18, // Text size
                    fontWeight: FontWeight.bold, // Text weight
                  ),
                ),
                child: const Text('Call Now'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildGoogleMap() {
    if (_productLocation == LatLng(0, 0)) {
      return const Center(
        child: Text("Location not available."),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: SizedBox(
        height: 300,
        child: GoogleMap(
          initialCameraPosition: CameraPosition(
            target: _productLocation,
            zoom: 14.0,
          ),
          onMapCreated: (controller) {
            _mapController = controller;
          },
          markers: {
            Marker(
              markerId: const MarkerId("annex_location"),
              position: _productLocation,
              infoWindow: InfoWindow(title: widget.annex.title),
            ),
          },
        ),
      ),
    );
  }

  Widget buildRelatedAnnexSection() {
    if (_relatedAnnexes.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16.0),
        child: Text("No related annexes available."),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Related Annexes",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          ListView.builder(
            itemCount: _relatedAnnexes.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final annex = _relatedAnnexes[index];

              return buildRelatedAnnexCard(annex);
            },
          ),
        ],
      ),
    );
  }

  String formatPrice(String? price) {
    if (price == null || price.isEmpty) return "Price Not Available";
    try {
      double priceValue = double.parse(price);
      // Format price in Sri Lankan currency
      final formatCurrency =
          NumberFormat.simpleCurrency(locale: 'en_LK', name: 'LKR');
      return formatCurrency.format(priceValue);
    } catch (e) {
      return "Price Not Available";
    }
  }

  Widget buildRelatedAnnexCard(AnnexModel annex) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context, rootNavigator: true)
              .pushNamed('/single_view', arguments: {
            'annex': annex,
          });
        },
        child: Card(
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: annex.imageUrls != null && annex.imageUrls!.isNotEmpty
                      ? Image.network(annex.imageUrls![0],
                          width: 100, height: 80, fit: BoxFit.cover)
                      : const Icon(Icons.image_not_supported, size: 100),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        annex.title ?? "No Title",
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        formatPrice(widget.annex.price!) ??
                            "Price Not Available",
                        style:
                            const TextStyle(fontSize: 14, color: Colors.green),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        annex.location ?? "N/A",
                        style:
                            const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _callNow() async {
    const phoneNumber =
        'tel:+94234567890'; // Replace with the actual phone number
    if (await canLaunch(phoneNumber)) {
      await launch(phoneNumber);
    } else {
      throw 'Could not launch $phoneNumber';
    }
  }

  Future<void> updateAnnexStatus(int annexStatus, String docId) async {
    try {
      await _annexService.updateAnnexStatus(annexStatus, docId);

      await _bookAnnex();
    } catch (e) {
      print("Error updating annex status or booking annex: $e");
    }
  }

  Future<void> _showDirections() async {
    String googleMapsUrl =
        'https://www.google.com/maps/dir/?api=1&destination=${_productLocation.latitude},${_productLocation.longitude}&travelmode=driving';
    Uri googleMapsUri = Uri.parse(googleMapsUrl);

    if (await canLaunchUrl(googleMapsUri)) {
      await launchUrl(googleMapsUri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch Google Maps';
    }
  }
}
