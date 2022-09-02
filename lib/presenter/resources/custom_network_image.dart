import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomNetworkImage extends StatelessWidget {
  final String? imageUrl;
  final String? loaderImage;
  final bool? shadow;
  final double? width;
  final double? height;
  final Color? color;
  final BoxFit? imageBoxFit;
  final String? icon;
  final String? imageUrlError;
  final Color? svgIconColor;

  final String regex = "[^\\s]+(.*?)\\.(jpg|jpeg|png|gif|JPG|JPEG|PNG|GIF)\$";
  static const double _blurRadius = 7;
  static const double _shadowOpacity = 0.2;

  const CustomNetworkImage({
    Key? key,
    this.imageUrl,
    this.shadow,
    this.width,
    this.height,
    this.color,
    this.imageBoxFit,
    this.icon,
    this.loaderImage,
    this.svgIconColor,
    this.imageUrlError,
  }) : super(key: key);

  bool isSvg(String? url) {
    if (url == null) {
      return false;
    }
    return !(RegExp(regex).hasMatch(url));
  }

  @override
  Widget build(BuildContext context) {
    return isSvg(imageUrl)
        ? Container(
            decoration: BoxDecoration(boxShadow: [
              if ((shadow ?? false))
                BoxShadow(
                  color: Colors.black.withOpacity(_shadowOpacity),
                  spreadRadius: 0,
                  blurRadius: _blurRadius,
                  offset: const Offset(5, 5),
                ),
            ]),
            child: SvgPicture.network(
              imageUrl ?? "",
              width: width,
              height: height,
              color: svgIconColor,
            ),
          )
        : Container(
            decoration: BoxDecoration(boxShadow: [
              if ((shadow ?? false))
                BoxShadow(
                  color: Colors.black.withOpacity(_shadowOpacity),
                  spreadRadius: 0,
                  blurRadius: _blurRadius,
                  offset: const Offset(5, 5),
                ),
            ]),
            child: FadeInImage(
              width: width,
              height: height,
              fit: imageBoxFit,
              image: NetworkImage(imageUrl ?? ""),
              placeholder: NetworkImage(loaderImage ?? ""),
              imageErrorBuilder: (
                BuildContext context,
                Object object,
                StackTrace? stackTrace,
              ) {
                return CustomNetworkImage(
                  imageUrl: imageUrlError,
                  width: width,
                  height: height,
                );
              },
            ),
          );
  }
}
