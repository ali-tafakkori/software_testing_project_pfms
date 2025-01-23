import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:software_testing_project_pfms/main.dart' as app;
import 'package:software_testing_project_pfms/widgets/app_progress_button.dart';

void main() {
  var testUsername = "U${DateTime.now().toIso8601String()}";
  print("testUsername: $testUsername");

  var testCustomer = "C${DateTime.now().toIso8601String()}";
  print("testCustomer: $testCustomer");

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
        "Login, New Customer & New Invoice",
        (tester) async {
          app.main();
          await tester.pumpAndSettle(const Duration(seconds: 2));
          await tester.enterText(
              find.byKey(const Key("username")), testUsername);
          await tester.enterText(find.byKey(const Key("password")), "12345");
          await tester.tap(find.byKey(const Key("login")));

          //await tester.pumpAndSettle(const Duration(seconds: 2));
          await Future.delayed(const Duration(seconds: 1));
          expect(find.text("No Purchase"), findsOneWidget);

          //await tester.pumpAndSettle(const Duration(seconds: 2));

          await tester.tap(find.byKey(const Key("customers")));
          await tester.pumpAndSettle();

          await tester.tap(find.byKey(const Key("new customer")));
          await tester.pumpAndSettle();

          await tester.enterText(
              find.byKey(const Key("name")), testCustomer);
          await tester.enterText(find.byKey(const Key("balance")), "1000");
          await tester.tap(find.byKey(const Key("save")));
          await tester.pumpAndSettle();

          expect(find.text(testCustomer), findsOneWidget);
          await Future.delayed(const Duration(seconds: 1));

          await tester.tap(find.byKey(const Key("invoices")));
          await tester.pumpAndSettle();

          await tester.tap(find.byKey(const Key("new invoice")));
          await tester.pumpAndSettle();

          await tester.tap(find.byKey(const Key("invoice customer")));
          await tester.pumpAndSettle();

          await tester.tap(find.text(testCustomer));
          await tester.pumpAndSettle();

          await tester.enterText(find.byKey(const Key("amount")), "500");
          await tester.tap(find.byKey(const Key("save")));
          await tester.pumpAndSettle();

          expect(find.text(testCustomer), findsOneWidget);
          await Future.delayed(const Duration(seconds: 1));
        },
      );
      /*testWidgets(
        "New Customer",
            (tester) async {
          app.main();
          await tester.pumpAndSettle(const Duration(seconds: 2));

          await tester.tap(find.byKey(const Key("customers")));
          await tester.pumpAndSettle();

          await tester.tap(find.byKey(const Key("new customer")));
          await tester.pumpAndSettle();

          await tester.enterText(
              find.byKey(const Key("name")), testCustomer);
          await tester.enterText(find.byKey(const Key("balance")), "1000");
          await tester.tap(find.byKey(const Key("save")));
          await tester.pumpAndSettle();

          expect(find.text(testCustomer), findsOneWidget);
          expect(find.text("1000"), findsOneWidget);
          await tester.pumpAndSettle();
        },
      );*/
    },
  );
}
