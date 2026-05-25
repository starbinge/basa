import 'package:basa_app_project/core/constants/screen_size.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';

class CountrySelector extends StatelessWidget {
  const CountrySelector({
    super.key,
    required this.onSelect,
    required this.selectedCountry,
  });

  final ValueChanged<Country> onSelect;
  final String selectedCountry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Country? country;
    if (selectedCountry.isNotEmpty) {
      try {
        country = CountryService().findByName(selectedCountry);
      } catch (_) {}
    }

    final flagEmoji = country?.flagEmoji;
    final hasSelected = selectedCountry.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        InkWell(
          onTap: () {
            showCountryPicker(
              showPhoneCode: false,
              showSearch: true,
              context: context,
              onSelect: onSelect,
              countryListTheme: CountryListThemeData(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                ),
                bottomSheetHeight: context.screenHeight / 2,
                inputDecoration: InputDecoration(
                  hintText: "Search country...",
                  prefixIcon: const Icon(Icons.search),
                ),
              ),
            );
          },
          borderRadius: BorderRadius.circular(4),
          child: InputDecorator(
            decoration: const InputDecoration(
              suffixIcon: Icon(Icons.arrow_drop_down, size: 24),
            ),
            child: Row(
              children: [
                if (flagEmoji != null) ...[
                  Text(flagEmoji, style: const TextStyle(fontSize: 18)),
                  const SizedBox(width: 8),
                ],
                Expanded(
                  child: Text(
                    hasSelected ? selectedCountry : "Select Country",
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: hasSelected
                          ? theme.colorScheme.onSurface
                          : theme.colorScheme.onSurfaceVariant.withAlpha(100),
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
