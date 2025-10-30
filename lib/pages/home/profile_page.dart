import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../../services/fake_api_service.dart';
import '../../state/app_state.dart';
import '../design/design_system_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  final List<String> _gridImages = [];
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _loadImages();
  }

  Future<void> _loadImages() async {
    if (_loading) return;
    setState(() {
      _loading = true;
    });
    final images = await FakeApiService.fetchGridImages(page: 0, pageSize: 12);
    if (!mounted) return;
    setState(() {
      _gridImages
        ..clear()
        ..addAll(images);
      _loading = false;
    });
  }

  void scrollToTop() {}

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final appState = AppStateScope.of(context);
    final email = appState.email;
    final isGuest = appState.isGuest;
    return RefreshIndicator(
      onRefresh: _loadImages,
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 40,
                backgroundImage: NetworkImage(
                  'https://i.pravatar.cc/150?img=15',
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isGuest ? l10n.string('as_guest') : (email ?? l10n.string('welcome')),
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(l10n.string('tap_settings')),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const DesignSystemPage(),
                    ),
                  );
                },
                icon: const Icon(Icons.palette_outlined),
                tooltip: l10n.string('open_design_system'),
              ),
            ],
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const DesignSystemPage(),
                ),
              );
            },
            icon: const Icon(Icons.style_outlined),
            label: Text(l10n.string('design_tokens')),
          ),
          const SizedBox(height: 12),
          if (!isGuest)
            OutlinedButton.icon(
              onPressed: () => appState.logout(),
              icon: const Icon(Icons.logout),
              label: Text(l10n.string('logout')),
            ),
          const SizedBox(height: 24),
          Text(
            l10n.string('feed'),
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          _loading
              ? const Center(child: CircularProgressIndicator())
              : GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: _gridImages.length,
                  itemBuilder: (context, index) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        _gridImages[index],
                        fit: BoxFit.cover,
                      ),
                    );
                  },
                ),
        ],
      ),
    );
  }
}
