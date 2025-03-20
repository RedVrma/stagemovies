import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stagemovies/core/injection/service_locator.dart';
import 'package:stagemovies/main.dart';
import 'package:stagemovies/presentation/screens/view/homepage_feature.dart';

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
}
