import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:m3e_core/m3e_core.dart';

class StatsHeaderContainer extends StatelessWidget {
  const StatsHeaderContainer({
    super.key,
    required this.child,
    this.constraints = const BoxConstraints(maxHeight: 260),
    this.padding = 20,
  });

  final Widget child;
  final BoxConstraints constraints;
  final double padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: constraints,
      width: double.infinity,
      padding: EdgeInsets.all(padding.w),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColorDark,
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Stack(
        fit: StackFit.loose,
        clipBehavior: Clip.antiAlias,
        alignment: AlignmentGeometry.centerRight,
        children: [
          Positioned(
            child:
                M3EContainer.c9SidedCookie(
                      child: Text(""),
                      width: 200,
                      height: 200,
                      gradient: LinearGradient(
                        begin: AlignmentGeometry.topCenter,
                        end: AlignmentGeometry.bottomCenter,
                        colors: [
                          Theme.of(context).primaryColorLight,
                          Theme.of(context).primaryColor,
                        ],
                      ),
                    )
                    .animate(onPlay: (controller) => controller.repeat())
                    .rotate(
                      duration: Duration(seconds: 5),
                      curve: Curves.linear,
                    ),
          ),
          Positioned(
            top: 100,
            right: 100,
            child:
                M3EContainer.c9SidedCookie(
                      child: Text(""),
                      width: 100,
                      height: 100,
                      gradient: LinearGradient(
                        begin: AlignmentGeometry.topCenter,
                        end: AlignmentGeometry.bottomCenter,
                        colors: [
                          Theme.of(context).primaryColorLight,
                          Theme.of(context).primaryColor,
                        ],
                      ),
                    )
                    .animate(onPlay: (controller) => controller.loop())
                    .rotate(
                      begin: 1,
                      end: 0,
                      delay: Duration(microseconds: 300),
                      duration: Duration(seconds: 5),
                      curve: Curves.linear,
                    ),
          ),
          child,
        ],
      ),
    );
  }
}
