import 'package:flutter_test/flutter_test.dart';
import '../lib/main.dart'; // relative import agar tidak tergantung nama package

void main() {
  testWidgets('App builds', (tester) async {
    await tester.pumpWidget(const BangAjeyMealsApp());
    expect(find.byType(BangAjeyMealsApp), findsOneWidget);
  });
}
