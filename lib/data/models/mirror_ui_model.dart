enum MirrorCategory {
  framed,
  adhesive;

  String toJson() => name;
  static MirrorCategory fromJson(String json) =>
      MirrorCategory.values.firstWhere(
        (e) => e.name == json,
        orElse: () => MirrorCategory.framed,
      );
}

enum RetailSubCategory {
  standard,
  specialSize,
  withShelf;

  String toJson() => name;
  static RetailSubCategory fromJson(String json) =>
      RetailSubCategory.values.firstWhere(
        (e) => e.name == json,
        orElse: () => RetailSubCategory.standard,
      );
}

class MirrorUiModel {
  final String id;
  final String dimensions;
  final MirrorCategory category;
  final RetailSubCategory subCategory;
  final double retailPrice;
  final double wholesalePrice;
  final String? imagePlaceholder;

  const MirrorUiModel({
    required this.id,
    required this.dimensions,
    required this.category,
    this.subCategory = RetailSubCategory.standard,
    required this.retailPrice,
    required this.wholesalePrice,
    this.imagePlaceholder,
  });

  bool get isRetailOnly =>
      subCategory == RetailSubCategory.specialSize ||
      subCategory == RetailSubCategory.withShelf;

  Map<String, dynamic> toJson() => {
        'id': id,
        'dimensions': dimensions,
        'category': category.toJson(),
        'subCategory': subCategory.toJson(),
        'retailPrice': retailPrice,
        'wholesalePrice': wholesalePrice,
        if (imagePlaceholder != null) 'imagePlaceholder': imagePlaceholder,
      };

  factory MirrorUiModel.fromJson(Map<String, dynamic> json) => MirrorUiModel(
        id: json['id'] as String,
        dimensions: json['dimensions'] as String,
        category: MirrorCategory.fromJson(json['category'] as String),
        subCategory: RetailSubCategory.fromJson(
          json['subCategory'] as String? ?? RetailSubCategory.standard.name,
        ),
        retailPrice: (json['retailPrice'] as num).toDouble(),
        wholesalePrice: (json['wholesalePrice'] as num).toDouble(),
        imagePlaceholder: json['imagePlaceholder'] as String?,
      );
}

extension MirrorDimensionsX on MirrorUiModel {
  double get aspectRatio {
    try {
      final parts = dimensions.split(RegExp(r'[^0-9]+')).where((s) => s.isNotEmpty).toList();
      if (parts.length >= 2) {
        final w = double.parse(parts[0]);
        final h = double.parse(parts[1]);
        if (h > 0) return w / h;
      }
    } catch (_) {}
    return 0.75;
  }
}

const String kFramedMirrorAsset = 'assets/images/framed_mirror.png';

const List<MirrorUiModel> kDummyMirrors = [
  MirrorUiModel(
    id: 'f_special_1',
    dimensions: '40 × 60',
    category: MirrorCategory.framed,
    subCategory: RetailSubCategory.specialSize,
    retailPrice: 260,
    wholesalePrice: 0,
    imagePlaceholder: kFramedMirrorAsset,
  ),
  MirrorUiModel(
    id: 'f_special_2',
    dimensions: '50 × 50',
    category: MirrorCategory.framed,
    subCategory: RetailSubCategory.specialSize,
    retailPrice: 280,
    wholesalePrice: 0,
    imagePlaceholder: kFramedMirrorAsset,
  ),
  MirrorUiModel(
    id: 'f_shelf_1',
    dimensions: '40 × 60',
    category: MirrorCategory.framed,
    subCategory: RetailSubCategory.withShelf,
    retailPrice: 340,
    wholesalePrice: 0,
  ),

  MirrorUiModel(
    id: 'f1',
    dimensions: '30 × 35',
    category: MirrorCategory.framed,
    subCategory: RetailSubCategory.standard,
    retailPrice: 150,
    wholesalePrice: 115,
    imagePlaceholder: kFramedMirrorAsset,
  ),
  MirrorUiModel(
    id: 'f2',
    dimensions: '28 × 30',
    category: MirrorCategory.framed,
    subCategory: RetailSubCategory.standard,
    retailPrice: 120,
    wholesalePrice: 90,
    imagePlaceholder: kFramedMirrorAsset,
  ),
  MirrorUiModel(
    id: 'f3',
    dimensions: '25 × 25',
    category: MirrorCategory.framed,
    subCategory: RetailSubCategory.standard,
    retailPrice: 95,
    wholesalePrice: 70,
    imagePlaceholder: kFramedMirrorAsset,
  ),
  MirrorUiModel(
    id: 'f4',
    dimensions: '23 × 19',
    category: MirrorCategory.framed,
    subCategory: RetailSubCategory.standard,
    retailPrice: 70,
    wholesalePrice: 50,
    imagePlaceholder: kFramedMirrorAsset,
  ),
  MirrorUiModel(
    id: 'f5',
    dimensions: '16 × 16',
    category: MirrorCategory.framed,
    subCategory: RetailSubCategory.standard,
    retailPrice: 35,
    wholesalePrice: 25,
    imagePlaceholder: kFramedMirrorAsset,
  ),
  MirrorUiModel(
    id: 'f6',
    dimensions: '13 × 13',
    category: MirrorCategory.framed,
    subCategory: RetailSubCategory.standard,
    retailPrice: 30,
    wholesalePrice: 20,
    imagePlaceholder: kFramedMirrorAsset,
  ),

  MirrorUiModel(
    id: 'a1',
    dimensions: '29 × 34',
    category: MirrorCategory.adhesive,
    subCategory: RetailSubCategory.standard,
    retailPrice: 120,
    wholesalePrice: 90,
  ),
  MirrorUiModel(
    id: 'a2',
    dimensions: '27 × 29',
    category: MirrorCategory.adhesive,
    subCategory: RetailSubCategory.standard,
    retailPrice: 95,
    wholesalePrice: 70,
  ),
  MirrorUiModel(
    id: 'a3',
    dimensions: '24 × 24',
    category: MirrorCategory.adhesive,
    subCategory: RetailSubCategory.standard,
    retailPrice: 75,
    wholesalePrice: 55,
  ),
  MirrorUiModel(
    id: 'a4',
    dimensions: '18 × 22',
    category: MirrorCategory.adhesive,
    subCategory: RetailSubCategory.standard,
    retailPrice: 50,
    wholesalePrice: 35,
  ),
  MirrorUiModel(
    id: 'a5',
    dimensions: '15 × 15',
    category: MirrorCategory.adhesive,
    subCategory: RetailSubCategory.standard,
    retailPrice: 25,
    wholesalePrice: 15,
  ),
  MirrorUiModel(
    id: 'a6',
    dimensions: '12 × 12',
    category: MirrorCategory.adhesive,
    subCategory: RetailSubCategory.standard,
    retailPrice: 18,
    wholesalePrice: 11,
  ),
];

enum WholesaleTier {
  quarterDozen(3),
  halfDozen(6),
  oneDozen(12),
  oneAndHalfDozen(18),
  twoDozens(24);

  final int quantity;
  const WholesaleTier(this.quantity);
}