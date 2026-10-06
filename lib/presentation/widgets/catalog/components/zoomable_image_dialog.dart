import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ZoomableImageDialog extends StatelessWidget {
  final String imagePath;
  final String heroTag;

  const ZoomableImageDialog({
    super.key,
    required this.imagePath,
    required this.heroTag,
  });

  static void show(BuildContext context, {required String imagePath, required String heroTag}) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.85),
      builder: (_) => ZoomableImageDialog(imagePath: imagePath, heroTag: heroTag),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Stack(
        alignment: Alignment.center,
        children: [
          InteractiveViewer(
            minScale: 0.8,
            maxScale: 4.0,
            clipBehavior: Clip.none,
            child: Hero(
              tag: heroTag,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(imagePath, fit: BoxFit.contain),
              ),
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: IconButton(
              style: IconButton.styleFrom(
                backgroundColor: Colors.black.withValues(alpha: 0.5),
                shape: const CircleBorder(),
              ),
              icon: const Icon(Icons.close_rounded, color: Colors.white, size: 24),
              onPressed: () => context.pop(),
            ),
          ),
        ],
      ),
    );
  }
}