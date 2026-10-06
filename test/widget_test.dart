import 'package:climapp_cc20262/src/widgets/no_connection_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('NoConnectionWidget mostra mensagem e chama onRetry', (
    WidgetTester tester,
  ) async {
    var retried = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: NoConnectionWidget(onRetry: () => retried = true),
        ),
      ),
    );

    expect(find.text('Sem conexão'), findsOneWidget);

    await tester.tap(find.text('Tentar novamente'));
    await tester.pump();

    expect(retried, isTrue);
  });
}
