import 'package:flutter_test/flutter_test.dart';
import 'package:appproject/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const KinRaiDeeApp());
    expect(find.textContaining('เครื่องสแกนวัตถุดิบ'), findsOneWidget);
  });
}
