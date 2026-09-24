import 'package:flutter_test/flutter_test.dart';
import 'package:appproject/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const KinRaiDeeApp());

    // Verify that ingredient scanner title is present.
    expect(find.text('เครื่องสแกนวัตถุดิบ'), findsOneWidget);
  });
}
