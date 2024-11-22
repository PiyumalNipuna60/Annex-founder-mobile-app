import 'dart:io'; // For File handling
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../model/annex/annex_model.dart';
import '../block/annex/annex_bloc.dart';
import '../block/annex/annex_event.dart';
import '../block/annex/annex_state.dart';

class AnnexSchedulingScreen extends StatefulWidget {
  final AnnexModel? annexModel;
  const AnnexSchedulingScreen({super.key, this.annexModel});

  @override
  _AnnexSchedulingScreenState createState() => _AnnexSchedulingScreenState();
}

class _AnnexSchedulingScreenState extends State<AnnexSchedulingScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _locationController;
  late TextEditingController _cityController;
  late TextEditingController _provinceController;
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;

  List<File> _imageFiles = [];
  List<String> _imageUrls = []; // Separate list for uploaded image URLs
  final ImagePicker _picker = ImagePicker();
  String? _provinceImageUrl;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _locationController = TextEditingController();
    _cityController = TextEditingController();
    _provinceController = TextEditingController();
    _descriptionController = TextEditingController();
    _priceController = TextEditingController();

    if (widget.annexModel != null) {
      _titleController.text = widget.annexModel!.title!;
      _locationController.text = widget.annexModel!.location!;
      _cityController.text = widget.annexModel!.city!;
      _provinceController.text = widget.annexModel!.province!;
      _descriptionController.text = widget.annexModel!.description!;
      _priceController.text = widget.annexModel!.price!;
      // No need to convert URLs to File objects
      _imageUrls = widget.annexModel!.imageUrls ?? [];
      _provinceImageUrl = widget.annexModel!.provinceImage;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _locationController.dispose();
    _cityController.dispose();
    _provinceController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _pickImages() async {
    final pickedFiles = await _picker.pickMultiImage();
    if (pickedFiles.isNotEmpty) {
      List<File> selectedImages =
          pickedFiles.map((file) => File(file.path)).toList();

      // Check for annex-related images
      List<File> relatedImages = [];
      List<File> unrelatedImages = [];

      for (var image in selectedImages) {
        bool isRelated = await isImageRelatedToAnnex(image);
        if (isRelated) {
          relatedImages.add(image);
        } else {
          unrelatedImages.add(image);
        }
      }

      setState(() {
        if (_imageFiles.length + relatedImages.length <= 5) {
          _imageFiles.addAll(relatedImages);
          if (unrelatedImages.isNotEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(
                      '${unrelatedImages.length} images are not related to the annex.')),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('You can only select up to 5 images.')),
          );
        }
      });
    }
  }

  Future<bool> isImageRelatedToAnnex(File image) async {
    // Here you can implement your AI logic or call to an external API.
    // For demonstration, this is a mock implementation that randomly returns true or false.
    // Replace this with your actual image classification logic.
    await Future.delayed(Duration(seconds: 1)); // Simulate processing time
    return true; // Or false based on your AI logic
  }

  Future<List<String>> _uploadImages(List<File> images) async {
    List<String> downloadUrls = [];

    for (File image in images) {
      try {
        String fileName =
            '${DateTime.now().millisecondsSinceEpoch}_${image.path.split('/').last}';
        Reference ref =
            FirebaseStorage.instance.ref().child('annex_images/$fileName');
        await ref.putFile(image);
        String downloadUrl = await ref.getDownloadURL();
        downloadUrls.add(downloadUrl);
      } catch (e) {
        print("Error uploading image: $e");
      }
    }

    return downloadUrls;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Annex Scheduling'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: BlocListener<AnnexBloc, AnnexState>(
        listener: (context, state) {
          if (state is AnnexLoaded) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('Annex details updated successfully!')),
            );
            _formKey.currentState!.reset();
            setState(() {
              _imageFiles.clear();
              _imageUrls.clear(); // Clear URLs if necessary
            });
          } else if (state is AnnexError) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Error submitting annex details.")),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                _buildTextField(
                  label: 'Title',
                  controller: _titleController,
                  icon: Icons.title,
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter the annex title' : null,
                ),
                const SizedBox(height: 20),
                _buildTextField(
                  label: 'Location',
                  controller: _locationController,
                  icon: Icons.location_on,
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter the location' : null,
                ),
                const SizedBox(height: 20),
                _buildTextField(
                  label: 'City',
                  controller: _cityController,
                  icon: Icons.location_city,
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter the city' : null,
                ),
                const SizedBox(height: 20),
                _buildTextField(
                  label: 'Province',
                  controller: _provinceController,
                  icon: Icons.map,
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter the province' : null,
                  onChanged: (value) {
                    // _updateProvinceImage(value);
                  },
                ),
                const SizedBox(height: 20),
                _buildTextField(
                  label: 'Description',
                  controller: _descriptionController,
                  icon: Icons.description,
                  maxLines: 4,
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter a description' : null,
                ),
                const SizedBox(height: 20),
                _buildTextField(
                  label: 'Price',
                  controller: _priceController,
                  icon: Icons.attach_money,
                  keyboardType: TextInputType.number,
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter the price' : null,
                ),
                const SizedBox(height: 20),
                const Text(
                  'Annex Images (up to 5)',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                _imageFiles.isNotEmpty || _imageUrls.isNotEmpty
                    ? _buildImagePreviewGrid()
                    : const Text('No images selected.'),
                TextButton.icon(
                  onPressed: _pickImages,
                  icon: const Icon(Icons.image),
                  label: const Text('Select Images'),
                ),
                const SizedBox(height: 40),
                BlocBuilder<AnnexBloc, AnnexState>(builder: (context, state) {
                  if (state is AnnexLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        final user = FirebaseAuth.instance.currentUser;
                        if (user != null) {
                          final annexModel = AnnexModel(
                            userId: user.uid,
                            title: _titleController.text.trim(),
                            location: _locationController.text.trim(),
                            city: _cityController.text.trim(),
                            province: _provinceController.text.trim(),
                            description: _descriptionController.text.trim(),
                            price: _priceController.text.trim(),
                            imageUrls: [
                              ..._imageUrls,
                              ..._imageUrls
                            ], // Combine new and existing
                            provinceImage: "",
                            createdAt: DateTime.now(),
                            updatedAt: DateTime.now(),
                            annexStatus: 1,
                          );
                          if (widget.annexModel != null) {
                            annexModel.copyWith(
                                docId: widget.annexModel!.docId!);
                            context.read<AnnexBloc>().add(
                                  UpdateAnnexDetailsEvent(
                                    annexModel: annexModel,
                                    newImages: _imageFiles,
                                  ),
                                );
                          } else {
                            context.read<AnnexBloc>().add(
                                  SubmitAnnexDetailsEvent(
                                    annexModel: annexModel,
                                    newImages: _imageFiles,
                                  ),
                                );
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("User not logged in.")),
                          );
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 25),
                      backgroundColor: Colors.deepPurple,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text(
                      widget.annexModel == null ? 'Submit' : 'Update',
                      style: const TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Text Field Builder
  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    required String? Function(String?)? validator,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    void Function(String)? onChanged,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      maxLines: maxLines,
      keyboardType: keyboardType,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.deepPurple),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  // Image Preview Grid
  Widget _buildImagePreviewGrid() {
    return SizedBox(
      height: 200,
      child: GridView.builder(
        scrollDirection: Axis.horizontal,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
          mainAxisSpacing: 10,
        ),
        itemCount: _imageFiles.length + _imageUrls.length,
        itemBuilder: (context, index) {
          // Determine if displaying local file or URL
          bool isLocalFile = index < _imageFiles.length;
          return Card(
            elevation: 5,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Stack(
                children: [
                  isLocalFile
                      ? Image.file(
                          _imageFiles[index],
                          fit: BoxFit.cover,
                          width: 150,
                          height: 150,
                        )
                      : Image.network(
                          _imageUrls[index - _imageFiles.length],
                          fit: BoxFit.cover,
                          width: 150,
                          height: 150,
                        ),
                  Positioned(
                    right: 0,
                    child: IconButton(
                      icon: const Icon(Icons.remove_circle, color: Colors.red),
                      onPressed: () {
                        setState(() {
                          if (isLocalFile) {
                            _imageFiles.removeAt(index);
                          } else {
                            _imageUrls.removeAt(index - _imageFiles.length);
                          }
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
