import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../components/widget/background_header_widget.dart';
import '../../../../services/repository/annex_service.dart';
import '../../../../model/annex/annex_model.dart';

class AllProvincesScreen extends StatefulWidget {
  final String provinces;

  const AllProvincesScreen({super.key, required this.provinces});

  @override
  State<AllProvincesScreen> createState() => _AllProvincesScreenState();
}

class _AllProvincesScreenState extends State<AllProvincesScreen> {
  final AnnexService _annexService = AnnexService();
  List<AnnexModel> _annexes = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchUserAnnexes();
  }

  Future<void> _fetchUserAnnexes() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null; // Reset any previous error message
    });

    try {
      final annexes = await _annexService.allProvincesDetails(widget.provinces);
      setState(() {
        _annexes = annexes;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Background header with title
              BackgroundHeaderWidget(
                headerText: "Annexes in ${widget.provinces}",
                subText: "",
              ),
              const SizedBox(height: 10),

              // Loading indicator or error message
              if (_isLoading)
                const Center(child: CircularProgressIndicator())
              else if (_errorMessage != null)
                Center(child: Text(_errorMessage!))
              else if (_annexes.isEmpty)
                const Center(child: Text('No annexes found for this province'))
              else
                // Grid view for displaying annexes
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // Number of columns
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 3 / 3,
                    ),
                    itemCount: _annexes.length,
                    itemBuilder: (context, index) {
                      return buildAnnexCard(_annexes[index]);
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // Formats the price to Sri Lankan currency format
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

  // Builds each annex card
  Widget buildAnnexCard(AnnexModel annex) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context, rootNavigator: true)
            .pushNamed('/single_view', arguments: {
          'annex': annex,
        });
      },
      child: Card(
        elevation: 4,
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                annex.imageUrls!.isNotEmpty
                    ? annex.imageUrls![0]
                    : 'https://via.placeholder.com/150',
                fit: BoxFit.cover,
                width: double.infinity,
                height: 150, // Fixed height for the image
              ),
            ),
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
                    const SizedBox(height: 8),
                    Text(
                      formatPrice(annex.price), // Use formatted price
                      style: const TextStyle(
                          fontSize: 16, color: Colors.greenAccent),
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
}
