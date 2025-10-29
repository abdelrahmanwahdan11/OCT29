import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../shared/controllers/content_controller.dart';
import '../../shared/ui_kit/glass_card.dart';
import '../../shared/ui_kit/glass_page_scaffold.dart';
import '../../shared/utils/app_localizations.dart';

class StaticContentListScreen extends StatelessWidget {
  const StaticContentListScreen({super.key, required this.controller});

  final ContentController controller;

  @override
  Widget build(BuildContext context) {
    final strings = MazadLocalizations.of(context);
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final pages = controller.pages;
        return GlassPageScaffold(
          title: strings.t('static_pages'),
          imageUrl: 'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?q=80&w=1600',
          body: pages.isEmpty && controller.isLoading
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
                  itemCount: pages.length,
                  itemBuilder: (context, index) {
                    final page = pages[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: GlassCard(
                        onTap: () => Navigator.of(context).pushNamed(
                          '/content_detail',
                          arguments: page.key,
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          leading: CircleAvatar(
                            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                            child: Text('${index + 1}', style: Theme.of(context).textTheme.labelLarge),
                          ),
                          title: Text(page.titleFor(strings.locale)),
                          subtitle: Text(strings.t('tap_to_read')),
                          trailing: const Icon(Icons.chevron_right),
                        ),
                      ).animate().fadeIn(duration: 300.ms).slide(begin: const Offset(0, 0.1)),
                    );
                  },
                ),
        );
      },
    );
  }
}

class StaticContentDetailScreen extends StatelessWidget {
  const StaticContentDetailScreen({super.key, required this.controller, required this.pageKey});

  final ContentController controller;
  final String pageKey;

  @override
  Widget build(BuildContext context) {
    final strings = MazadLocalizations.of(context);
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final page = controller.pageByKey(pageKey);
        final title = page?.titleFor(strings.locale) ?? strings.t('static_pages');
        return GlassPageScaffold(
          title: title,
          imageUrl: 'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?q=80&w=1600',
          body: page == null
              ? Center(child: Text(strings.t('content_missing')))
              : ListView(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
                  children: [
                    Text(
                      page.titleFor(strings.locale),
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 12),
                    for (final paragraph in page.paragraphsFor(strings.locale)) ...[
                      Text(
                        paragraph,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 12),
                    ],
                  ],
                ).animate().fadeIn(duration: 350.ms),
        );
      },
    );
  }
}
