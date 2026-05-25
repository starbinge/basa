import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';

class CountrySelectionOverlay extends StatefulWidget {
  const CountrySelectionOverlay({
    super.key,
    required this.onSelect,
    required this.countries,
  });

  final ValueChanged<Country> onSelect;
  final List<Country> countries;

  @override
  State<CountrySelectionOverlay> createState() => _CountrySelectionOverlayState();
}

class _CountrySelectionOverlayState extends State<CountrySelectionOverlay> {
  late List<Country> _filteredCountries;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filteredCountries = widget.countries;
    _searchController.addListener(_filterCountries);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterCountries);
    _searchController.dispose();
    super.dispose();
  }

  void _filterCountries() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredCountries = widget.countries.where((country) {
        return country.name.toLowerCase().contains(query) ||
               country.countryCode.toLowerCase().contains(query) ||
               country.phoneCode.contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Search for countries',
                prefixIcon: Icon(Icons.search),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _filteredCountries.length,
                itemBuilder: (context, index) {
                  final country = _filteredCountries[index];
                  return ListTile(
                    leading: Text(country.flagEmoji),
                    title: Text('${country.name} (+${country.phoneCode})'),
                    onTap: () {
                      widget.onSelect(country);
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
