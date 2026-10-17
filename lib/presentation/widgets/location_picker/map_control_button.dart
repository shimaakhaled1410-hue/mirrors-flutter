import 'package:flutter/material.dart';

class MapControlButton extends StatelessWidget {
  final IconData icon;
  final String? tooltip;
  final Color surface;
  final bool loading;
  final VoidCallback onPressed;

  const MapControlButton({
    super.key,
    required this.icon,
    required this.surface,
    required this.onPressed,
    this.tooltip,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: surface,
      elevation: 4,
      shadowColor: Colors.black26,
      shape: const CircleBorder(),
      child: IconButton(
        tooltip: tooltip,
        onPressed: loading ? null : onPressed,
        icon: loading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : Icon(icon, size: 22),
      ),
    );
  }
}