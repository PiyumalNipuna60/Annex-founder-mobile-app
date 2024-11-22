import 'package:annex_finder/src/components/widget/from_card_widget.dart';
import 'package:annex_finder/src/extensions/register_form.dart';
import 'package:annex_finder/src/res/color/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../components/button/app_main_button.dart';
import '../../../components/button/social_media_button_widget.dart';
import '../../../components/widget/background_header_widget.dart';
import '../../../components/widget/text_field_widget.dart';
import '../bloc/sign_up/sign_up_bloc.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController fullNameController = TextEditingController();
    TextEditingController emailController = TextEditingController();
    TextEditingController phoneNumberController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    TextEditingController conformPasswordController = TextEditingController();
    return Scaffold(
      body: BlocListener<SignUpBloc, SignUpState>(
        listener: (context, state) {
          if (state is MyUserSignUpFailureState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.message,
                ),
              ),
            );
          } else if (state is MyUserSignUpSuccessState ||
              state is MyUserGoogleSignUpSuccessState ||
              state is MyUserFacebookSignUpSuccessState) {
            Navigator.of(context).pushNamed('/landing');
          }
        },
        child: BlocBuilder<SignUpBloc, SignUpState>(
          builder: (context, state) {
            if (state is MyUserSignUpProcessState) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return SingleChildScrollView(
              child: Column(
                children: [
                  // Background Header
                  const BackgroundHeaderWidget(
                      headerText: 'Annex Finder',
                      subText: 'Ultimate property finder'),

                  // Registration Form Card (Positioned below the header)
                  FromCardWidget(
                    widget: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Create Account',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),

                          // Full Name Field
                          TextFieldWidget(
                            controller: fullNameController,
                            labelText: 'Full Name',
                            hintText: 'Enter your full name',
                            iconData: Icons.person,
                            obscureText: false,
                          ),

                          const SizedBox(height: 16),

                          // Email Field
                          TextFieldWidget(
                            controller: emailController,
                            labelText: 'Email Address',
                            hintText: 'Enter your email',
                            iconData: Icons.email,
                            obscureText: false,
                          ),

                          const SizedBox(height: 16),

                          // phone number Field
                          TextFieldWidget(
                            controller: phoneNumberController,
                            labelText: 'phone Number',
                            hintText: 'Enter your phone number',
                            iconData: Icons.phone,
                            keyboardType: TextInputType.number,
                            obscureText: false,
                          ),

                          const SizedBox(height: 16),

                          // Password Field
                          TextFieldWidget(
                            controller: passwordController,
                            labelText: 'Password',
                            hintText: 'Enter your password',
                            iconData: Icons.password,
                            obscureText: true,
                          ),

                          const SizedBox(height: 16),

                          // Confirm Password Field
                          TextFieldWidget(
                            controller: conformPasswordController,
                            labelText: 'Confirm Password',
                            hintText: 'Re-enter your password',
                            iconData: Icons.password,
                            obscureText: true,
                          ),

                          const SizedBox(height: 16),

                          // Register Button
                          AppMainButton(
                              testName: 'Register',
                              onTap: () {
                                if (passwordController.text.trim() ==
                                    conformPasswordController.text.trim()) {
                                  if (RegisterFrom.emailCheck(
                                          emailController.text.trim(),
                                          context) &&
                                      RegisterFrom.passwordCheck(
                                          passwordController.text.trim(),
                                          context) &&
                                      RegisterFrom.notEmpty(
                                          fullNameController.text.trim(),
                                          "full Name",
                                          context)) {
                                    context
                                        .read<SignUpBloc>()
                                        .add(MyUserSignUpEvent(
                                          email: emailController.text.trim(),
                                          password:
                                              passwordController.text.trim(),
                                          fullName:
                                              fullNameController.text.trim(),
                                        ));
                                  }
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Passwords do not match.',
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
                              height: 45),
                          const SizedBox(height: 10),

                          // Already have an account
                          Center(
                            child: TextButton(
                              onPressed: () {
                                // Navigate to Login screen
                                Navigator.of(context).pop();
                              },
                              child: const Text(
                                'Already have an account? Log in here',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Sign in with section
                  const SizedBox(height: 20), // Spacing
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(child: Divider(thickness: 1)),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text('Sign up with'),
                        ),
                        Expanded(child: Divider(thickness: 1)),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16), // Spacing

                  // Social Media Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SocialMediaButtonWidget(
                          onTap: () {
                            context
                                .read<SignUpBloc>()
                                .add(const MyUserFacebookSignUpEvent());
                          },
                          backgroundColor: ColorUtil.whiteColor[10]!,
                          assetPath: "assets/logo/fb.png"),

                      const SizedBox(width: 16), // Spacing between buttons
                      SocialMediaButtonWidget(
                          onTap: () {
                            context
                                .read<SignUpBloc>()
                                .add(const MyUserGoogleSignUpEvent());
                          },
                          backgroundColor: ColorUtil.whiteColor[10]!,
                          assetPath: "assets/logo/google.png"),
                    ],
                  ),
                  const SizedBox(height: 20), // Bottom spacing
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
