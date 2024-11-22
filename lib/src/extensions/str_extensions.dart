extension StrFormat on String {
  get isEmptyField {
    RegExp regExp = RegExp(r'$');
    return regExp.hasMatch(this);
  }

  bool get isNotEmptyField {
    RegExp regExp = RegExp(r'^.+$');
    return regExp.hasMatch(this);
  }

  String get firstCapital {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1);
  }

  String get capitalizeEachWord {
    return split(' ')
        .map((word) => word.isNotEmpty
            ? word[0].toUpperCase() + word.substring(1).toLowerCase()
            : word)
        .join(' ');
  }

  bool get hasMoreThanEightLetter {
    RegExp regExp = RegExp(r'^[A-Za-z\s]{9,}$');
    return regExp.hasMatch(this);
  }

  bool get isValidEmail {
    RegExp emailRegExp =
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return emailRegExp.hasMatch(this);
  }

  bool get isValidNIC {
    RegExp regExp = RegExp(r'^(\d{9}V|\d{12})$');
    return regExp.hasMatch(this);
  }

  bool get isValidPhoneNumber {
    RegExp regExp = RegExp(r'^0\d{9}$');
    return regExp.hasMatch(this);
  }

  bool get isValidCustomString {
    RegExp regExp = RegExp(r'^[a-zA-Z0-9]{1,15}$');
    return regExp.hasMatch(this);
  }

  bool get isValidPassword {
    RegExp regExp = RegExp(
      r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d).{8,}$',
    );

    return regExp.hasMatch(this);
  }
}
