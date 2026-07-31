import 'package:basa_app_project/core/constants/screen_size.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
        SizedBox(height: 8.h),
        InkWell(
          onTap: () {
            showCountryPicker(
              showPhoneCode: false,
              showSearch: true,
              context: context,
              onSelect: onSelect,
              countryListTheme: CountryListThemeData(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8.r),
                  topRight: Radius.circular(8.r),
                ),
                bottomSheetHeight: context.screenHeight / 2,
                inputDecoration: const InputDecoration(
                  hintText: "Search country...",
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            );
          },
          borderRadius: BorderRadius.circular(4.r),
          child: InputDecorator(
            decoration: InputDecoration(
              suffixIcon: Icon(Icons.arrow_drop_down, size: 24.sp),
            ),
            child: Row(
              children: [
                if (flagEmoji != null) ...[
                  Text(flagEmoji, style: TextStyle(fontSize: 18.sp)),
                  SizedBox(width: 8.w),
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
