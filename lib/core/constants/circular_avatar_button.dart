import 'package:flutter/material.dart';

class CicularAvatarButton extends StatelessWidget {
  final String assetPath;
  final double iconSize;
  final VoidCallback onTap;

  const CicularAvatarButton({
    super.key,
    required this.assetPath,
    required this.iconSize,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final w = size.width;

    return Material(
      color: theme.colorScheme.surface,
      shape: const CircleBorder(),
      elevation: 4,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        splashColor: theme.colorScheme.primary.withOpacity(0.2),
        child: Padding(
          padding: EdgeInsets.all(w * 0.03),
          child: Image.asset(
            assetPath,
            width: iconSize,
            height: iconSize,
          ),
        ),
      ),
    );
  }
}
