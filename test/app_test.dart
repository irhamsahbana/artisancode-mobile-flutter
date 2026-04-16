import 'package:artisan_hr/app/app.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows login screen on app start', (tester) async {
    await tester.pumpWidget(const ArtisanHrApp());

    expect(find.text('Absensi Karyawan'), findsOneWidget);
    expect(find.text('Masuk'), findsOneWidget);
    expect(find.text('Base URL API'), findsOneWidget);
  });
}
