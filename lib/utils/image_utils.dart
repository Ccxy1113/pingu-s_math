class ImageUtils {
  static int _imageCounter = 0;

  // List of decoration images
  static const List<String> decorationImages = [
    'assets/images/penguin_logo.png',
    'assets/images/penguin_blue.png',
    'assets/images/penguin_strawberry.png',
    'assets/images/penguin_kitty.png',
    'assets/images/penguin_red.png',
    'assets/images/penguin_yellow.png',
    'assets/images/snowman.png',
    'assets/images/snowman_blue.png',
  ];

  static void resetCounter() {
    _imageCounter = 0;
  }

  static String getNextImage(List<String> imageList) {
    final image = imageList[_imageCounter % imageList.length];
    _imageCounter++;
    return image;
  }

  static String getNextDecorationImage() {
    return getNextImage(decorationImages);
  }

  static List<String> getSequentialImages(
    List<String> imageList,
    int count, {
    int startIndex = 0,
  }) {
    if (imageList.isEmpty) {
      return [];
    }

    final selectedImages = <String>[];

    final imagesToSelect = count > imageList.length ? imageList.length : count;

    for (int i = 0; i < imagesToSelect; i++) {
      int index = (startIndex + i) % imageList.length;
      selectedImages.add(imageList[index]);
    }

    return selectedImages;
  }
}
