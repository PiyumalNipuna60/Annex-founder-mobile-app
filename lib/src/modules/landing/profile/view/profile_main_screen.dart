import 'package:annex_finder/src/modules/auth/bloc/current_user/current_user_bloc.dart';
import 'package:annex_finder/src/routes/navigators.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileMainScreen extends StatefulWidget {
  const ProfileMainScreen({super.key});

  @override
  _ProfileMainScreenState createState() => _ProfileMainScreenState();
}

class _ProfileMainScreenState extends State<ProfileMainScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      drawer: Drawer(
        child: BlocBuilder<CurrentUserBloc, CurrentUserState>(
          builder: (context, state) {
            if (state is CurrentUserLoaded) {
              final user = state.user;

              return ListView(
                padding: EdgeInsets.zero,
                children: [
                  DrawerHeader(
                    decoration: const BoxDecoration(
                      color: Colors.deepPurple,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundImage: user.imageUrl!.isNotEmpty
                              ? NetworkImage(user.imageUrl!)
                              : const AssetImage(
                                      'assets/images/default_avatar.png')
                                  as ImageProvider,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          user.fullName ?? '',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          user.email ?? '',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.home),
                    title: const Text('Profile'),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  user.userType == "annex scheduler"
                      ? ListTile(
                          leading: const Icon(Icons.home),
                          title: const Text('Booking Screen'),
                          onTap: () {
                            Navigator.pushNamed(context, '/booking_annex');
                          },
                        )
                      : const SizedBox(),
                  user.userType == "annex scheduler"
                      ? ListTile(
                          leading: const Icon(Icons.home),
                          title: const Text('Annex Schedule'),
                          onTap: () {
                            profileNavigatorKey.currentState
                                ?.pushNamed('/add_annex');
                          },
                        )
                      : const SizedBox(),
                  user.userType == "annex scheduler"
                      ? ListTile(
                          leading: const Icon(Icons.home),
                          title: const Text('My Annex'),
                          onTap: () {
                            profileNavigatorKey.currentState
                                ?.pushNamed('/list_annex');
                          },
                        )
                      : const SizedBox(),
                  ListTile(
                    leading: const Icon(Icons.settings),
                    title: const Text('Settings'),
                    onTap: () {
                      // Navigate to Settings
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.exit_to_app),
                    title: const Text('Logout'),
                    onTap: () {
                      // Trigger logout
                    },
                  ),
                ],
              );
            } else if (state is CurrentUserLoading) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return const Center(child: Text('Error loading user data.'));
            }
          },
        ),
      ),
      body: BlocBuilder<CurrentUserBloc, CurrentUserState>(
        builder: (context, state) {
          if (state is CurrentUserLoaded) {
            final user = state.user;

            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Center(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 140,
                            height: 140,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 15,
                                  spreadRadius: 5,
                                ),
                              ],
                            ),
                            child: ClipOval(
                              child: user.imageUrl!.isNotEmpty
                                  ? Image.network(
                                      user.imageUrl!,
                                      fit: BoxFit.cover,
                                      width: 140,
                                      height: 140,
                                    )
                                  : Image.asset(
                                      'assets/images/default_avatar.png',
                                      fit: BoxFit.cover,
                                      width: 140,
                                      height: 140,
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    Text(
                      user.fullName!,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      user.email ?? 'user@example.com',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Edit / Save Button
                    ElevatedButton(
                      onPressed: () {
                        profileNavigatorKey.currentState
                            ?.pushNamed('/edit_profile', arguments: {
                          'my_user': user,
                        });
                      },
                      child: const Text('Edit Profile'),
                    ),

                    const SizedBox(height: 20),
                    // Additional user details or actions
                    Expanded(
                      child: ListView(
                        children: [
                          _buildProfileOption(
                            context,
                            title: 'User Type',
                            value: user.userType!,
                            icon: Icons.person_outline,
                          ),
                          _buildProfileOption(
                            context,
                            title: 'Phone Number',
                            value: user.phoneNumber!.isNotEmpty
                                ? user.phoneNumber!
                                : 'N/A',
                            icon: Icons.phone,
                          ),
                          const SizedBox(height: 20),
                          _buildProfileOption(
                            context,
                            title: 'Address ',
                            value: user.address!.isNotEmpty
                                ? user.address!
                                : 'N/A',
                            icon: Icons.location_on,
                          ),
                          const SizedBox(height: 20),
                          _buildProfileOption(
                            context,
                            title: 'Account Created',
                            value: user.createAt!.toLocal().toString(),
                            icon: Icons.calendar_today,
                          ),
                          const SizedBox(height: 20),
                          // You can add more details here
                        ],
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

  // Helper function to build profile options
  Widget _buildProfileOption(BuildContext context,
      {required String title, required String value, required IconData icon}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.deepPurple),
          const SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
