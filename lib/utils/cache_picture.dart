import 'package:flutter_svg/flutter_svg.dart';

Future precacheSvgPicture(String svgPicture)async {
  final logo = SvgAssetLoader(svgPicture);
  await svg.cache.putIfAbsent(logo.cacheKey(null), () => logo.loadBytes(null));
}