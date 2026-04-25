class validation {
  validation._(); //todo: abstract object (singlitone pattern)

  static String? validEmail(String? email) {
    RegExp emailRegex = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
    );
    if (email == null || email.trim().isEmpty) {
      return 'This Field is Required';
    } else if (emailRegex.hasMatch(email) == false) {
      return 'Enter valid Email';
    } else {
      return null;
    }
  }

  static String? validPassword(String? pass) {
    /// todo: Minimum eight characters, at least one letter and one number:
    RegExp passRegex = RegExp(r"^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}");
    if (pass == null || pass.trim().isEmpty) {
      return 'This Field is Required';
    } else if (passRegex.hasMatch(pass) == false) {
      return 'Strong Password Please';
    } else {
      return null;
    }
  }

  static String? confiremPassword(String? password, String? valu) {
    /// todo: Minimum eight characters, at least one letter and one number:
    if (valu == null || valu.trim().isEmpty) {
      return 'This Field is Required';
    } else if (valu != password) {
      return 'Password is not Matching';
    } else {
      return null;
    }
  }
  static String? validUserName(String? name) {
    ///todo:egypt validation
    RegExp nameRegex = RegExp(r'[a-zA-z0-9 ,.-]+$');
    if (name == null || name.trim().isEmpty) {
      return 'This Field is Required';
    } else if (nameRegex.hasMatch(name) == false) {
      return 'Enter Valid User Name';
    } else {
      return null;
    }
  }
  static String? validPhoneNumber(String? phone) {
    ///todo:egypt validation
    RegExp phoneRegex = RegExp(r"01[0-2,5]{1}[0-9]{8}");
    if (phone == null || phone.trim().isEmpty) {
      return 'This Field is Required';
    } else if (phoneRegex.hasMatch(phone) == false) {
      return 'Please Enter a Egyption Phone Number';
    } else {
      return null;
    }
  }
}
