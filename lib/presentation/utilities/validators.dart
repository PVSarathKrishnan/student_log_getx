class Validators{

// Validator for Gender
static String? validateGender(String? value) {
  if (value == null || value.isEmpty) {
    return 'Gender is required';
  }
  return null;
}

// Validator for Photo
String? validatePhoto(String? value) {
  if (value == null || value.isEmpty) {
    return 'Photo is required';
  }
  return null;
}

// Validator for Date of Birth
String? validateDOB(DateTime? value) {
  if (value == null) {
    return 'Date of Birth is required';
  }
  return null;
}

// ...

//to validate full name
static String? validateFullName(String? value) {
  
  final trimmedValue = value?.trim();

  if (trimmedValue == null || trimmedValue.isEmpty) {
    return 'Full Name is required';
  }

  final RegExp nameRegExp = RegExp(r'^[a-zA-Z ]+$');

  if (!nameRegExp.hasMatch(trimmedValue)) {
    return 'Full Name can only contain letters and spaces';
  }

  return null; 
}

//to validate email
static String? validateEmail(String? value) {
  
  final trimmedValue = value?.trim();

  if (trimmedValue == null || trimmedValue.isEmpty) {
    return 'Email is required';
  }

  final RegExp emailRegExp = RegExp(
    r'^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$',
  );

  if (!emailRegExp.hasMatch(trimmedValue)) {
    return 'Invalid email address';
  }

  return null; 
}

//to validate mobile
static String? validateMobile(String? value) {
  
  final trimmedValue = value?.trim();

  if (trimmedValue == null || trimmedValue.isEmpty) {
    return 'Contact is required';
  }

  final RegExp mobRegExp = RegExp(
  r'^[0-9]{10}$',
);


  if (!mobRegExp.hasMatch(trimmedValue)) {
    return 'Invalid mobile number';
  }

  return null; 
}

}