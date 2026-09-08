import 'package:flutter_test/flutter_test.dart';
import 'package:atmosphere/main.dart';

void main() {
  testWidgets('WeatherApp smoke test loads UI', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const WeatherApp());

    // Verify initial structure mounts without crashing
    expect(find.byType(WeatherApp), findsOneWidget);
  });
}
