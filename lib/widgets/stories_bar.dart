import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';

class StoriesBar extends StatelessWidget {
  const StoriesBar({
    super.key,
    required this.stories,
  });

  final List<String> stories;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            l10n.string('stories'),
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        SizedBox(
          height: 100,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: stories.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final url = stories[index];
              return Column(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Theme.of(context).colorScheme.primary,
                        width: 2,
                      ),
                    ),
                    padding: const EdgeInsets.all(3),
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(url),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text('Story ${index + 1}'),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
