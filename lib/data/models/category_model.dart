class CategoryModel {
  final String id;
  final String name;
  final String status;

  CategoryModel({
    required this.id,
    required this.name,
    required this.status,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'].toString(),
      name: json['category_name'] ?? '',
      status: json['status'].toString(),
    );
  }
}
