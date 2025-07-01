import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:login_php/main.dart'; // Pastikan path ini benar

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Bangun aplikasi dan jalankan frame pertama
    await tester.pumpWidget(const MyApp());

    // Verifikasi bahwa counter dimulai dari 0
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tekan tombol '+' dan jalankan frame baru
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verifikasi bahwa counter bertambah menjadi 1
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
