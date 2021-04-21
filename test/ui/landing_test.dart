import 'package:flutter/material.dart';
import 'package:flutter_template/data/session/api.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_template/ui/landing.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

class MockSessionRepository extends Mock implements SessionRepository {}

void main() {
  testWidgets('Landing widget has 2 buttons', (WidgetTester tester) async {
    final mockRepo = MockSessionRepository();
    when(mockRepo.hasSession()).thenAnswer((_) => Future.value(false));

    // Build widget
    await tester.pumpWidget(MultiProvider(
        providers: [Provider<SessionRepository>(create: (context) => mockRepo)],
        child: MaterialApp(home: LandingWidget())));

    // Verify there are login and register buttons
    expect(find.byType(ElevatedButton), findsNWidgets(2));
    expect(find.text('Login'), findsOneWidget);
    expect(find.text('Register'), findsOneWidget);
  });
}
