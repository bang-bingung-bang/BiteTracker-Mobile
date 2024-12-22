class Assets {
  static final svg = _SvgAssets();
  static final images = _ImageAssets();
}

class _SvgAssets {
  final String _basePath = 'assets/svgs';

  String get trackerbites => '$_basePath/trackerbites_background.svg';
}

class _ImageAssets {
  final String _basePath = 'assets/images';

  String get trackerbites => '$_basePath/bitetracker_background2.png';
  String get breakfast => '$_basePath/trackerbites_icon1.png';
  String get lunch => '$_basePath/trackerbites_icon2.png';
  String get dinner => '$_basePath/trackerbites_icon3.png';
  String get snacks => '$_basePath/trackerbites_icon4.png';
  String get background => '$_basePath/background.svg';
}