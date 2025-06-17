String? emptyValidation(String? value, String errMessage) {
  if (value == null || value.isEmpty) {
    return errMessage;
  }
  return null;
}

String? phoneValidation(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter your mobile number';
  } else if (!RegExp(r'[0-9]').hasMatch(value)) {
    return 'Enter valid mobile number';
  } else if (value.length != 10) {
    return 'mobile number must be of 10 digit';
  }
  return null;
}
