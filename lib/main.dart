import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:stagemovies/core/injection/service_locator.dart';
import 'package:stagemovies/presentation/screens/view/homepage_feature.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initDependencyInjection();//uses getit to inject the dependencies
  await dotenv.load(fileName: ".env");

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movie App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomepageFeature(), // Use the MoviesFeature widget
    );
  }
}
