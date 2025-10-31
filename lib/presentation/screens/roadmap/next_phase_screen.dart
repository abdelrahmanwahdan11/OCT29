import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../core/localization/app_localizations.dart';
import '../../../core/theme/app_theme.dart';

class NextPhaseScreen extends StatelessWidget {
  const NextPhaseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = AppColors.of(context);
    final textTheme = Theme.of(context).textTheme;
    final milestones = <_PhaseMilestone>[
      _PhaseMilestone(
        titleKey: 'phase_backend_title',
        descriptionKey: 'phase_backend_description',
        icon: Icons.cloud_sync_outlined,
      ),
      _PhaseMilestone(
        titleKey: 'phase_notifications_title',
        descriptionKey: 'phase_notifications_description',
        icon: Icons.notifications_active_outlined,
      ),
      _PhaseMilestone(
        titleKey: 'phase_ai_title',
        descriptionKey: 'phase_ai_description',
        icon: Icons.auto_mode_outlined,
      ),
      _PhaseMilestone(
        titleKey: 'phase_finance_title',
        descriptionKey: 'phase_finance_description',
        icon: Icons.payments_outlined,
      ),
      _PhaseMilestone(
        titleKey: 'phase_social_title',
        descriptionKey: 'phase_social_description',
        icon: Icons.groups_2_outlined,
      ),
      _PhaseMilestone(
        titleKey: 'phase_subscription_title',
        descriptionKey: 'phase_subscription_description',
        icon: Icons.workspace_premium_outlined,
      ),
      _PhaseMilestone(
        titleKey: 'phase_ar_title',
        descriptionKey: 'phase_ar_description',
        icon: Icons.view_in_ar,
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: Text(l10n.t('next_phase_title'))),
      body: ListView.builder(
        padding: const EdgeInsets.all(24),
        itemCount: milestones.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Container(
              margin: const EdgeInsets.only(bottom: 24),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: colors.card,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: colors.accent.withOpacity(0.12),
                    blurRadius: 32,
                    offset: const Offset(0, 24),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.t('next_phase_heading'),
                    style: textTheme.headlineSmall?.copyWith(color: colors.onSurface, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    l10n.t('next_phase_intro'),
                    style: textTheme.bodyMedium?.copyWith(color: colors.subtext),
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 280.ms).slide(begin: const Offset(0, 0.04));
          }

          final milestone = milestones[index - 1];
          return Container(
            margin: const EdgeInsets.only(bottom: 20),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: colors.cardAlt,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: colors.accent.withOpacity(0.08),
                  blurRadius: 20,
                  offset: const Offset(0, 16),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 48,
                  width: 48,
                  decoration: BoxDecoration(
                    color: colors.accent.withOpacity(0.16),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(milestone.icon, color: colors.accent),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.t(milestone.titleKey),
                        style: textTheme.titleMedium?.copyWith(color: colors.onSurface, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l10n.t(milestone.descriptionKey),
                        style: textTheme.bodyMedium?.copyWith(color: colors.subtext),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(duration: 280.ms, delay: (index * 60).ms).slide(begin: const Offset(0, 0.05));
        },
      ),
    );
  }
}

class _PhaseMilestone {
  const _PhaseMilestone({required this.titleKey, required this.descriptionKey, required this.icon});

  final String titleKey;
  final String descriptionKey;
  final IconData icon;
}
