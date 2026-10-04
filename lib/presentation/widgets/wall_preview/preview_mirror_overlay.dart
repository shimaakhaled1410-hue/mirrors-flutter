import 'package:flutter/material.dart';
import '../../../../data/models/mirror_ui_model.dart';

class PreviewMirrorOverlay extends StatelessWidget {
  final MirrorUiModel mirror;
  final double width;
  final double height;

  const PreviewMirrorOverlay({
    super.key,
    required this.mirror,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    final imagePath = mirror.imagePlaceholder;

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.45),
            blurRadius: 24,
            spreadRadius: 2,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (imagePath != null)
              Image.asset(
                imagePath,
                fit: BoxFit.contain,
              )
            else
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  border: Border.all(
                    color: mirror.category == MirrorCategory.framed
                        ? const Color(0xFFC6A052)
                        : Colors.white70,
                    width: mirror.category == MirrorCategory.framed ? 6 : 2,
                  ),
                ),
              ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: height * 0.45,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white.withValues(alpha: 0.22),
                      Colors.white.withValues(alpha: 0.0),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}