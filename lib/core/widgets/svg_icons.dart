import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SvgIcons {
  // ═══════════════════════════════════════════════════════
  // Navigation Icons
  // ═══════════════════════════════════════════════════════

  static Widget esate({
    double size = 32,
    Color? color,
    double? width,
    double? height,
  }) {
    return _svgIcon(
      'assets/icons/estate.svg',
      size: size,
      color: color,
      width: width,
      height: height,
    );
  }
  static Widget group({
    double size = 32,
    Color? color,
    double? width,
    double? height,
  }) {
    return _svgIcon(
      'assets/images/group.svg',
      size: size,
      color: color,
      width: width,
      height: height,
    );
  }

  static Widget _svgIcon(
      String path, {
        double size = 24,
        Color? color,
        double? width,
        double? height,
      }) {
    return SvgPicture.asset(
      path,
      width: width ?? size,
      height: height ?? size,
      colorFilter: color != null
          ? ColorFilter.mode(color, BlendMode.srcIn)
          : null,
      placeholderBuilder: (BuildContext context) => SizedBox(
        width: width ?? size,
        height: height ?? size,
        child: const CircularProgressIndicator(),
      ),
    );
  }
}