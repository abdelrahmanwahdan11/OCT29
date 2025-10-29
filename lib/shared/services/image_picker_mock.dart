import 'dart:math';

class ImagePickerMock {
  Future<String> pickImage() async {
    final id = Random().nextInt(1000);
    return 'https://picsum.photos/seed/$id/600/600';
  }
}
