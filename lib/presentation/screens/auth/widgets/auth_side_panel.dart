import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class AuthFeatureData {
  const AuthFeatureData({required this.icon, required this.label});

  final IconData icon;
  final String label;
}

class AuthSidePanel extends StatelessWidget {
  const AuthSidePanel({
    super.key,
    required this.title,
    required this.subtitle,
    required this.features,
    required this.ctaLabel,
    required this.onCta,
  });

  final String title;
  final String subtitle;
  final List<AuthFeatureData> features;
  final String ctaLabel;
  final VoidCallback onCta;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          gradient: LinearGradient(
            colors: [
              colors.accent.withOpacity(0.18),
              colors.card,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: colors.accent.withOpacity(0.25),
              blurRadius: 42,
              offset: const Offset(0, 26),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: textTheme.headlineSmall?.copyWith(color: colors.onSurface, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 12),
              Text(
                subtitle,
                style: textTheme.bodyMedium?.copyWith(color: colors.subtext),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: features
                        .map(
                          (feature) => AuthFeatureChip(
                            icon: feature.icon,
                            label: feature.label,
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
              Align(
                alignment: AlignmentDirectional.bottomEnd,
                child: ElevatedButton(
                  onPressed: onCta,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colors.accent,
                    foregroundColor: colors.background,
                    minimumSize: const Size(160, 48),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                  ),
                  child: Text(ctaLabel),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AuthFeatureChip extends StatelessWidget {
  const AuthFeatureChip({super.key, required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final textTheme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: colors.cardAlt,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colors.divider),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: colors.accent, size: 18),
          const SizedBox(width: 8),
          Text(
            label,
            style: textTheme.labelLarge?.copyWith(color: colors.onSurface, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
