// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:software_testing_project_pfms/main.dart' as app;
import 'package:software_testing_project_pfms/widgets/app_button.dart';
import 'package:software_testing_project_pfms/widgets/app_progress_button.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  binding.framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.fullyLive;
  group(
    "end to end test",
    () {
      testWidgets(
        "register",
        (tester) async {
          app.main();
          await tester.pumpAndSettle();
          await tester.tap(find.byKey(const Key("register")));
          await tester.pumpAndSettle();
          await tester.enterText(find.byKey(const Key("username")), "ali");
          await tester.enterText(
              find.byKey(const Key("name")), "Ali Tafakkori");
          await tester.enterText(find.byKey(const Key("password")), "12345");
          await tester.enterText(
              find.byKey(const Key("repeat password")), "12345");
          await tester.tap(find.byType(AppProgressButton));
          await tester.pumpAndSettle();

          expect(find.text("The information entered is incorrect."),
              findsOneWidget);
        },
      );
      testWidgets(
        "login",
        (tester) async {
          app.main();
          await tester.pumpAndSettle();
          await tester.enterText(find.byKey(const Key("username")), "ali2");
          await tester.enterText(find.byKey(const Key("password")), "12345");
          await tester.tap(find.byType(AppProgressButton));
          await tester.pumpAndSettle();

          expect(find.text("The information entered is incorrect."),
              findsOneWidget);
        },
      );
    },
  );
}
