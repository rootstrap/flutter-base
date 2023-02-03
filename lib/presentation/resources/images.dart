part of 'resources.dart';

/// Add images references here
/// call: Images.appLogo.get()
/// **/
enum Images {
  appLogo,
}

extension LoadImage on Images {
  static const assetsFolder = "assets";
  static const imagesResFolder = "$assetsFolder/images";
  static const icResFolder = "$assetsFolder/icons";
  static const svgResFolder = "$assetsFolder/svg";

  static final Map<Images, String> _imagesValues = {
    Images.appLogo: '$icResFolder/logo.png',
  };

  String get value => _imagesValues[this]!;

  Widget svg({
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    Color? color,
    Alignment alignment = Alignment.center,
    String? semanticLabel,
  }) =>
      _SvgImage.asset(
        value,
        width: width,
        height: height,
        fit: fit,
        color: color,
        alignment: alignment,
        semanticLabel: semanticLabel,
      );

  Widget get({
    Key? key,
    double? scale,
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    Color? color,
    Alignment alignment = Alignment.center,
    String? semanticLabel,
  }) {
    if (value.endsWith("svg")) {
      return svg(
        width: width,
        height: height,
        fit: fit,
        color: color,
        alignment: alignment,
        semanticLabel: semanticLabel,
      );
    }

    return img(
      key: key,
      scale: scale,
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
    );
  }

  Image img({
    Key? key,
    double? scale,
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    Alignment alignment = Alignment.center,
  }) =>
      Image.asset(
        value,
        bundle: assetImage().bundle,
        height: width,
        width: width,
        scale: scale,
        fit: fit,
        alignment: alignment,
      );

  AssetImage assetImage() => AssetImage(value);
}

class _SvgImage {
  static Widget asset(
    String assetPath, {
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    Color? color,
    Alignment alignment = Alignment.center,
    String? semanticLabel,
    String? package,
    @visibleForTesting bool isWeb = false,
  }) {
    return SvgPicture.asset(
      assetPath,
      key: Key(assetPath),
      width: width,
      height: height,
      fit: fit,
      color: color,
      alignment: alignment,
      semanticsLabel: semanticLabel,
      package: package,
    );
  }
}
