import 'package:money_management_app/models/categories/category_model.dart';

abstract class CategoryDbFunctions {
  // List<CategoryModel> getCategories();
  Future<void> insertCategory(CategoryModel value);
}

class CategoryDB implements CategoryDbFunctions {
  @override
  Future<void> insertCategory(CategoryModel value) async {
    
  }
}
