import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

import '../l10n/app_localizations.dart';
import '../services/fake_api_service.dart';

class PostCard extends StatelessWidget {
  const PostCard({
    super.key,
    required this.post,
  });

  final FakePost post;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 0,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(post.avatarUrl),
            ),
            title: Text(post.userName),
            subtitle: Text(l10n.string('just_now')),
          ),
          AspectRatio(
            aspectRatio: 4 / 5,
            child: Image.network(
              post.imageUrl,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(IconlyLight.heart),
                  color: colorScheme.primary,
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(IconlyLight.chat),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(IconlyLight.send),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(IconlyLight.bookmark),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Text(
              '${post.likes} ${l10n.string('likes')} · ${post.comments} ${l10n.string('comments')}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Text(post.caption),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
