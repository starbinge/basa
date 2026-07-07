import 'package:basa_app_project/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AnkiFilePickerButton extends StatefulWidget {
  const AnkiFilePickerButton({
    super.key,
    required this.ankiFilePath,
    required this.onTap,
  });

  final String ankiFilePath;
  final VoidCallback onTap;

  @override
  State<AnkiFilePickerButton> createState() => _AnkiFilePickerButtonState();
}

class _AnkiFilePickerButtonState extends State<AnkiFilePickerButton> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: widget.onTap,
                behavior: HitTestBehavior.opaque,
                child: Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    border: Border.symmetric(
                      horizontal: BorderSide(
                        color: theme.colorScheme.onSurface,
                        width: 1.w,
                      ),
                      vertical: BorderSide(
                        color: theme.colorScheme.onSurface,
                        width: 1.w,
                      ),
                    ),
                    borderRadius: BorderRadius.circular(5.r),
                  ),
                  child: Text(
                    widget.ankiFilePath.isNotEmpty
                        ? widget.ankiFilePath
                        : "Select Anki Deck",
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontSize: 13.sp,
                      color: widget.ankiFilePath.isNotEmpty
                          ? null
                          : AppColors.onSurfaceVariant.withAlpha(100),
                    ),
                  ),
                ),
              ),
            ),
            IconButton(
              onPressed: widget.onTap,
              icon: const Icon(Icons.upload),
              style: IconButton.styleFrom(
                backgroundColor: AppColors.structural,
                foregroundColor: AppColors.onPrimary,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
