import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mirrors_app/presentation/manager/cart/cart_cubit.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/app_styles.dart';
import '../../../core/widgets/animated_widgets.dart';
import '../../../data/models/mirror_ui_model.dart';
import '../../../l10n/app_localizations.dart';

class MirrorWallPreviewScreen extends StatefulWidget {
  final MirrorUiModel mirror;

  const MirrorWallPreviewScreen({super.key, required this.mirror});

  @override
  State<MirrorWallPreviewScreen> createState() =>
      _MirrorWallPreviewScreenState();
}

class _MirrorWallPreviewScreenState extends State<MirrorWallPreviewScreen> {
  CameraController? _controller;
  bool _isCameraReady = false;
  bool _cameraUnavailable = false;

  Offset _mirrorPosition = Offset.zero;
  double _scale = 1.0;
  double _baseScale = 1.0;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    if (!kIsWeb) {
      final status = await Permission.camera.request();
      if (!status.isGranted) {
        if (mounted) setState(() => _cameraUnavailable = true);
        return;
      }
    }

    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        if (mounted) setState(() => _cameraUnavailable = true);
        return;
      }

      final backCamera = cameras.firstWhere(
        (cam) => cam.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );

      _controller = CameraController(
        backCamera,
        ResolutionPreset.medium,
        enableAudio: false,
      );

      await _controller!.initialize();
      if (mounted) setState(() => _isCameraReady = true);
    } catch (_) {
      if (mounted) setState(() => _cameraUnavailable = true);
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final ratio = widget.mirror.aspectRatio;

    return Scaffold(
      backgroundColor: const Color(0xFF141318),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final mirrorWidth = (constraints.maxWidth * 0.52) * _scale;
          final mirrorHeight = mirrorWidth / ratio;

          return Stack(
            children: [
              Positioned.fill(
                child: _buildCameraBackground(),
              ),
              Positioned.fill(
                child: GestureDetector(
                  onScaleStart: (_) => _baseScale = _scale,
                  onScaleUpdate: (details) {
                    setState(() {
                      _scale = (_baseScale * details.scale).clamp(0.6, 2.0);
                      _mirrorPosition += details.focalPointDelta;
                    });
                  },
                  child: Center(
                    child: Transform.translate(
                      offset: _mirrorPosition,
                      child: _buildMirrorOverlay(mirrorWidth, mirrorHeight),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 20,
                left: 16,
                right: 16,
                child: SafeArea(
                  child: Row(
                    children: [
                      PressableScale(
                        child: CircleAvatar(
                          backgroundColor: Colors.black54,
                          child: IconButton(
                            icon: const Icon(
                              Icons.arrow_back_ios_new_rounded,
                              color: Colors.white,
                              size: 18,
                            ),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.pinch_rounded,
                              color: Colors.white70,
                              size: 16,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '${widget.mirror.dimensions} ${l10n.cm}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 16,
                right: 16,
                bottom: 20,
                child: SafeArea(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor.withValues(alpha: 0.94),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.3),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${widget.mirror.dimensions} ${l10n.cm}',
                                style: AppStyles.bold16Accent,
                              ),
                              Text(
                                '${widget.mirror.retailPrice.toInt()} ${l10n.egp}',
                                style: AppStyles.medium14(context),
                              ),
                            ],
                          ),
                        ),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                          ),
                          onPressed: () {
                            context
                                .read<CartCubit>()
                                .addRetailItem(widget.mirror);
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  '${widget.mirror.dimensions} - ${l10n.addToCart}',
                                ),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          },
                          icon: const Icon(
                            Icons.add_shopping_cart_rounded,
                            size: 18,
                          ),
                          label: Text(l10n.addToCart),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCameraBackground() {
    if (_cameraUnavailable || _controller == null || !_isCameraReady) {
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
    return CameraPreview(_controller!);
  }

  Widget _buildMirrorOverlay(double width, double height) {
    final hasShelf = widget.mirror.subCategory == RetailSubCategory.withShelf;

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(
          widget.mirror.category == MirrorCategory.framed ? 16 : 4,
        ),
        border: Border.all(
          color: widget.mirror.category == MirrorCategory.framed
              ? const Color(0xFFC6A052)
              : Colors.white70,
          width: widget.mirror.category == MirrorCategory.framed ? 6 : 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.4),
            blurRadius: 18,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: height * 0.45,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withValues(alpha: 0.35),
                    Colors.white.withValues(alpha: 0.0),
                  ],
                ),
              ),
            ),
          ),
          if (hasShelf)
            Positioned(
              left: -6,
              right: -6,
              bottom: 12,
              child: Container(
                height: 10,
                decoration: BoxDecoration(
                  color: Colors.cyanAccent.withValues(alpha: 0.45),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: Colors.white, width: 1.2),
                ),
              ),
            ),
        ],
      ),
    );
  }
}