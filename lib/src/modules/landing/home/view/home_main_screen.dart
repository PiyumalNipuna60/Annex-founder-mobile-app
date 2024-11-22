import 'package:annex_finder/src/modules/ai_app_review.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:annex_finder/src/components/button/app_main_button.dart';
import 'package:annex_finder/src/components/widget/background_header_widget.dart';
import 'package:annex_finder/src/components/widget/from_card_widget.dart';
import 'package:annex_finder/src/res/color/app_color.dart';
import 'package:intl/intl.dart';

import '../../../../model/annex/annex_model.dart';
import '../../../../services/repository/annex_service.dart';

class HomeMainScreen extends StatefulWidget {
  const HomeMainScreen({super.key});

  @override
  State<HomeMainScreen> createState() => _HomeMainScreenState();
}

class _HomeMainScreenState extends State<HomeMainScreen> {
  List<AnnexModel> _annexes = [];
  List<AnnexModel> _filteredAnnexes = []; // New filtered list
  bool _isLoading = true;
  String? _errorMessage;

  final AnnexService _annexService = AnnexService();

  @override
  void initState() {
    super.initState();
    _fetchUserAnnexes();
  }

  Future<void> _fetchUserAnnexes() async {
    String userId = FirebaseAuth.instance.currentUser!.uid;

    try {
      final annexes = await _annexService.allAnnexDetails(userId);
      setState(() {
        _annexes = annexes;
        _filteredAnnexes = annexes; // Initially, all annexes are shown
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error fetching annexes: $e';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching annexes: $e')),
      );
    }
  }

  void _filterAnnexes(String searchTerm) {
    setState(() {
      searchTerm = searchTerm.toLowerCase();

      _filteredAnnexes = _annexes.where((annex) {
        return annex.location != null &&
            annex.location!.toLowerCase().contains(searchTerm);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            buildSearchSection(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Recently Added Properties",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "${_filteredAnnexes.length} Result", // Use filtered list here
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : buildPropertyList(),
          ],
        ),
      ),
    );
  }

  Widget buildSearchSection() {
    TextEditingController searchController = TextEditingController();

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          const BackgroundHeaderWidget(headerText: "Annex Finder", subText: ""),
          FromCardWidget(
            widget: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Find a property anywhere",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      labelText: 'Search for properties',
                      hintText: 'Enter location, property type...',
                      prefixIcon: Icon(
                        Icons.location_on,
                        color: ColorUtil.simpleBlueColor[10]!,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: AppMainButton(
                      testName: "Search Now",
                      onTap: () {
                        _filterAnnexes(searchController.text);
                        setState(() {});
                      },
                      height: 45,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildPropertyList() {
    return ListView.builder(
      itemCount: _filteredAnnexes.length,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        final annex = _filteredAnnexes[index];

        return buildPropertyCard(
          onTap: () {
            Navigator.of(context, rootNavigator: true)
                .pushNamed('/single_view', arguments: {
              'annex': annex,
            });
          },
          title: annex.title ?? "No Title",
          price: annex.price ?? "Price Not Available",
          distance: annex.location ?? "N/A",
          rating: annex.rating?.toDouble() ?? 0.0,
          availability: annex.annexStatus == 1 ? "Available" : "Unavailable",
          imageUrl: annex.imageUrls != null && annex.imageUrls!.isNotEmpty
              ? annex.imageUrls![0]
              : 'https://via.placeholder.com/100',
        );
      },
    );
  }
// Add this import

// Inside your widget
  Widget buildPropertyCard({
    required Function() onTap,
    required String title,
    required String
        price, // Assume this is a String that can be converted to double
    required String distance,
    required double rating,
    required String availability,
    required String imageUrl,
  }) {
    // Format price in Sri Lankan format
    final formatter = NumberFormat.simpleCurrency(locale: 'en_LK');
    String formattedPrice = "Price Not Available"; // Default value

    try {
      double parsedPrice = double.parse(price); // Convert price to double
      formattedPrice =
          formatter.format(parsedPrice); // Format as Sri Lankan currency
    } catch (e) {
      // Handle invalid price format
      formattedPrice = "Price Not Available";
    }

    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Card(
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    imageUrl,
                    width: 100,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              title,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.green[100],
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              "$rating★",
                              style: const TextStyle(
                                color: Colors.green,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      // Use formatted price here
                      Text(
                        formattedPrice,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.location_on,
                                size: 14,
                                color: Colors.grey,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                distance,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const SizedBox(width: 3),
                              Text(
                                availability,
                                style: const TextStyle(
                                  color: Colors.blue,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ],
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
}
