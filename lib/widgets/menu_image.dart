import 'package:flutter/material.dart';

class MenuImage extends StatelessWidget {
  final String imagePath;
  final double size;
  final BoxFit fit;

  const MenuImage({
    super.key,
    required this.imagePath,
    this.size = 60,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) {
      return ClipOval(
        child: Image.network(
          imagePath,
          width: size,
          height: size,
          fit: fit,
          errorBuilder: (context, error, stackTrace) => _fallback(),
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return _loadingIndicator();
          },
        ),
      );
    }
    return ClipOval(
      child: Image.asset(
        imagePath,
        width: size,
        height: size,
        fit: fit,
        errorBuilder: (context, error, stackTrace) => _fallback(),
      ),
    );
  }

  Widget _fallback() {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
      child: Icon(Icons.fastfood, color: Colors.grey, size: size * 0.5),
    );
  }

  Widget _loadingIndicator() {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
      child: const Center(
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
    );
  }
}
