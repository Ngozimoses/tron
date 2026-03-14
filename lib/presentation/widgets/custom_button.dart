import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  final Color? color;
  final Color? textColor;
  final double? width;
  final double height;
  final double? textsize;
  final FontWeight? textwidth;
  final double? borderWidth;
  final Color? borderColor;
  final double? borderRadius;
  final Widget? icon; // Changed to Widget? for more flexibility
  final bool isIconLeft; // To control icon position

  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.color,
    this.textColor,
    this.width,
    this.textsize,
    this.textwidth,
    this.height = 50,
    this.borderWidth,
    this.borderColor,
    this.borderRadius,
    this.icon,
    this.isIconLeft = true, // Default icon on left
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: height,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color ?? AppColors.primary,

          padding: const EdgeInsets.symmetric(vertical: 10),
          elevation: 2,
          shadowColor: AppColors.shadow,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 12),
            side: borderWidth != null && borderColor != null
                ? BorderSide(
              color: borderColor!,
              width: borderWidth!,
            )
                : BorderSide.none,
          ),
          disabledBackgroundColor: AppColors.divider,
        ),
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? const SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        )
            : _buildButtonContent(),
      ),
    );
  }

  Widget _buildButtonContent() {
    // If no icon, just return text
    if (icon == null) {
      return Text(
        text,
        style: TextStyle(
          color: textColor ?? AppColors.textWhite,
          fontSize: textsize ?? 16,
          fontWeight: textwidth ?? FontWeight.w600,
        ),
      );
    }

    // With icon
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: isIconLeft
          ? [
        icon!,
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(
            color: textColor ?? AppColors.textWhite,
            fontSize: textsize ?? 16,
            fontWeight: textwidth ?? FontWeight.w600,
          ),
        ),
      ]
          : [
        Text(
          text,
          style: TextStyle(
            color: textColor ?? AppColors.textWhite,
            fontSize: textsize ?? 16,
            fontWeight: textwidth ?? FontWeight.w600,
          ),
        ),
        const SizedBox(width: 8),
        icon!,
      ],
    );
  }

}