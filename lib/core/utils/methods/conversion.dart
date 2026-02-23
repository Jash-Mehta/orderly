import 'dart:convert';

///Parse to int or returns [defaultValue]
///
int toInt(
  dynamic value, {
  int defaultValue = 0,
}) {
  int number = toDouble(
    '$value',
    defaultValue: defaultValue.toDouble(),
  ).toInt();

  return number;
}

///Parse to double or returns [defaultValue]
///
double toDouble(
  dynamic value, {
  double defaultValue = 0,
}) {
  double number = defaultValue;
  try {
    number = double.parse('$value');
  } catch (e) {
    print("Error while converting to double" + e.toString());
  }

  return number;
}

String tryJsonEncode(Object? object) {
  String requestBody = object.toString();
  try {
    requestBody = jsonEncode(object);
  } catch (e) {
    print("Error while converting to json" + e.toString());
  }

  return requestBody;
}
