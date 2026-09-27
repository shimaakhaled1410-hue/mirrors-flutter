import 'package:flutter/material.dart';
import 'package:mirrors_app/l10n/app_localizations.dart';
import '../../data/models/mirror_ui_model.dart';
import '../widgets/catalog/category_toggle_filter.dart';
import '../widgets/catalog/wholesale_product_card.dart';

class WholesaleView extends StatefulWidget {
  const WholesaleView({super.key});

  @override
  State<WholesaleView> createState() => _WholesaleViewState();
}

class _WholesaleViewState extends State<WholesaleView> {
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
          child: ListView.builder(
            padding: const EdgeInsets.only(
              left: 16,
              right: 16,
              top: 8,
              bottom: 100, // padding to float above bottom navigation bar
            ),
            itemCount: filteredMirrors.length,
            itemBuilder: (context, index) {
              final mirror = filteredMirrors[index];
              return WholesaleProductCard(
                mirror: mirror,
                onAddToCart: (tier, totalPrice) {
                  // TODO: Add wholesale batch to cart
                },
              );
            },
          ),
        ),
      ],
    );
  }
}