String? requiredEmailValidator(value) {
  if (!RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
      .hasMatch(value)) {
    return 'Enter a valid email!';
  }
  return null;
}

String? nameValidator(value) {
  value ??= '';
  if (value.isEmpty) {
    return 'This field can not be empty';
  }
  return null;
}
