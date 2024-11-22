import '../extensions/str_extensions.dart';
import 'package:flutter/material.dart';

class RegisterFrom {
  static bool notEmpty(
      String textField, String textFieldName, BuildContext context) {
    if (textField.isNotEmpty) {
      return true;
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Empty  $textFieldName"),
            backgroundColor: Colors.red,
          ),
        );
      });
      return false;
    }
  }

  static bool charactersCheck(
      String text, String textFieldName, BuildContext context) {
    if (text.hasMoreThanEightLetter) {
      return true;
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("The words included are not enough $textFieldName"),
            backgroundColor: Colors.red,
          ),
        );
      });
      return false;
    }
  }

  static bool emailCheck(String email, BuildContext context) {
    if (email.isValidEmail) {
      return true;
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("The email is incorrect"),
            backgroundColor: Colors.red,
          ),
        );
      });
      return false;
    }
  }

  static bool mobileNUmberCheck(String mobileNumber, BuildContext context) {
    if (mobileNumber.isValidPhoneNumber) {
      return true;
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("The mobile number is incorrect"),
            backgroundColor: Colors.red,
          ),
        );
      });
      return false;
    }
  }

  static bool nicNumberCheck(String nic, BuildContext context) {
    if (nic.isValidNIC || nic.isEmpty) {
      return true;
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("The NIC number is incorrect"),
            backgroundColor: Colors.red,
          ),
        );
      });
      return false;
    }
  }

  static bool passwordCheck(
    String password,
    BuildContext context,
  ) {
    if (password.isValidPassword) {
      return true;
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("The Password  is incorrect"),
            backgroundColor: Colors.red,
          ),
        );
      });
      return false;
    }
  }
}
