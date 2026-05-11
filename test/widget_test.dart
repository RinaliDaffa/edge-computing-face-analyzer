import 'package:flutter_test/flutter_test.dart';
import 'package:edge_ai_app/main.dart';

void main() {
  testWidgets('Edge AI Face Analyzer smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const EdgeAIFaceApp());
    expect(find.text('Edge AI Face Analyzer'), findsOneWidget);
  });
}