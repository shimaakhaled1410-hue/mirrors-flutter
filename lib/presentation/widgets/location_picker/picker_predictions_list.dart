import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mirrors_app/core/utils/app_colors.dart';
import 'package:mirrors_app/core/utils/app_styles.dart';
import 'package:mirrors_app/data/services/google_places_service.dart';
import 'package:mirrors_app/l10n/app_localizations.dart';

class PickerPredictionsList extends StatelessWidget {
  final ValueListenable<List<PlacePrediction>> predictions;
  final ValueListenable<bool> noResults;
  final Color surface;
  final ValueChanged<PlacePrediction> onSelected;

  const PickerPredictionsList({
    super.key,
    required this.predictions,
    required this.noResults,
    required this.surface,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<PlacePrediction>>(
      valueListenable: predictions,
      builder: (context, list, _) {
        if (list.isEmpty) return _buildNoResults(context);

        return Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Material(
            color: surface,
            elevation: 4,
            shadowColor: Colors.black26,
            borderRadius: BorderRadius.circular(16),
            clipBehavior: Clip.antiAlias,
            child: ListView.separated(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: list.length,
              separatorBuilder: (_, _) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final item = list[index];
                return ListTile(
                  dense: true,
                  leading: const Icon(
                    Icons.place_outlined,
                    color: AppColors.accent,
                  ),
                  title: Text(
                    item.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppStyles.medium14(context),
                  ),
                  onTap: () => onSelected(item),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildNoResults(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: noResults,
      builder: (context, none, _) {
        if (!none) return const SizedBox.shrink();
        return Container(
          width: double.infinity,
          margin: const EdgeInsets.only(top: 8),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: surface,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            AppLocalizations.of(context)!.noResultsFound,
            style: AppStyles.regular14(context),
          ),
        );
      },
    );
  }
}
