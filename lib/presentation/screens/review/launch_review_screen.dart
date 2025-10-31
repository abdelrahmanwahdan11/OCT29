import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../application/controllers/review_controller.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/theme/app_theme.dart';

class LaunchReviewScreen extends StatelessWidget {
  const LaunchReviewScreen({super.key, required this.reviewController});

  final ReviewController reviewController;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.t('launch_review_title'))),
      body: AnimatedBuilder(
        animation: reviewController,
        builder: (context, _) {
          final items = reviewController.observations;
          final bool isLoading = reviewController.isAnalyzing;
          if (isLoading && items.isEmpty) {
            return Center(child: CircularProgressIndicator(color: colors.accent));
          }
          return RefreshIndicator(
            onRefresh: reviewController.runAnalysis,
            color: colors.accent,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(24),
              children: [
                _ReviewIntroCard(
                  isLoading: isLoading,
                  colors: colors,
                  l10n: l10n,
                  controller: reviewController,
                ).animate().fadeIn(duration: 280.ms).slide(begin: const Offset(0, 0.04)),
                const SizedBox(height: 24),
                _SectionHeader(title: l10n.t('review_section_observations')),
                const SizedBox(height: 12),
                ...items
                    .map((item) => _ObservationCard(item: item))
                    .animate(interval: 60.ms)
                    .fadeIn(duration: 260.ms)
                    .slide(begin: const Offset(0, 0.04)),
                const SizedBox(height: 32),
                _SectionHeader(title: l10n.t('review_section_actions')),
                const SizedBox(height: 12),
                ...items
                    .map(
                      (item) => _ActionCard(
                        item: item,
                        isLoading: isLoading,
                        reviewController: reviewController,
                      ),
                    )
                    .animate(interval: 60.ms)
                    .fadeIn(duration: 260.ms)
                    .slide(begin: const Offset(0, 0.04)),
                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ReviewIntroCard extends StatelessWidget {
  const _ReviewIntroCard({
    required this.isLoading,
    required this.colors,
    required this.l10n,
    required this.controller,
  });

  final bool isLoading;
  final AppColors colors;
  final AppLocalizations l10n;
  final ReviewController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
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
            l10n.t('launch_review'),
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: colors.onSurface,
                ),
          ),
          const SizedBox(height: 12),
          Text(
            l10n.t('launch_review_body'),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: colors.subtext),
          ),
          const SizedBox(height: 20),
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: ElevatedButton.icon(
              onPressed: isLoading ? null : controller.runAnalysis,
              icon: const Icon(Icons.refresh),
              label: Text(l10n.t('review_refresh')),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(0, 48),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: colors.onSurface,
            fontWeight: FontWeight.w600,
          ),
    );
  }
}

class _ObservationCard extends StatelessWidget {
  const _ObservationCard({required this.item});

  final ReviewItem item;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final l10n = AppLocalizations.of(context);
    final statusColor = _statusColor(item.status, colors);
    final statusIcon = _statusIcon(item.status);
    final statusLabel = _statusLabel(item.status, l10n);
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colors.cardAlt,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: colors.divider.withOpacity(0.6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(statusIcon, color: statusColor),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.t(item.titleKey),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: colors.onSurface,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      statusLabel,
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(color: statusColor),
                    ),
                  ],
                ),
              ),
              if (item.manualOverride)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: colors.accent.withOpacity(0.14),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    l10n.t('review_manual_override'),
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: colors.accent,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            l10n.t(item.descriptionKey),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: colors.subtext),
          ),
          if (item.metricKey != null) ...[
            const SizedBox(height: 12),
            Text(
              l10n.tr(item.metricKey!, item.metricValues),
              style: Theme.of(context).textTheme.labelLarge?.copyWith(color: colors.onSurface),
            ),
          ],
        ],
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  const _ActionCard({
    required this.item,
    required this.isLoading,
    required this.reviewController,
  });

  final ReviewItem item;
  final bool isLoading;
  final ReviewController reviewController;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final l10n = AppLocalizations.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: colors.accent.withOpacity(0.08),
            blurRadius: 22,
            offset: const Offset(0, 18),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.t(item.titleKey),
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: colors.onSurface,
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.t(item.descriptionKey),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: colors.subtext),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            children: [
              if (item.actionKey != null && item.autoResolvable)
                ElevatedButton(
                  onPressed: isLoading ? null : () => reviewController.applyFix(item.id),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(0, 48),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                  child: Text(l10n.t(item.actionKey!)),
                ),
              TextButton(
                onPressed: isLoading ? null : () => reviewController.markApproved(item.id),
                child: Text(l10n.t('review_manual_approve')),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

Color _statusColor(ReviewStatus status, AppColors colors) {
  switch (status) {
    case ReviewStatus.pass:
      return colors.success;
    case ReviewStatus.warning:
      return colors.warning;
    case ReviewStatus.fail:
    default:
      return colors.error;
  }
}

IconData _statusIcon(ReviewStatus status) {
  switch (status) {
    case ReviewStatus.pass:
      return Icons.check_circle_outline;
    case ReviewStatus.warning:
      return Icons.error_outline;
    case ReviewStatus.fail:
    default:
      return Icons.highlight_off;
  }
}

String _statusLabel(ReviewStatus status, AppLocalizations l10n) {
  switch (status) {
    case ReviewStatus.pass:
      return l10n.t('review_status_pass');
    case ReviewStatus.warning:
      return l10n.t('review_status_warning');
    case ReviewStatus.fail:
    default:
      return l10n.t('review_status_fail');
  }
}
