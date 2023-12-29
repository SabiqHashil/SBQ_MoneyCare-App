// Importing necessary packages from the Flutter framework
import 'package:flutter/material.dart';

// Importing custom classes for database and model
import 'package:money_management_app/db/category/category_db.dart';
import 'package:money_management_app/models/categories/category_model.dart';

// Creating a stateless widget for displaying the list of income categories
class IncomeCategoryList extends StatelessWidget {
  // Constructor for the widget, with a named parameter 'key'
  const IncomeCategoryList({super.key});

  // Build method that constructs the UI for the widget
  @override
  Widget build(BuildContext context) {
    // Using a ValueListenableBuilder to automatically rebuild the widget when the incomeCategoryListListener changes
    return ValueListenableBuilder(
      // Listening to changes in the incomeCategoryListListener from the CategoryDB
      valueListenable: CategoryDB().incomeCategoryListListener,
      // Callback function called when the value changes
      builder: (BuildContext ctx, List<CategoryModel> newList, Widget? _) {
        // Building a ListView with separated items
        return ListView.separated(
          // Callback function for building each item in the list
          itemBuilder: (ctx, index) {
            // Accessing the current category from the list
            final category = newList[index];
            // Building a Card with a ListTile for each category
            return Card(
              child: ListTile(
                // Displaying the name of the category
                title: Text(category.name),
                // Adding a delete button as a trailing icon
                trailing: IconButton(
                  onPressed: () {
                    // Callback function for the delete button, currently empty
                    CategoryDB.instance.deleteCategory(category.id);
                  },
                  icon: const Icon(Icons.delete),
                ),
              ),
            );
          },
          // Callback function for building separators between items
          separatorBuilder: (ctx, index) {
            // Adding a SizedBox with a height of 10 between items
            return const SizedBox(
              height: 10,
            );
          },
          // Setting the total number of items in the list
          itemCount: newList.length,
        );
      },
    );
  }
}
