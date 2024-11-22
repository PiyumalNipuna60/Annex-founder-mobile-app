import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../../model/annex/annex_model.dart';
import '../../../../services/repository/annex_service.dart';
import 'annex_scheduling_screen.dart';

class AnnexListScreen extends StatefulWidget {
  const AnnexListScreen({super.key});

  @override
  _AnnexListScreenState createState() => _AnnexListScreenState();
}

class _AnnexListScreenState extends State<AnnexListScreen> {
  final AnnexService _annexService = AnnexService();
  List<AnnexModel> _annexes = [];
  bool _isLoading = true; // Track loading state
  String _errorMessage = ''; // Track any error messages

  @override
  void initState() {
    super.initState();
    _fetchUserAnnexes();
  }

  Future<void> _fetchUserAnnexes() async {
    String userId = FirebaseAuth.instance.currentUser!.uid;

    try {
      final annexes = await _annexService.getAnnexDetails(userId);
      setState(() {
        _annexes = annexes;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error fetching annexes: $e'; // Set error message
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching annexes: $e')),
      );
    }
  }

  void _editAnnex(AnnexModel annex) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AnnexSchedulingScreen(annexModel: annex),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Annexes'),
        backgroundColor: Colors.deepPurple,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error, color: Colors.red, size: 60),
                        const SizedBox(height: 16),
                        Text(
                          _errorMessage,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                )
              : _annexes.isEmpty
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.folder_open,
                                size: 80, color: Colors.grey),
                            SizedBox(height: 16),
                            Text(
                              'No annexes found',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _annexes.length,
                      itemBuilder: (context, index) {
                        final annex = _annexes[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 4,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListTile(
                              leading: SizedBox(
                                width: 60,
                                height: 60,
                                child: ClipOval(
                                  child: annex.imageUrls!.isNotEmpty
                                      ? Image.network(
                                          annex.imageUrls![0],
                                          width: 60,
                                          height: 60,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) =>
                                                  const Icon(Icons.error,
                                                      color: Colors.red),
                                          loadingBuilder: (context, child,
                                              loadingProgress) {
                                            if (loadingProgress == null)
                                              return child;
                                            return const CircularProgressIndicator(
                                              strokeWidth: 2,
                                            );
                                          },
                                        )
                                      : const Icon(Icons.image,
                                          size: 60, color: Colors.grey),
                                ),
                              ),
                              title: Text(
                                annex.title!,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                annex.location!,
                                style: const TextStyle(
                                    fontSize: 14, color: Colors.grey),
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.edit,
                                    color: Colors.deepPurple),
                                onPressed: () => _editAnnex(annex),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
    );
  }
}
