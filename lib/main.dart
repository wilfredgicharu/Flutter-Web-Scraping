import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:web_scraping_flutter/screens/WebScrappingScreen.dart';
import 'package:web_scraping_flutter/screens/news_description.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  // HydratedBloc.storage = await HydratedStorage.build(
  //     storageDirectory: await getApplicationDocumentsDirectory());
  // await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  String? get pageTitle => null;
  String? get url => null;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        initialRoute: 'welcome_screen',
        routes: {
          'welcome_screen': (context) => WebScrappingScreen(),
          'news_description': (context) => NewsDescription(pageTitle, url),
        }
    );
  }
}