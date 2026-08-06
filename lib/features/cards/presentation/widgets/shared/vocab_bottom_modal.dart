import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../domain/entities/cards_detail_entity.dart';

class VocabBottomModal extends StatelessWidget {
  const VocabBottomModal({
    super.key,
    required this.listCard,
    required this.cardIndex,
  });

  final List<CardsDetailEntity> listCard;
  final int cardIndex;

  @override
  Widget build(BuildContext context) {
    final int index = cardIndex;
    final String additionalContext = listCard[index].additionalContext;

    return SafeArea(
      child: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 24.h),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.all(20.w),
                    child: Text(
                      listCard[index].defaultLanguage,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: TextTheme.of(context).headlineLarge?.fontSize,
                        color: Theme.of(context).primaryColor,
                        fontWeight: TextTheme.of(
                          context,
                        ).headlineLarge?.fontWeight,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(20.w),
                    child: Text(
                      listCard[index].translatedLanguage,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.h),
              if (additionalContext.isNotEmpty)
                Card(
                  shadowColor: Theme.of(
                    context,
                  ).shadowColor.withValues(alpha: 0.1),
                  elevation: 2,
                  clipBehavior: Clip.antiAlias,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12.r)),
                  ),
                  margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 12.h,
                        ),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Theme.of(
                            context,
                          ).primaryColorLight.withValues(alpha: 0.2),
                          border: Border(
                            bottom: BorderSide(
                              color: Theme.of(
                                context,
                              ).dividerColor.withValues(alpha: 0.1),
                              width: 1.w,
                            ),
                          ),
                        ),
                        child: Text(
                          "Additional Context",
                          style: TextStyle(
                            fontSize: TextTheme.of(
                              context,
                            ).titleMedium?.fontSize,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(16.w),
                        child: Text(
                          additionalContext,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: Theme.of(
                                  context,
                                ).textTheme.bodyMedium?.color?.withValues(
                                  alpha: 0.85,
                                ),
                                height: 1.3,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
