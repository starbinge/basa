import 'package:basa_app_project/core/theme/app_colors.dart';
import 'package:basa_app_project/features/cards/domain/entities/cards_detail_entity.dart';
import 'package:flutter/material.dart';

class FlashCardWidget extends StatefulWidget {
  const FlashCardWidget({super.key, required this.card});

  final CardsDetailEntity card;

  @override
  State<FlashCardWidget> createState() => _FlashCardWidgetState();
}

class _FlashCardWidgetState extends State<FlashCardWidget> {
  bool _showBack = false;

  @override
  Widget build(BuildContext context) {
    final card = widget.card;
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => setState(() => _showBack = !_showBack),
        child: AnimatedCrossFade(
          duration: const Duration(milliseconds: 250),
          crossFadeState:
              _showBack ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          firstChild: _buildFront(card, theme),
          secondChild: _buildBack(card, theme),
        ),
      ),
    );
  }

  Widget _buildFront(CardsDetailEntity card, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            card.defaultLanguage,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
            textAlign: TextAlign.center,
          ),
          if (card.pronunciation.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              card.pronunciation,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: AppColors.onSurfaceVariant,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildStatBadge(
                Icons.tune,
                '${card.activeRepetition}x',
                AppColors.tertiary,
              ),
              const SizedBox(width: 8),
              _buildStatBadge(
                Icons.check_circle_outline,
                '${card.accuracyPercentage}%',
                AppColors.primary,
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Tap to reveal',
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBack(CardsDetailEntity card, ThemeData theme) {
    final hasAudio =
        card.audioPath.maleVoice.isNotEmpty ||
        card.audioPath.femaleVoice.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              card.defaultLanguage,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          if (card.pronunciation.isNotEmpty) ...[
            const SizedBox(height: 2),
            Center(
              child: Text(
                card.pronunciation,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.onSurfaceVariant,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
          const Divider(height: 24),
          Text(
            card.translatedLanguage,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          if (card.explanation.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              card.explanation,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ],
          if (hasAudio) ...[
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (card.audioPath.maleVoice.isNotEmpty)
                  IconButton(
                    icon: const Icon(Icons.record_voice_over),
                    tooltip: 'Male voice',
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Audio playback coming soon'),
                        ),
                      );
                    },
                  ),
                if (card.audioPath.femaleVoice.isNotEmpty)
                  IconButton(
                    icon: const Icon(Icons.voice_over_off),
                    tooltip: 'Female voice',
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Audio playback coming soon'),
                        ),
                      );
                    },
                  ),
              ],
            ),
          ],
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildStatBadge(
                Icons.tune,
                '${card.activeRepetition}x',
                AppColors.tertiary,
              ),
              const SizedBox(width: 8),
              _buildStatBadge(
                Icons.check_circle_outline,
                '${card.accuracyPercentage}%',
                AppColors.primary,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatBadge(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: color),
          ),
        ],
      ),
    );
  }
}
