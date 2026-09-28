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

class MirrorUiModel {
  final String id;
  final String dimensions;
  final MirrorCategory category;
  final double retailPrice;
  final double wholesalePrice;
  final String? imagePlaceholder;

  const MirrorUiModel({
    required this.id,
    required this.dimensions,
    required this.category,
    required this.retailPrice,
    required this.wholesalePrice,
    this.imagePlaceholder,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'dimensions': dimensions,
        'category': category.toJson(),
        'retailPrice': retailPrice,
        'wholesalePrice': wholesalePrice,
        if (imagePlaceholder != null) 'imagePlaceholder': imagePlaceholder,
      };

  factory MirrorUiModel.fromJson(Map<String, dynamic> json) => MirrorUiModel(
        id: json['id'] as String,
        dimensions: json['dimensions'] as String,
        category: MirrorCategory.fromJson(json['category'] as String),
        retailPrice: (json['retailPrice'] as num).toDouble(),
        wholesalePrice: (json['wholesalePrice'] as num).toDouble(),
        imagePlaceholder: json['imagePlaceholder'] as String?,
      );
}

// All 12 product variants based on specifications
const List<MirrorUiModel> kDummyMirrors = [
  // Framed Mirrors (6 variants)
  MirrorUiModel(
    id: 'f1',
    dimensions: '30 × 35',
    category: MirrorCategory.framed,
    retailPrice: 150,
    wholesalePrice: 115,
  ),
  MirrorUiModel(
    id: 'f2',
    dimensions: '28 × 30',
    category: MirrorCategory.framed,
    retailPrice: 120,
    wholesalePrice: 90,
  ),
  MirrorUiModel(
    id: 'f3',
    dimensions: '25 × 25',
    category: MirrorCategory.framed,
    retailPrice: 95,
    wholesalePrice: 70,
  ),
  MirrorUiModel(
    id: 'f4',
    dimensions: '23 × 19',
    category: MirrorCategory.framed,
    retailPrice: 70,
    wholesalePrice: 50,
  ),
  MirrorUiModel(
    id: 'f5',
    dimensions: '16 × 16',
    category: MirrorCategory.framed,
    retailPrice: 35,
    wholesalePrice: 25,
  ),
  MirrorUiModel(
    id: 'f6',
    dimensions: '13 × 13',
    category: MirrorCategory.framed,
    retailPrice: 30,
    wholesalePrice: 20,
  ),

  // Double Adhesive Mirrors (6 variants)
  MirrorUiModel(
    id: 'a1',
    dimensions: '29 × 34',
    category: MirrorCategory.adhesive,
    retailPrice: 120,
    wholesalePrice: 90,
  ),
  MirrorUiModel(
    id: 'a2',
    dimensions: '27 × 29',
    category: MirrorCategory.adhesive,
    retailPrice: 95,
    wholesalePrice: 70,
  ),
  MirrorUiModel(
    id: 'a3',
    dimensions: '24 × 24',
    category: MirrorCategory.adhesive,
    retailPrice: 75,
    wholesalePrice: 55,
  ),
  MirrorUiModel(
    id: 'a4',
    dimensions: '18 × 22',
    category: MirrorCategory.adhesive,
    retailPrice: 50,
    wholesalePrice: 35,
  ),
  MirrorUiModel(
    id: 'a5',
    dimensions: '15 × 15',
    category: MirrorCategory.adhesive,
    retailPrice: 25,
    wholesalePrice: 15,
  ),
  MirrorUiModel(
    id: 'a6',
    dimensions: '12 × 12',
    category: MirrorCategory.adhesive,
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