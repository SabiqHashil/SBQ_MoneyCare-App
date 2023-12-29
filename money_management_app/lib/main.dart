// Importing necessary packages from the Flutter and Hive libraries
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:money_management_app/models/categories/category_model.dart';
import 'package:money_management_app/screens/home/screen_home.dart';

// Async function that serves as the entry point for the application
Future<void> main() async {
  // Ensure that Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Get the application documents directory
  final appDocumentDir = await path_provider.getApplicationDocumentsDirectory();

  // Set the Hive database path to the application documents directory
  Hive.init(appDocumentDir.path);

  // Registering the Hive adapter for CategoryType if not already registered
  if (!Hive.isAdapterRegistered(CategoryTypeAdapter().typeId)) {
    Hive.registerAdapter(CategoryTypeAdapter());
  }

  // Registering the Hive adapter for CategoryModel if not already registered
  if (!Hive.isAdapterRegistered(CategoryModelAdapter().typeId)) {
    Hive.registerAdapter(CategoryModelAdapter());
  }

  // Run the application by calling the MyApp widget
  runApp(const MyApp());
}

// Stateless widget representing the root of the application
class MyApp extends StatelessWidget {
  // Constructor for the widget with an optional key parameter
  const MyApp({Key? key}) : super(key: key);

  // Build method that constructs the UI for the widget
  @override
  Widget build(BuildContext context) {
    // MaterialApp widget representing the overall structure of the application
    return MaterialApp(
      // Title of the application
      title: 'Flutter Demo',
      // Theme configuration for the application
      theme: ThemeData(
        // Defining the color scheme using deep purple as a seed color
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        // Enabling Material 3 design
        useMaterial3: true,
      ),
      // Setting the home screen to be ScreenHome widget
      home: const ScreenHome(),
    );
  }
}
