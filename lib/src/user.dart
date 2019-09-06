import 'package:quiver/strings.dart';

class User {
  final String identifier;
  final Map<String, String> attributes = {};

  User(this.identifier, String email, String country,
      Map<String, String> custom) {
    if (this.identifier == null || identifier.isEmpty) {
      throw new Exception('identifier is null or empty');
    }
    attributes['identifier'] = identifier;
    if (isNotEmpty(country)) {
      attributes['country'] = country;
    }
    if (isNotEmpty(email)) {
      attributes['email'] = email;
    }
    if (custom != null) {
      attributes.addAll(custom);
    }
  }
  String getAttribute(String key) {
    return attributes[key];
  }
}
