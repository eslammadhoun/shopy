import 'package:flutter/material.dart';

class GlobalButton extends StatelessWidget {
  final Widget child;
  final Color backgroundColor;
  final BoxBorder border;
  final void Function()? onTap;
  final double? width;
  const GlobalButton({
    super.key,
    required this.backgroundColor,
    required this.border,
    required this.onTap,
    required this.child,
    this.width
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: width,
        height: 54,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(10),
          border: border,
        ),
        child: Center(child: child),
      ),
    );
  }
}
