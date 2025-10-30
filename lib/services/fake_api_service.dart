import 'dart:math';

class FakePost {
  FakePost({
    required this.id,
    required this.userName,
    required this.avatarUrl,
    required this.imageUrl,
    required this.caption,
    required this.likes,
    required this.comments,
  });

  final int id;
  final String userName;
  final String avatarUrl;
  final String imageUrl;
  final String caption;
  final int likes;
  final int comments;
}

class FakeApiService {
  static final Random _random = Random(42);

  static Future<List<FakePost>> fetchPosts({
    required int page,
    required int pageSize,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    final startId = page * pageSize;
    return List.generate(pageSize, (index) {
      final id = startId + index;
      final avatarId = (id % 70) + 1;
      final imageId = (100 + (id % 900));
      return FakePost(
        id: id,
        userName: 'User #$avatarId',
        avatarUrl: 'https://i.pravatar.cc/150?img=$avatarId',
        imageUrl: 'https://picsum.photos/id/$imageId/800/1000',
        caption: 'A cool photo #$id',
        likes: 100 + _random.nextInt(900),
        comments: 5 + _random.nextInt(120),
      );
    });
  }

  static Future<List<String>> fetchGridImages({
    required int page,
    required int pageSize,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    final startId = page * pageSize;
    return List.generate(pageSize, (index) {
      final id = 200 + ((startId + index) % 900);
      return 'https://picsum.photos/id/$id/600/600';
    });
  }

  static Future<List<String>> fetchStories({int count = 16}) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    return List.generate(count, (index) {
      final avatarId = (index % 70) + 1;
      return 'https://i.pravatar.cc/150?img=$avatarId';
    });
  }
}
