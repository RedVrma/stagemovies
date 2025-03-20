import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:stagemovies/core/injection/service_locator.dart';
import 'package:stagemovies/main.dart';
import 'package:stagemovies/presentation/screens/view/homepage_feature.dart';
import 'package:stagemovies/presentation/screens/view/movie_detail_page.dart';


// Mocking SharedPreferences
class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  setUpAll(() async {
    IntegrationTestWidgetsFlutterBinding.ensureInitialized();

    // Mock SharedPreferences before initializing dependencies
    SharedPreferences.setMockInitialValues({}); // Empty mock values

    await dotenv.load(fileName: ".env");
    await initDependencyInjection(); // Inject dependencies after mocking
  });

  testWidgets('App should load and display HomepageFeature', (WidgetTester tester) async {
    // Start the full app
    await tester.pumpWidget(MyApp());

    // Wait for UI to settle
    await tester.pumpAndSettle();

    // Verify the homepage is displayed
    expect(find.byType(HomepageFeature), findsOneWidget);

    // Example: Verify if the movie list or a specific text appears
    expect(find.text('Movies'), findsWidgets); // Modify based on actual UI
  });
  group('App Initialization Tests', () {
    testWidgets('App should start and show loading state', (WidgetTester tester) async {
      // Start the app
      await tester.pumpWidget(MyApp());

      // Verify that the app starts
      expect(find.byType(MaterialApp), findsOneWidget);

      // Verify loading indicator is shown initially
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Wait for the app to settle and load data
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Verify loading indicator is gone
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('App should display movie grid after loading', (WidgetTester tester) async {
      await tester.pumpWidget(MyApp());
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Verify that the movie grid appears
      expect(find.byType(GridView), findsOneWidget);
      expect(find.byType(Card), findsWidgets);

    });
  });

  group('Movie Grid Interaction Tests', () {

    testWidgets('Should be able to tap on a movie to view details', (WidgetTester tester) async {
      await tester.pumpWidget(MyApp());
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Find and tap the first movie card
      final firstMovieCard = find.byType(Card).first;
      await tester.tap(firstMovieCard);
      await tester.pumpAndSettle();

      // Verify navigation to movie details
      expect(find.byType(MovieDetailPage), findsWidgets);

    });
  });

  group('Search Functionality Tests', () {
    testWidgets('Should be able to search for movies', (WidgetTester tester) async {
      await tester.pumpWidget(MyApp());
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Find the search field
      expect(find.byType(TextField), findsOneWidget);
      expect(find.text('Search movies...'), findsOneWidget);

      // Enter search text
      await tester.enterText(find.byType(TextField), 'interstellar');
      await tester.pumpAndSettle();

      // Verify search results
      expect(find.byType(GridView), findsOneWidget);
      expect(find.text('interstellar'), findsOneWidget);
    });
  });

  group('Favorite Functionality Tests', () {
    testWidgets('Should be able to toggle favorite status', (WidgetTester tester) async {
      await tester.pumpWidget(MyApp());
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Find the favorite button on the first movie
      final favoriteButton = find.byIcon(Icons.favorite_border).first;
      await tester.tap(favoriteButton);
      await tester.pumpAndSettle();

      // Verify the icon changed to filled heart
      expect(find.byIcon(Icons.favorite), findsOneWidget);
    });
  });

  group('UI Component Tests', () {
    testWidgets('App bar should be present with correct title', (WidgetTester tester) async {
      await tester.pumpWidget(MyApp());
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Verify app bar
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.text('Movies'), findsOneWidget);
    });

    testWidgets('Search bar should be present in app bar', (WidgetTester tester) async {
      await tester.pumpWidget(MyApp());
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Verify search bar
      expect(find.byType(TextField), findsOneWidget);
      expect(find.text('Search movies...'), findsOneWidget);
    });
  });

  group('Navigation Tests', () {
    testWidgets('Should navigate back from movie details', (WidgetTester tester) async {
      await tester.pumpWidget(MyApp());
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Navigate to movie details
      final firstMovieCard = find.byType(Card).first;
      await tester.tap(firstMovieCard);
      await tester.pumpAndSettle();

      // Verify we're on movie details page
      expect(find.byType(MovieDetailPage), findsOneWidget);

      // Navigate back
      await tester.pageBack();
      await tester.pumpAndSettle();

      // Verify we're back on the movie grid
      expect(find.byType(GridView), findsOneWidget);
    });
  });
}
