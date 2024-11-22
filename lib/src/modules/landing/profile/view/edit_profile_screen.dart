import 'dart:io'; // For File type
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import 'package:annex_finder/src/model/user_model/user_model.dart';
import 'package:annex_finder/src/modules/auth/bloc/current_user/current_user_bloc.dart';

class EditProfileScreen extends StatefulWidget {
  final MyUser myUser;
  const EditProfileScreen({super.key, required this.myUser});

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _fullNameController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;

  File? _imageFile; // To store the selected image
  final ImagePicker _picker = ImagePicker(); // Initialize ImagePicker

  bool _isAnnexScheduler = false; // For the switch

  @override
  void initState() {
    super.initState();
    _fullNameController =
        TextEditingController(text: widget.myUser.fullName ?? '');
    _phoneController =
        TextEditingController(text: widget.myUser.phoneNumber ?? '');
    _addressController =
        TextEditingController(text: widget.myUser.address ?? '');

    _isAnnexScheduler = widget.myUser.userType == 'annex scheduler';
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  // Image picking function
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: BlocBuilder<CurrentUserBloc, CurrentUserState>(
        builder: (context, state) {
          if (state is CurrentUserLoaded) {
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    const SizedBox(height: 20),
                    Center(
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: 60,
                            backgroundImage: _imageFile != null
                                ? FileImage(_imageFile!)
                                : state.user.imageUrl != null
                                    ? NetworkImage(state.user.imageUrl!)
                                    : const AssetImage(
                                            'assets/images/default_avatar.png')
                                        as ImageProvider,
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: IconButton(
                              icon: const Icon(Icons.camera_alt),
                              onPressed: _pickImage, // Open image picker
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    _buildTextField(
                      label: 'Full Name',
                      controller: _fullNameController,
                      icon: Icons.person,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your full name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    _buildTextField(
                      label: 'Phone Number',
                      controller: _phoneController,
                      icon: Icons.phone,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your phone number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    _buildTextField(
                      label: 'Address',
                      controller: _addressController,
                      icon: Icons.location_on,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your address';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    SwitchListTile(
                      title: const Text('Annex Scheduler'),
                      value: _isAnnexScheduler,
                      onChanged: (value) {
                        setState(() {
                          _isAnnexScheduler = value;
                        });
                      },
                    ),

                    const SizedBox(height: 40),
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          final userType =
                              _isAnnexScheduler ? 'annex scheduler' : 'user';

                          final updatedUser = widget.myUser.copyWith(
                            fullName: _fullNameController.text.trim(),
                            phoneNumber: _phoneController.text.trim(),
                            address: _addressController.text.trim(),
                            updateAt: DateTime.now(),
                            userType:
                                userType, 
                          );

                          context.read<CurrentUserBloc>().add(
                                CurrentUserUpdateEvent(
                                  userId: widget.myUser.userId!,
                                  myUser: updatedUser,
                                  imageFile: _imageFile,
                                ),
                              );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 14),
                        iconColor: Colors.deepPurple,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text(
                        'Save Changes',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else if (state is CurrentUserLoading) { 
            return const Center(child: CircularProgressIndicator());
          } else {
            return const Center(child: Text('Error loading user data.'));
          }
        },
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    required String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.deepPurple),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
