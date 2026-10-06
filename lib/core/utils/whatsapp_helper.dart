import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mirrors_app/core/utils/app_snack_bar.dart';
import 'package:url_launcher/url_launcher.dart';

class WhatsAppHelper {
  WhatsAppHelper._();

  static Future<void> openChat({
    BuildContext? context,
    String? customMessage,
    String? errorMessage,
  }) async {
    final rawPhone = dotenv.env['WHATSAPP_SUPPORT_PHONE'] ?? '201012345678';
    final cleanPhone = rawPhone.replaceAll(RegExp(r'[^0-9]'), '');

    final encodedMessage = customMessage != null
        ? Uri.encodeComponent(customMessage)
        : '';
    final urlString =
        'https://wa.me/$cleanPhone${encodedMessage.isNotEmpty ? "?text=$encodedMessage" : ""}';

    final uri = Uri.parse(urlString);

    try {
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      if (!launched &&
          context != null &&
          context.mounted &&
          errorMessage != null) {
        _showErrorSnackBar(context, errorMessage);
      }
    } catch (_) {
      if (context != null && context.mounted && errorMessage != null) {
        _showErrorSnackBar(context, errorMessage);
      }
    }
  }

  static void _showErrorSnackBar(BuildContext context, String message) {
    AppSnackBar.showError(context, message: message);
  }
}
