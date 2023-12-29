// Importing necessary packages from the Flutter and Hive libraries
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:money_management_app/models/categories/category_model.dart';

// Constant representing the name of the Hive database for categories
const CATEGORY_DB_NAME = 'category-database';

// Abstract class defining functions for category database operations
abstract class CategoryDbFunctions {
  Future<List<CategoryModel>> getCategories();
  Future<void> insertCategory(CategoryModel value);
  Future<void> deleteCategory(String categoryID);
}

// Class implementing category database functions
class CategoryDB implements CategoryDbFunctions {
  CategoryDB._internal();

  static CategoryDB instance = CategoryDB._internal();

  factory CategoryDB() {
    return instance;
  }

  // ValueNotifiers to listen for changes in income and expense categories
  ValueNotifier<List<CategoryModel>> incomeCategoryListListener =
      ValueNotifier([]);
  ValueNotifier<List<CategoryModel>> expenseCategoryListListener =
      ValueNotifier([]);

  // Function to insert a category into the database
  @override
  Future<void> insertCategory(CategoryModel value) async {
    // Open the Hive box for CategoryModel
    final _categoryDB = await Hive.openBox<CategoryModel>(CATEGORY_DB_NAME);
    // Add the new category to the box
    await _categoryDB.put(value.id, value);
    // Close the box after adding the value
    await _categoryDB.close();
    // Refresh UI to reflect the changes
    refreshUI();
  }

  // Function to retrieve all categories from the database
  @override
  Future<List<CategoryModel>> getCategories() async {
    // Open the Hive box for CategoryModel
    final _categoryDB = await Hive.openBox<CategoryModel>(CATEGORY_DB_NAME);
    // Retrieve all categories from the box and convert to a list
    final categories = _categoryDB.values.toList();
    // Close the box after retrieving values
    await _categoryDB.close();
    // Return the list of categories
    return categories;
  }

  // Function to refresh the UI with updated category lists
  Future<void> refreshUI() async {
    // Retrieve all categories from the database
    final _allCategories = await getCategories();
    // Clear the existing lists for income and expense categories
    incomeCategoryListListener.value = [];
    expenseCategoryListListener.value = [];
    // Iterate through all categories and add them to the respective lists
    _allCategories.forEach((CategoryModel category) {
      if (category.type == CategoryType.income) {
        incomeCategoryListListener.value.add(category);
      } else {
        expenseCategoryListListener.value.add(category);
      }
    });

    // Notify listeners to update the UI
    incomeCategoryListListener.notifyListeners();
    expenseCategoryListListener.notifyListeners();
  }

  @override
  Future<void> deleteCategory(String categoryID) async {
    final _categoryDB = await Hive.openBox<CategoryModel>(CATEGORY_DB_NAME);
    await _categoryDB.delete(categoryID);
    await _categoryDB.close();
    // Refresh UI to reflect the changes
    refreshUI();
  }
}
