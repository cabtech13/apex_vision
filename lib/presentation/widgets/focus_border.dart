import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

/// Widget pour afficher une border dorée lorsqu'un élément a le focus (navigation télécommande)
class FocusBorder extends StatelessWidget {
  final Widget child;
  final bool hasFocus;
  final double borderRadius;
  final double borderWidth;

  const FocusBorder({
    super.key,
    required this.child,
    required this.hasFocus,
    this.borderRadius = 12.0,
    this.borderWidth = 3.0,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        border:
            hasFocus
                ? Border.all(color: AppColors.focusBorder, width: borderWidth)
                : null,
        boxShadow:
            hasFocus
                ? [
                  BoxShadow(
                    color: AppColors.focusShadow,
                    blurRadius: 16,
                    spreadRadius: 2,
                  ),
                ]
                : null,
      ),
      child: child,
    );
  }
}
