import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class StatusOverlay extends StatelessWidget {
  const StatusOverlay({
    super.key,
    this.animation,
    this.hintText,
    required this.isFinished,
    this.isFinishedButtonPressed,
  });

  final String? animation;
  final String? hintText;
  final bool isFinished;
  final VoidCallback? isFinishedButtonPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (animation == null || animation!.isEmpty)
                const CircularProgressIndicator()
              else
                Padding(
                  padding: const EdgeInsets.all(40.0),
                  child: LottieBuilder(
                    lottie: AssetLottie(animation!),
                    fit: BoxFit.contain,
                    animate: true,
                    repeat: true,
                  ),
                ),
              if (hintText == null || hintText!.isEmpty)
                Text("Loading...", style: theme.textTheme.headlineMedium)
              else
                Text(hintText!, style: theme.textTheme.headlineMedium),
            ],
          ),
        ),
        if (isFinished)
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isFinishedButtonPressed,
                child: const Text("Done"),
              ),
            ),
          ),
      ],
    );
  }
}
