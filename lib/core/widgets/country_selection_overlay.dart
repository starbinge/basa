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
    final theme = Theme.of(context);
    return Material(
      color: theme.colorScheme.surface,
      child: SizedBox(
        height: MediaQuery.sizeOf(context).height / 2,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          child: Column(
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: theme.colorScheme.onSurfaceVariant.withAlpha(80),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: 'Search country...',
                  prefixIcon: Icon(Icons.search),
                ),
              ),
              const SizedBox(height: 8),
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
      ),
    );
  }
}
