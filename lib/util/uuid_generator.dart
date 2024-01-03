import 'dart:convert';

import 'package:crypto/crypto.dart';

String uuidFrom(Map<String, dynamic> data) {
  // Convert the map to a JSON string
  String jsonString = jsonEncode(data);

  // Create a hash of the JSON string
  var bytes = utf8.encode(jsonString);
  var hash = sha256.convert(bytes).toString();

  // Use the hash to create a UUID-like string
  return '${hash.substring(0, 8)}-${hash.substring(8, 12)}-${hash.substring(12, 16)}-${hash.substring(16, 20)}-${hash.substring(20)}';
}