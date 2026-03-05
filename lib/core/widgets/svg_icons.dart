import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PngIcons {
  // ═══════════════════════════════════════════════════════
  // PNG Icons
  // ═══════════════════════════════════════════════════════

  static Widget alarmClock({
    double size = 32,
    BoxFit fit = BoxFit.contain,
    double? width,
    double? height,
  }) {
    return _pngIcon(
      'assets/icons/alarm-clock.png',
      size: size,
      fit: fit,
      width: width,
      height: height,
    );
  }

  static Widget clothes({
    double size = 32,
    BoxFit fit = BoxFit.contain,
    double? width,
    double? height,
  }) {
    return _pngIcon(
      'assets/icons/clothes.png',
      size: size,
      fit: fit,
      width: width,
      height: height,
    );
  }

  static Widget copy({
    double size = 32,
    BoxFit fit = BoxFit.contain,
    double? width,
    double? height,
  }) {
    return _pngIcon(
      'assets/icons/Copy.png',
      size: size,
      fit: fit,
      width: width,
      height: height,
    );
  }

  static Widget ellipse37({
    double size = 32,
    BoxFit fit = BoxFit.contain,
    double? width,
    double? height,
  }) {
    return _pngIcon(
      'assets/icons/Ellipse 37.png',
      size: size,
      fit: fit,
      width: width,
      height: height,
    );
  }

  static Widget fingerPrint({
    double size = 32,
    BoxFit fit = BoxFit.contain,
    double? width,
    double? height,
  }) {
    return _pngIcon(
      'assets/icons/Finger Print.png',
      size: size,
      fit: fit,
      width: width,
      height: height,
    );
  }

  static Widget icon({
    double size = 32,
    BoxFit fit = BoxFit.contain,
    double? width,
    double? height,
  }) {
    return _pngIcon(
      'assets/icons/icon.png',
      size: size,
      fit: fit,
      width: width,
      height: height,
    );
  }

  static Widget idea({
    double size = 32,
    BoxFit fit = BoxFit.contain,
    double? width,
    double? height,
  }) {
    return _pngIcon(
      'assets/icons/idea.png',
      size: size,
      fit: fit,
      width: width,
      height: height,
    );
  }

  static Widget idea1({
    double size = 32,
    BoxFit fit = BoxFit.contain,
    double? width,
    double? height,
  }) {
    return _pngIcon(
      'assets/icons/idea (1).png',
      size: size,
      fit: fit,
      width: width,
      height: height,
    );
  }

  static Widget image89({
    double size = 32,
    BoxFit fit = BoxFit.contain,
    double? width,
    double? height,
  }) {
    return _pngIcon(
      'assets/icons/image 89.png',
      size: size,
      fit: fit,
      width: width,
      height: height,
    );
  }

  static Widget image91({
    double size = 32,
    BoxFit fit = BoxFit.contain,
    double? width,
    double? height,
  }) {
    return _pngIcon(
      'assets/icons/image 91.png',
      size: size,
      fit: fit,
      width: width,
      height: height,
    );
  }

  static Widget image92({
    double size = 32,
    BoxFit fit = BoxFit.contain,
    double? width,
    double? height,
  }) {
    return _pngIcon(
      'assets/icons/image 92.png',
      size: size,
      fit: fit,
      width: width,
      height: height,
    );
  }

  static Widget image921({
    double size = 32,
    BoxFit fit = BoxFit.contain,
    double? width,
    double? height,
  }) {
    return _pngIcon(
      'assets/icons/image 92 (1).png',
      size: size,
      fit: fit,
      width: width,
      height: height,
    );
  }

  static Widget image922({
    double size = 32,
    BoxFit fit = BoxFit.contain,
    double? width,
    double? height,
  }) {
    return _pngIcon(
      'assets/icons/image 92 (2).png',
      size: size,
      fit: fit,
      width: width,
      height: height,
    );
  }

  static Widget image93({
    double size = 32,
    BoxFit fit = BoxFit.contain,
    double? width,
    double? height,
  }) {
    return _pngIcon(
      'assets/icons/image 93.png',
      size: size,
      fit: fit,
      width: width,
      height: height,
    );
  }

  static Widget medicalMask({
    double size = 32,
    BoxFit fit = BoxFit.contain,
    double? width,
    double? height,
  }) {
    return _pngIcon(
      'assets/icons/medical-mask.png',
      size: size,
      fit: fit,
      width: width,
      height: height,
    );
  }

  // ═══════════════════════════════════════════════════════
  // Helper Method
  // ═══════════════════════════════════════════════════════

  static Widget _pngIcon(
      String path, {
        double size = 24,
        BoxFit fit = BoxFit.contain,
        double? width,
        double? height,
      }) {
    return Image.asset(
      path,
      width: width ?? size,
      height: height ?? size,
      fit: fit,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          width: width ?? size,
          height: height ?? size,
          color: Colors.grey[300],
          child: const Icon(
            Icons.broken_image,
            color: Colors.grey,
          ),
        );
      },
    );
  }
}
class SvgIcons {
  // ═══════════════════════════════════════════════════════
  // Navigation Icons
  // ═══════════════════════════════════════════════════════

  static Widget estate({
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

  static Widget announcement({
    double size = 32,
    Color? color,
    double? width,
    double? height,
  }) {
    return _svgIcon(
      'assets/icons/Announcement.svg',
      size: size,
      color: color,
      width: width,
      height: height,
    );
  }

  static Widget barcode({
    double size = 32,
    Color? color,
    double? width,
    double? height,
  }) {
    return _svgIcon(
      'assets/icons/Barcode.svg',
      size: size,
      color: color,
      width: width,
      height: height,
    );
  }

  static Widget biometricAccess({
    double size = 32,
    Color? color,
    double? width,
    double? height,
  }) {
    return _svgIcon(
      'assets/icons/biometric-access.svg',
      size: size,
      color: color,
      width: width,
      height: height,
    );
  }

  static Widget bubbleChat({
    double size = 32,
    Color? color,
    double? width,
    double? height,
  }) {
    return _svgIcon(
      'assets/icons/bubble-chat.svg',
      size: size,
      color: color,
      width: width,
      height: height,
    );
  }

  static Widget call02({
    double size = 32,
    Color? color,
    double? width,
    double? height,
  }) {
    return _svgIcon(
      'assets/icons/call-02.svg',
      size: size,
      color: color,
      width: width,
      height: height,
    );
  }

  static Widget clothes({
    double size = 32,
    Color? color,
    double? width,
    double? height,
  }) {
    return _svgIcon(
      'assets/icons/clothes.svg',
      size: size,
      color: color,
      width: width,
      height: height,
    );
  }

  static Widget  copy({
    double size = 32,
    Color? color,
    double? width,
    double? height,
  }) {
    return _svgIcon(
      'assets/icons/Copy.svg',
      size: size,
      color: color,
      width: width,
      height: height,
    );
  }

  static Widget creditCard({
    double size = 32,
    Color? color,
    double? width,
    double? height,
  }) {
    return _svgIcon(
      'assets/icons/credit-card.svg',
      size: size,
      color: color,
      width: width,
      height: height,
    );
  }

  static Widget devices({
    double size = 32,
    Color? color,
    double? width,
    double? height,
  }) {
    return _svgIcon(
      'assets/icons/Devices.svg',
      size: size,
      color: color,
      width: width,
      height: height,
    );
  }

  static Widget  faceId({
    double size = 32,
    Color? color,
    double? width,
    double? height,
  }) {
    return _svgIcon(
      'assets/icons/Face ID.svg',
      size: size,
      color: color,
      width: width,
      height: height,
    );
  }

  static Widget fingerPrint({
    double size = 32,
    Color? color,
    double? width,
    double? height,
  }) {
    return _svgIcon(
      'assets/icons/Finger Print.svg',
      size: size,
      color: color,
      width: width,
      height: height,
    );
  }

  static Widget frame1618869293({
    double size = 32,
    Color? color,
    double? width,
    double? height,
  }) {
    return _svgIcon(
      'assets/icons/Frame 1618869293.svg',
      size: size,
      color: color,
      width: width,
      height: height,
    );
  }

  static Widget frame1618869293_1({
    double size = 32,
    Color? color,
    double? width,
    double? height,
  }) {
    return _svgIcon(
      'assets/icons/Frame 1618869293 (1).svg',
      size: size,
      color: color,
      width: width,
      height: height,
    );
  }

  static Widget frame1618869443({
    double size = 32,
    Color? color,
    double? width,
    double? height,
  }) {
    return _svgIcon(
      'assets/icons/Frame 1618869443.svg',
      size: size,
      color: color,
      width: width,
      height: height,
    );
  }

  static Widget frame1618870082({
    double size = 32,
    Color? color,
    double? width,
    double? height,
  }) {
    return _svgIcon(
      'assets/icons/Frame 1618870082.svg',
      size: size,
      color: color,
      width: width,
      height: height,
    );
  }

  static Widget frame1618870092({
    double size = 32,
    Color? color,
    double? width,
    double? height,
  }) {
    return _svgIcon(
      'assets/icons/Frame 1618870092.svg',
      size: size,
      color: color,
      width: width,
      height: height,
    );
  }

  static Widget giftCard({
    double size = 32,
    Color? color,
    double? width,
    double? height,
  }) {
    return _svgIcon(
      'assets/icons/gift-card.svg',
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
      'assets/icons/group.svg',
      size: size,
      color: color,
      width: width,
      height: height,
    );
  }

  static Widget helpSquare({
    double size = 32,
    Color? color,
    double? width,
    double? height,
  }) {
    return _svgIcon(
      'assets/icons/help-square.svg',
      size: size,
      color: color,
      width: width,
      height: height,
    );
  }

  static Widget  helpSquare1({
    double size = 32,
    Color? color,
    double? width,
    double? height,
  }) {
    return _svgIcon(
      'assets/icons/help-square (1).svg',
      size: size,
      color: color,
      width: width,
      height: height,
    );
  }

  static Widget home01({
    double size = 32,
    Color? color,
    double? width,
    double? height,
  }) {
    return _svgIcon(
      'assets/icons/home-01.svg',
      size: size,
      color: color,
      width: width,
      height: height,
    );
  }
  static Widget filter({
    double size = 32,
    Color? color,
    double? width,
    double? height,
  }) {
    return _svgIcon(
      'assets/icons/Vector.svg',
      size: size,
      color: color,
      width: width,
      height: height,
    );
  }
  static Widget general({
    double size = 32,
    Color? color,
    double? width,
    double? height,
  }) {
    return _svgIcon(
      'assets/icons/visitor.svg',
      size: size,
      color: color,
      width: width,
      height: height,
    );
  }
  static Widget search({
    double size = 32,
    Color? color,
    double? width,
    double? height,
  }) {
    return _svgIcon(
      'assets/icons/search-01.svg',
      size: size,
      color: color,
      width: width,
      height: height,
    );
  }
  static Widget home02({
    double size = 32,
    Color? color,
    double? width,
    double? height,
  }) {
    return _svgIcon(
      'assets/icons/home-02 (1).svg',
      size: size,
      color: color,
      width: width,
      height: height,
    );
  }
  static Widget idea({
    double size = 32,
    Color? color,
    double? width,
    double? height,
  }) {
    return _svgIcon(
      'assets/icons/idea.svg',
      size: size,
      color: color,
      width: width,
      height: height,
    );
  }

  static Widget logoutCircle02({
    double size = 32,
    Color? color,
    double? width,
    double? height,
  }) {
    return _svgIcon(
      'assets/icons/logout-circle-02.svg',
      size: size,
      color: color,
      width: width,
      height: height,
    );
  }

  static Widget mail01({
    double size = 32,
    Color? color,
    double? width,
    double? height,
  }) {
    return _svgIcon(
      'assets/icons/mail-01.svg',
      size: size,
      color: color,
      width: width,
      height: height,
    );
  }

  static Widget medicalMask({
    double size = 32,
    Color? color,
    double? width,
    double? height,
  }) {
    return _svgIcon(
      'assets/icons/medical-mask.svg',
      size: size,
      color: color,
      width: width,
      height: height,
    );
  }

  static Widget notification01({
    double size = 32,
    Color? color,
    double? width,
    double? height,
  }) {
    return _svgIcon(
      'assets/icons/notification-01.svg',
      size: size,
      color: color,
      width: width,
      height: height,
    );
  }

  static Widget  notification02({
    double size = 32,
    Color? color,
    double? width,
    double? height,
  }) {
    return _svgIcon(
      'assets/icons/notification-02.svg',
      size: size,
      color: color,
      width: width,
      height: height,
    );
  }

  static Widget  notification021({
    double size = 32,
    Color? color,
    double? width,
    double? height,
  }) {
    return _svgIcon(
      'assets/icons/notification-02 (1).svg',
      size: size,
      color: color,
      width: width,
      height: height,
    );
  }

  static Widget party({
    double size = 32,
    Color? color,
    double? width,
    double? height,
  }) {
    return _svgIcon(
      'assets/icons/party.svg',
      size: size,
      color: color,
      width: width,
      height: height,
    );
  }

  static Widget plus({
    double size = 32,
    Color? color,
    double? width,
    double? height,
  }) {
    return _svgIcon(
      'assets/icons/Plus.svg',
      size: size,
      color: color,
      width: width,
      height: height,
    );
  }

  static Widget  profile({
    double size = 32,
    Color? color,
    double? width,
    double? height,
  }) {
    return _svgIcon(
      'assets/icons/Profile.svg',
      size: size,
      color: color,
      width: width,
      height: height,
    );
  }
  static Widget  profile2({
    double size = 32,
    Color? color,
    double? width,
    double? height,
  }) {
    return _svgIcon(
      'assets/icons/Profile2.svg',
      size: size,
      color: color,
      width: width,
      height: height,
    );
  }
  static Widget qrCode({
    double size = 32,
    Color? color,
    double? width,
    double? height,
  }) {
    return _svgIcon(
      'assets/icons/QR code.svg',
      size: size,
      color: color,
      width: width,
      height: height,
    );
  }

  static Widget report({
    double size = 32,
    Color? color,
    double? width,
    double? height,
  }) {
    return _svgIcon(
      'assets/icons/Report.svg',
      size: size,
      color: color,
      width: width,
      height: height,
    );
  }

  static Widget scan({
    double size = 32,
    Color? color,
    double? width,
    double? height,
  }) {
    return _svgIcon(
      'assets/icons/Scan.svg',
      size: size,
      color: color,
      width: width,
      height: height,
    );
  }

  static Widget scanSmiley({
    double size = 32,
    Color? color,
    double? width,
    double? height,
  }) {
    return _svgIcon(
      'assets/icons/ScanSmiley.svg',
      size: size,
      color: color,
      width: width,
      height: height,
    );
  }

  static Widget searchCircle({
    double size = 32,
    Color? color,
    double? width,
    double? height,
  }) {
    return _svgIcon(
      'assets/icons/search-circle.svg',
      size: size,
      color: color,
      width: width,
      height: height,
    );
  }

  static Widget security({
    double size = 32,
    Color? color,
    double? width,
    double? height,
  }) {
    return _svgIcon(
      'assets/icons/Security.svg',
      size: size,
      color: color,
      width: width,
      height: height,
    );
  }

  static Widget settingError03({
    double size = 32,
    Color? color,
    double? width,
    double? height,
  }) {
    return _svgIcon(
      'assets/icons/setting-error-03.svg',
      size: size,
      color: color,
      width: width,
      height: height,
    );
  }


  static Widget settings01({
    double size = 32,
    Color? color,
    double? width,
    double? height,
  }) {
    return _svgIcon(
      'assets/icons/settings-01.svg',
      size: size,
      color: color,
      width: width,
      height: height,
    );
  }
  static Widget settings02({
    double size = 32,
    Color? color,
    double? width,
    double? height,
  }) {
    return _svgIcon(
      'assets/icons/settings-02.svg',
      size: size,
      color: color,
      width: width,
      height: height,
    );
  }

  static Widget share({
    double size = 32,
    Color? color,
    double? width,
    double? height,
  }) {
    return _svgIcon(
      'assets/icons/share.svg',
      size: size,
      color: color,
      width: width,
      height: height,
    );
  }

  static Widget share03({
    double size = 32,
    Color? color,
    double? width,
    double? height,
  }) {
    return _svgIcon(
      'assets/icons/share-03.svg',
      size: size,
      color: color,
      width: width,
      height: height,
    );
  }

  static Widget shoppingBag02({
    double size = 32,
    Color? color,
    double? width,
    double? height,
  }) {
    return _svgIcon(
      'assets/icons/shopping-bag-02.svg',
      size: size,
      color: color,
      width: width,
      height: height,
    );
  }

  static Widget store01({
    double size = 32,
    Color? color,
    double? width,
    double? height,
  }) {
    return _svgIcon(
      'assets/icons/store-01.svg',
      size: size,
      color: color,
      width: width,
      height: height,
    );
  }
  static Widget store02({
    double size = 32,
    Color? color,
    double? width,
    double? height,
  }) {
    return _svgIcon(
      'assets/icons/store-02.svg',
      size: size,
      color: color,
      width: width,
      height: height,
    );
  }
  static Widget subResident({
    double size = 32,
    Color? color,
    double? width,
    double? height,
  }) {
    return _svgIcon(
      'assets/icons/Sub Resident.svg',
      size: size,
      color: color,
      width: width,
      height: height,
    );
  }

  static Widget tick01({
    double size = 32,
    Color? color,
    double? width,
    double? height,
  }) {
    return _svgIcon(
      'assets/icons/tick-01.svg',
      size: size,
      color: color,
      width: width,
      height: height,
    );
  }

  static Widget userList({
    double size = 32,
    Color? color,
    double? width,
    double? height,
  }) {
    return _svgIcon(
      'assets/icons/user-list.svg',
      size: size,
      color: color,
      width: width,
      height: height,
    );
  }

  static Widget userSharing({
    double size = 32,
    Color? color,
    double? width,
    double? height,
  }) {
    return _svgIcon(
      'assets/icons/user-sharing.svg',
      size: size,
      color: color,
      width: width,
      height: height,
    );
  }

  static Widget  visitor({
    double size = 32,
    Color? color,
    double? width,
    double? height,
  }) {
    return _svgIcon(
      'assets/icons/Visitor.svg',
      size: size,
      color: color,
      width: width,
      height: height,
    );
  }

  // ═══════════════════════════════════════════════════════
  // Helper Method
  // ═══════════════════════════════════════════════════════

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
        child: Container(color: Colors.black26,),
      ),
    );
  }
}