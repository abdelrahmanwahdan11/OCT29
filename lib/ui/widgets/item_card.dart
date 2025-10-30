import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

import '../../data/models/item.dart';

class ItemCard extends StatelessWidget {
  const ItemCard({
    super.key,
    required this.item,
    required this.onTap,
    required this.onFavorite,
    this.onLongPress,
  });

  final Item item;
  final VoidCallback onTap;
  final VoidCallback onFavorite;
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      borderRadius: BorderRadius.circular(12),
      child: Ink(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.shadow.withOpacity(.06),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Hero(
                  tag: 'item-${item.id}',
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: Image.network(
                        item.imageUrl,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, progress) {
                          if (progress == null) return child;
                          return Container(
                            color: theme.colorScheme.surfaceVariant.withOpacity(.3),
                            child: const Center(child: CircularProgressIndicator(strokeWidth: 1.6)),
                          );
                        },
                        errorBuilder: (_, __, ___) => Container(
                          color: theme.colorScheme.surfaceVariant,
                          child: Icon(Icons.image_not_supported, color: theme.colorScheme.outline),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: IconButton(
                    style: IconButton.styleFrom(
                      backgroundColor: theme.colorScheme.surface.withOpacity(.8),
                      minimumSize: const Size(44, 44),
                    ),
                    onPressed: onFavorite,
                    icon: Icon(
                      item.isFavorite ? IconlyBold.heart : IconlyLight.heart,
                      color: item.isFavorite ? theme.colorScheme.primary : theme.colorScheme.onSurface,
                    ),
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '\$${item.price.toStringAsFixed(2)}',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(Icons.star, size: 16, color: theme.colorScheme.secondary),
                      const SizedBox(width: 4),
                      Text('${item.rating}', style: theme.textTheme.bodySmall),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
