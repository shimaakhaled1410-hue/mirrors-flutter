import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mirrors_app/l10n/app_localizations.dart';

class PickerSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueListenable<bool> searching;
  final Color surface;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSubmitted;
  final VoidCallback onClear;

  const PickerSearchBar({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.searching,
    required this.surface,
    required this.onChanged,
    required this.onSubmitted,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Material(
      color: surface,
      elevation: 4,
      shadowColor: Colors.black26,
      borderRadius: BorderRadius.circular(28),
      child: Row(
        children: [
          const BackButton(),
          Expanded(
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              onChanged: onChanged,
              onSubmitted: onSubmitted,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                hintText: l10n.searchPlaceHint,
                isDense: true,
                filled: false,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
          ValueListenableBuilder<bool>(
            valueListenable: searching,
            builder: (context, isSearching, _) {
              if (isSearching) {
                return const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 14),
                  child: SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                );
              }
              return ValueListenableBuilder<TextEditingValue>(
                valueListenable: controller,
                builder: (context, value, _) => value.text.isEmpty
                    ? const SizedBox(width: 12)
                    : IconButton(
                        icon: const Icon(Icons.close_rounded),
                        onPressed: onClear,
                      ),
              );
            },
          ),
        ],
      ),
    );
  }
}
