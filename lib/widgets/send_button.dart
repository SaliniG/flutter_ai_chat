import 'package:flutter/material.dart';

class SendButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final ColorScheme colorScheme;

  const SendButton({
    super.key,
    required this.onPressed,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: onPressed == null
          ? colorScheme.surfaceContainerHighest
          : colorScheme.primary,
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(24),
        child: Container(
          width: 48,
          height: 48,
          alignment: Alignment.center,
          child: Icon(
            Icons.send_rounded,
            size: 22,
            color: onPressed == null
                ? colorScheme.onSurfaceVariant
                : colorScheme.onPrimary,
          ),
        ),
      ),
    );
  }
}
