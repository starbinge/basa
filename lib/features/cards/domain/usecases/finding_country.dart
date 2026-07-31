import 'package:country_picker/country_picker.dart';

String? getCountryFlagEmoji(String countryName) {
  try {
    final country = CountryService().findByName(countryName);
    return country?.flagEmoji;
  } catch (_) {
    return null;
  }
}
