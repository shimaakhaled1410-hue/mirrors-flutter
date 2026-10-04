import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class PreviewCameraBackground extends StatelessWidget {
  final CameraController? controller;
  final bool isCameraReady;
  final bool cameraUnavailable;

  const PreviewCameraBackground({
    super.key,
    required this.controller,
    required this.isCameraReady,
    required this.cameraUnavailable,
  });

  @override
  Widget build(BuildContext context) {
    if (cameraUnavailable || controller == null || !isCameraReady) {
      return Container(
        color: const Color(0xFF1E1E24),
        child: const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.camera_alt_outlined, color: Colors.white38, size: 48),
              SizedBox(height: 12),
              Text(
                'Camera Wall Simulation',
                style: TextStyle(color: Colors.white70, fontSize: 15),
              ),
            ],
          ),
        ),
      );
    }
    return CameraPreview(controller!);
  }
}