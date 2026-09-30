import '../core/constants/app_assets.dart';

class CategoryModel {
  final String id;
  final String title;
  final String imageUrl;

  const CategoryModel({
    required this.id,
    required this.title,
    required this.imageUrl,
  });

  static List<CategoryModel> get sampleCategories => [
    const CategoryModel(
      id: 'beauty',
      title: 'Beauty',
      imageUrl: AppAssets.catBeauty,
    ),
    const CategoryModel(
      id: 'fashion',
      title: 'Fashion',
      imageUrl: AppAssets.catFashion,
    ),
    const CategoryModel(
      id: 'kids',
      title: 'Kids',
      imageUrl: AppAssets.catKids,
    ),
    const CategoryModel(
      id: 'mens',
      title: 'Mens',
      imageUrl: AppAssets.catMens,
    ),
    const CategoryModel(
      id: 'womens',
      title: 'Womens',
      imageUrl: AppAssets.catWomens,
    ),
  ];
}
