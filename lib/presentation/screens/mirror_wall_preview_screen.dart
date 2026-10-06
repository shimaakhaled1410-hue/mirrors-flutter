import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mirrors_app/core/utils/app_snack_bar.dart';
import 'package:mirrors_app/l10n/app_localizations.dart';
import 'package:mirrors_app/presentation/manager/cart/cart_cubit.dart';
import 'package:mirrors_app/presentation/widgets/wall_preview/preview_bottom_card.dart';
import 'package:mirrors_app/presentation/widgets/wall_preview/preview_camera_background.dart';
import 'package:mirrors_app/presentation/widgets/wall_preview/preview_mirror_overlay.dart';
import 'package:mirrors_app/presentation/widgets/wall_preview/preview_top_bar.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../data/models/mirror_ui_model.dart';

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

  void _handleAddToCart(AppLocalizations l10n) {
    context.read<CartCubit>().addRetailItem(widget.mirror);
    context.pop();
    context.read<CartCubit>().addRetailItem(widget.mirror);
    context.pop();
    AppSnackBar.showSuccess(
      context,
      message: '${widget.mirror.dimensions} - ${l10n.addToCart}',
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final ratio = widget.mirror.aspectRatio;

    return Scaffold(
      backgroundColor: const Color(0xFF141318),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final mirrorWidth = (constraints.maxWidth * 0.55) * _scale;
          final mirrorHeight = mirrorWidth / ratio;

          return Stack(
            children: [
              Positioned.fill(
                child: PreviewCameraBackground(
                  controller: _controller,
                  isCameraReady: _isCameraReady,
                  cameraUnavailable: _cameraUnavailable,
                ),
              ),
              Positioned.fill(
                child: GestureDetector(
                  onScaleStart: (_) => _baseScale = _scale,
                  onScaleUpdate: (details) {
                    setState(() {
                      _scale = (_baseScale * details.scale).clamp(0.5, 2.2);
                      _mirrorPosition += details.focalPointDelta;
                    });
                  },
                  child: Center(
                    child: Transform.translate(
                      offset: _mirrorPosition,
                      child: PreviewMirrorOverlay(
                        mirror: widget.mirror,
                        width: mirrorWidth,
                        height: mirrorHeight,
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 20,
                left: 16,
                right: 16,
                child: PreviewTopBar(
                  dimensionsText: '${widget.mirror.dimensions} ${l10n.cm}',
                  onBack: () => context.pop(),
                ),
              ),
              Positioned(
                left: 16,
                right: 16,
                bottom: 20,
                child: PreviewBottomCard(
                  mirror: widget.mirror,
                  onAddToCart: () => _handleAddToCart(l10n),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
