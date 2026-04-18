import 'package:artisan_hr/app/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('shows onboarding intro on app start', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final sharedPreferences = await SharedPreferences.getInstance();
    await tester.binding.setSurfaceSize(const Size(430, 1000));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(ArtisanHrApp(sharedPreferences: sharedPreferences));

    expect(
      find.text('Check-in lebih jelas. Hari kerja lebih tertata.'),
      findsOneWidget,
    );
    expect(find.text('Absensi yang terasa jelas'), findsWidgets);
  });

  testWidgets('shows login card after finishing onboarding', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final sharedPreferences = await SharedPreferences.getInstance();
    await tester.binding.setSurfaceSize(const Size(430, 1000));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(ArtisanHrApp(sharedPreferences: sharedPreferences));

    Future<void> goNext() async {
      final nextButton = find.text('Lanjut');
      final getStartedButton = find.text('Masuk dengan akun saya');
      final target = nextButton.evaluate().isNotEmpty
          ? nextButton
          : getStartedButton;
      await tester.ensureVisible(target);
      await tester.tap(target);
      await tester.pumpAndSettle();
    }

    await goNext();
    await goNext();
    await goNext();

    expect(find.text('Masuk ke Presense'), findsOneWidget);
    expect(
      find.textContaining(
        'Kamera dan lokasi hanya diminta saat Anda check-in atau check-out',
      ),
      findsOneWidget,
    );
  });

  testWidgets('skips onboarding after first completion', (tester) async {
    SharedPreferences.setMockInitialValues({'has_seen_onboarding': true});
    final sharedPreferences = await SharedPreferences.getInstance();
    await tester.binding.setSurfaceSize(const Size(430, 1000));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(ArtisanHrApp(sharedPreferences: sharedPreferences));

    expect(find.text('Masuk ke Presense'), findsOneWidget);
    expect(
      find.text('Check-in lebih jelas. Hari kerja lebih tertata.'),
      findsNothing,
    );
  });
}
