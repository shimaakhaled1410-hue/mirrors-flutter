import 'package:flutter/material.dart';
import 'package:mirrors_app/core/widgets/animated_widgets.dart';
import 'package:mirrors_app/l10n/app_localizations.dart';
import 'package:mirrors_app/presentation/widgets/catalog/category_toggle_filter.dart';
import 'package:mirrors_app/presentation/widgets/catalog/mirror_product_card.dart';
import '../../data/models/mirror_ui_model.dart';

class RetailView extends StatefulWidget {
  const RetailView({super.key});

  @override
  State<RetailView> createState() => _RetailViewState();
}

class _RetailViewState extends State<RetailView> {
  MirrorCategory _selectedCategory = MirrorCategory.framed;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final filteredMirrors = kDummyMirrors
        .where((mirror) => mirror.category == _selectedCategory)
        .toList();

    return Column(
      children: [
        CategoryToggleFilter(
          selectedCategory: _selectedCategory,
          onCategoryChanged: (category) {
            setState(() {
              _selectedCategory = category;
            });
          },
          framedLabel: l10n.framedMirrors,
          adhesiveLabel: l10n.adhesiveMirrors,
        ),
        Expanded(
          child: GridView.builder(
            key: ValueKey(_selectedCategory),
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.only(
              left: 16,
              right: 16,
              top: 8,
              bottom: 100,
            ),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
              childAspectRatio: 0.72,
            ),
            itemCount: filteredMirrors.length,
            itemBuilder: (context, index) {
              final mirror = filteredMirrors[index];
              return FadeSlideIn(
                index: index,
                child: MirrorProductCard(
                  mirror: mirror,
                  onAddToCart: () {
                    // TODO: Add product to retail cart
                  },
                  onPreview: () {
                    // TODO: Open Camera AR Preview
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}