enum ImageSize {
  small(300),
  medium(500),
  large(800);

  const ImageSize(this.size);

  final int size;

  Map<String, String> get imageHeaders => {
        'imageSize': size.toString(),
      };
}
