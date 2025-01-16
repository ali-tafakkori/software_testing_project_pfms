import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:software_testing_project_pfms/main.dart' as app;
import 'package:software_testing_project_pfms/widgets/app_progress_button.dart';

void main() {
  var testUsername = DateTime.now().toIso8601String();
  print("testUsername: $testUsername");
  group(
    "end to end test",
    () {
      IntegrationTestWidgetsFlutterBinding.ensureInitialized();
      testWidgets(
        "Register",
        (tester) async {
          app.main();
          await tester.pumpAndSettle(const Duration(seconds: 1));
          await tester.tap(find.byKey(const Key("register")));
          await tester.pumpAndSettle();
          await tester.enterText(
              find.byKey(const Key("name")), "Ali Tafakkori");
          await tester.enterText(
              find.byKey(const Key("username")), testUsername);
          await tester.enterText(find.byKey(const Key("password")), "12345");
          await tester.enterText(
              find.byKey(const Key("repeat password")), "12345");

          await tester.pumpAndSettle();
          await tester.tap(find.byKey(const Key("register")));
          await tester.pumpAndSettle(const Duration(seconds: 1));

          expect(find.text("Now you can log in."), findsOneWidget);
          await tester.pumpAndSettle();
        },
      );
      testWidgets(
        "Login",
        (tester) async {
          app.main();
          await tester.pumpAndSettle(const Duration(seconds: 2));
          await tester.enterText(
              find.byKey(const Key("username")), testUsername);
          await tester.enterText(find.byKey(const Key("password")), "12345");

          await tester.pumpAndSettle();
          await tester.tap(find.byKey(const Key("login")));
          await tester.pumpAndSettle(const Duration(seconds: 1));

          expect(find.text("No Purchase"), findsOneWidget);
          await tester.pumpAndSettle();
        },
      );
}
