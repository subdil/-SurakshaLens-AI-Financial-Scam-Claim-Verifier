import 'package:flutter_test/flutter_test.dart';

import 'package:surakshalens/main.dart';

void main() {
  testWidgets('App renders', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const SurakshaLensApp());

    // Verify the app shows the title and main buttons.
    expect(find.text('SurakshaLens'), findsOneWidget);
    expect(find.text('History'), findsOneWidget);
  });
}
