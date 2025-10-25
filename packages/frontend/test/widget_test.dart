import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('App widget test', (WidgetTester tester) async {
    // Create a simple test widget
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(appBar: AppBar(title: const Text('Todo App'))),
      ),
    );

    // Verify that the app loads with the Todo App title
    expect(find.text('Todo App'), findsOneWidget);
  });
}
