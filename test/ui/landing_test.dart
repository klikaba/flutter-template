import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_template/ui/landing.dart';

void main() {
  testWidgets('Landing widget has 2 buttons', (WidgetTester tester) async {
    // Build widget
    await tester.pumpWidget(MaterialApp(home: LandingWidget()));

    // Verify there are login and register buttons
    expect(find.byType(ElevatedButton), findsNWidgets(2));
    expect(find.text('Login'), findsOneWidget);
    expect(find.text('Register'), findsOneWidget);
  });
}
