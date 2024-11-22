import 'package:annex_finder/src/components/button/app_main_button.dart';
import 'package:annex_finder/src/components/button/social_media_button_widget.dart';
import 'package:annex_finder/src/components/widget/background_header_widget.dart';
import 'package:annex_finder/src/components/widget/from_card_widget.dart';
import 'package:annex_finder/src/components/widget/section_widget.dart';
import 'package:annex_finder/src/components/widget/text_field_widget.dart';
import 'package:annex_finder/src/res/color/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/sign_in/sign_in_bloc.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Controllers for email and password fields
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    // Key to manage form validation
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    return Scaffold(
      body: BlocListener<SignInBloc, SignInState>(
        listener: (context, state) {
          if (state is MyUserSignInFailureState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.message,
                  style: const TextStyle(color: Colors.white),
                ),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is MyUserSignInSuccessState ||
              state is MyUserGoogleSignInSuccessState ||
              state is MyUserFacebookSignInSuccessState) {
            // Navigate to the home page on successful login
            Navigator.of(context).pushNamed('/landing');
          }
        },
        child: BlocBuilder<SignInBloc, SignInState>(
          builder: (context, state) {
            if (state is MyUserSignInProcessState) {
              return const Center(child: CircularProgressIndicator());
            }

            return SingleChildScrollView(
              child: Column(
                children: [
                  // Background Header
                  const BackgroundHeaderWidget(
                    headerText: 'Annex Finder',
                    subText: 'Ultimate property finder',
                  ),

                  // Login Form Card
                  FromCardWidget(
                    widget: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Sign In to Continue',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),

                            // Email Field with validation
                            TextFieldWidget(
                              controller: emailController,
                              labelText: 'Email Address',
                              hintText: 'Enter your email',
                              iconData: Icons.check_circle,
                              color: ColorUtil.greenColor[10],
                              obscureText: false,
                            ),

                            const SizedBox(height: 16),

                            // Password Field with validation
                            TextFieldWidget(
                              controller: passwordController,
                              labelText: 'Password',
                              hintText: 'Enter your password',
                              iconData: Icons.visibility_off,
                              obscureText: true,
                            ),

                            const SizedBox(height: 8),

                            // Login Button
                            AppMainButton(
                              testName: 'Log In',
                              onTap: () {
                                if (emailController.text.trim().isNotEmpty &&
                                    passwordController.text.trim().isNotEmpty) {
                                  context
                                      .read<SignInBloc>()
                                      .add(MyUserSignInEvent(
                                        email: emailController.text,
                                        password: passwordController.text,
                                      ));
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Please make sure all fields are filled correctly.',
                                        style: TextStyle(
                                            color: Colors
                                                .white), // Set text color to white for readability
                                      ),
                                      backgroundColor: Colors
                                          .red, // Set the background color to red
                                    ),
                                  );
                                }
                              },
                              height: 45,
                            ),

                            const SizedBox(height: 10),

                            Center(
                              child: TextButton(
                                onPressed: () {
                                  // Implement reset password functionality
                                },
                                child: const Text(
                                  'Reset Password',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ),
                            ),

                            // Navigation to Sign-up
                            Center(
                              child: TextButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, '/register');
                                },
                                child: const Text(
                                  'New member? Sign up',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Sign in with section
                  const SectionWidget(sectionText: 'Sign in with'),
                  const SizedBox(height: 16),

                  // Social Media Buttons for Facebook and Google
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SocialMediaButtonWidget(
                        onTap: () {
                          context
                              .read<SignInBloc>()
                              .add(MyUserFacebookSignInEvent());
                        },
                        backgroundColor: ColorUtil.whiteColor[10]!,
                        assetPath: "assets/logo/fb.png",
                      ),
                      const SizedBox(width: 16),
                      SocialMediaButtonWidget(
                        onTap: () {
                          context
                              .read<SignInBloc>()
                              .add(MyUserGoogleSignInEvent());
                        },
                        backgroundColor: ColorUtil.whiteColor[10]!,
                        assetPath: "assets/logo/google.png",
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
