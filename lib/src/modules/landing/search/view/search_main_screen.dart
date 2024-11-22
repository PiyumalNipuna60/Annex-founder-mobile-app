import 'package:annex_finder/src/model/annex/annex_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../../components/button/app_main_button.dart';
import '../../../../components/widget/background_header_widget.dart';
import '../../../../components/widget/from_card_widget.dart';
import '../../../../res/color/app_color.dart';
import '../../../../services/repository/annex_service.dart';

class SearchMainScreen extends StatefulWidget {
  const SearchMainScreen({super.key});

  @override
  State<SearchMainScreen> createState() => _SearchMainScreenState();
}

class _SearchMainScreenState extends State<SearchMainScreen> {
  final AnnexService _annexService = AnnexService();
  List<AnnexModel> _annexes = []; // Holds all annexes
  List<AnnexModel> _filteredAnnexes = []; // Holds filtered annexes
  String? _selectedProvince; // Holds the currently selected province
  bool _isLoading = true; // Loading state
  String? _errorMessage; // Error message state

  // Define provinces (you may need to adjust this based on your requirements)
  final List<String> _provinces = [
    "Western",
    "Central",
    "Southern",
    "Northern",
    "Eastern",
    "North Western",
    "Uva",
    "Sabaragamuwa",
  ];

  @override
  void initState() {
    super.initState();
    _fetchUserAnnexes();
  }

  Future<void> _fetchUserAnnexes() async {
    try {
      final userId = FirebaseAuth.instance.currentUser!.uid;
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

  // Filter annexes by selected province
  void _filterAnnexesByProvince(String province) {
    setState(() {
      _selectedProvince = province;
      _filteredAnnexes =
          _annexes.where((annex) => annex.province == province).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              buildSearchSection(),
              buildProvinceDropdown(), // Add the dropdown for province selection
              const SizedBox(height: 10),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Locations",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              if (_isLoading)
                const CircularProgressIndicator() // Show loading indicator
              else if (_errorMessage != null)
                Text(_errorMessage!) // Show error message if any
              else if (_filteredAnnexes.isEmpty)
                const Text(
                    'No annexes found for this province') // No annexes message
              else
                SizedBox(
                  height: 400,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: GridView.builder(
                      physics: const BouncingScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, // Number of columns
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio:
                            0.75, // Aspect ratio for each grid item
                      ),
                      itemCount: _filteredAnnexes.length,
                      itemBuilder: (context, index) {
                        final annex = _filteredAnnexes[index];
                        return buildAnnexCard(annex);
                      },
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // Builds the province dropdown
  Widget buildProvinceDropdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: DropdownButton<String>(
        value: _selectedProvince,
        hint: const Text('Select Province'),
        isExpanded: true,
        items: _provinces.map((province) {
          return DropdownMenuItem<String>(
            value: province,
            child: Text(province),
          );
        }).toList(),
        onChanged: (value) {
          _filterAnnexesByProvince(
              value!); // Filter annexes based on selected province
        },
      ),
    );
  }

  // Builds each annex card
  Widget buildAnnexCard(AnnexModel annex) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/provinces_screen', arguments: {
          'provinces': annex.province,
        });
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: Stack(
          children: [
            // Background image
            ClipRRect(
              borderRadius:
                  BorderRadius.circular(8), // Match the card's border radius
              child: Image.network(
                annex.imageUrls!.isNotEmpty
                    ? annex.imageUrls![0]
                    : 'https://via.placeholder.com/150',
                fit: BoxFit.cover,
                width: double.infinity,
                height: 150, // Set a fixed height for the image
              ),
            ),
            // Card content
            Positioned.fill(
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.black54, // Semi-transparent overlay
                  borderRadius: BorderRadius.circular(
                      8), // Match the card's border radius
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      annex.title ?? "No Title",
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      annex.province ?? "No Province",
                      style: const TextStyle(fontSize: 14, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Search section widget
  Widget buildSearchSection() {
    TextEditingController cityController = TextEditingController();
    TextEditingController residentController = TextEditingController();

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
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  buildSearchField(cityController),
                  const SizedBox(height: 16),
                  buildSearchField(residentController),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: AppMainButton(
                      testName: "Search Now",
                      onTap: () {
                        // Implement search logic
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

  // Search field widget for reuse
  Widget buildSearchField(TextEditingController controller) {
    return TextField(
      controller: controller,
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
    );
  }
}
