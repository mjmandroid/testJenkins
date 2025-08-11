enum FlutterOriginType{
  androidDrawable('drawable'),
  androidMipmap('mipmap'),
  iosAssets('assets');

  final String name;

  const FlutterOriginType(this.name);
}