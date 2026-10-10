import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mirrors_app/core/routing/app_routes.dart';
import 'package:mirrors_app/core/utils/app_snack_bar.dart';
import 'package:mirrors_app/core/widgets/animated_widgets.dart';
import 'package:mirrors_app/l10n/app_localizations.dart';
import 'package:mirrors_app/presentation/manager/cart/cart_cubit.dart';
import 'package:mirrors_app/presentation/widgets/catalog/category_toggle_filter.dart';
import 'package:mirrors_app/presentation/widgets/catalog/mirror_product_card.dart';
import 'package:mirrors_app/presentation/widgets/catalog/retail_sub_category_filter.dart';
import '../../data/models/mirror_ui_model.dart';

class RetailView extends StatefulWidget {
  const RetailView({super.key});

  @override
  State<RetailView> createState() => _RetailViewState();
}

class _RetailViewState extends State<RetailView> {
  MirrorCategory _selectedCategory = MirrorCategory.framed;
  RetailSubCategory? _selectedSubCategory;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isFramed = _selectedCategory == MirrorCategory.framed;

    final filteredMirrors = kDummyMirrors.where((mirror) {
      if (mirror.category != _selectedCategory) return false;
      if (isFramed && _selectedSubCategory != null) {
        return mirror.subCategory == _selectedSubCategory;
      }
      return true;
    }).toList();

    return Column(
      children: [
        CategoryToggleFilter(
          selectedCategory: _selectedCategory,
          onCategoryChanged: (category) {
            setState(() {
              _selectedCategory = category;
              _selectedSubCategory = null;
            });
          },
          framedLabel: l10n.framedMirrors,
          adhesiveLabel: l10n.adhesiveMirrors,
        ),
        if (isFramed) ...[
          const SizedBox(height: 10),
          RetailSubCategoryFilter(
            selectedFilter: _selectedSubCategory,
            onSelected: (subCategory) {
              setState(() {
                _selectedSubCategory = subCategory;
              });
            },
          ),
        ],
        const SizedBox(height: 4),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              final crossAxisCount = width >= 900
                  ? 4
                  : width >= 600
                      ? 3
                      : 2;

              final childAspectRatio = width >= 600 ? 0.76 : 0.72;

              return GridView.builder(
                key: ValueKey('${_selectedCategory}_$_selectedSubCategory'),
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.only(
                  left: 16,
                  right: 16,
                  top: 8,
                  bottom: 100,
                ),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                  childAspectRatio: childAspectRatio,
                ),
                itemCount: filteredMirrors.length,
                itemBuilder: (context, index) {
                  final mirror = filteredMirrors[index];
                  return FadeSlideIn(
                    index: index,
                    child: MirrorProductCard(
                      mirror: mirror,
                      onAddToCart: () {
                        context.read<CartCubit>().addRetailItem(mirror);
                        AppSnackBar.showSuccess(
                          context,
                          message:
                              '${mirror.dimensions} ${l10n.cm} - ${l10n.addToCart}',
                        );
                      },
                      onPreview: () {
                        context.push(AppRoutes.mirrorWallPreview, extra: mirror);
                      },
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}