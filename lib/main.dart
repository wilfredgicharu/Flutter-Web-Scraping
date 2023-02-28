import 'package:flutter/material.dart';
import 'package:web_scraping_flutter/screens/WebScrappingScreen.dart';


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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        initialRoute: 'welcome_screen',
        routes: {
          'welcome_screen': (context) => WebScrappingScreen(),
        }
    );
  }
}