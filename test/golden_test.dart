import 'dart:io';

import 'package:belarus_plate/belarus_plate.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plate_core/plate_core.dart';

/// One golden per design, rendered with a real bold face so the ink can be
/// measured against the article's artwork.
void main() {
  setUpAll(() async {
    final loader = FontLoader('Roboto');
    final file = File('/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf');
    if (file.existsSync()) {
      loader.addFont(file.readAsBytes().then((b) => ByteData.view(b.buffer)));
    }
    await loader.load();
  });

  List<String?> v(String s) =>
      s.split('').map((c) => c == '_' ? null : c).toList();

  final cases = <(String, PlateSpec, PlateTheme, String)>[
    ('car', BelarusPlates.car, BelarusThemes.standard, '1234AB7'),
    (
      'car_electric',
      BelarusPlates.electricCar,
      BelarusThemes.electric,
      'E123AB7',
    ),
    ('truck', BelarusPlates.truck, BelarusThemes.standard, 'AB12347'),
    ('trailer', BelarusPlates.trailer, BelarusThemes.standard, 'A1234B5'),
    ('taxi', BelarusPlates.taxi, BelarusThemes.taxi, '71234'),
    (
      'diplomatic',
      BelarusPlates.diplomatic,
      BelarusThemes.diplomatic,
      'CD12347',
    ),
    (
      'diplomatic_09',
      BelarusPlates.diplomatic,
      BelarusThemes.diplomatic,
      'CD09347',
    ),
    ('service_mo', BelarusPlates.service, BelarusThemes.mo, '1234MO'),
    ('service_mvd', BelarusPlates.service, BelarusThemes.mvd, '1234MK'),
    ('car_square', BelarusPlates.carSquare, BelarusThemes.standard, '1234AO7'),
    (
      'truck_square',
      BelarusPlates.truckSquare,
      BelarusThemes.standard,
      '1234AO7',
    ),
    ('motorcycle', BelarusPlates.motorcycle, BelarusThemes.standard, '1234AE7'),
    ('tractor', BelarusPlates.tractor, BelarusThemes.standard, '1234AE7'),
  ];

  for (final (name, spec, theme, values) in cases) {
    testWidgets(name, (tester) async {
      final controller = PlateController.fromValues(spec, v(values));
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: 520,
                height: 520 * spec.canvasHeight / spec.canvasWidth,
                child: PlateView(
                  controller: controller,
                  theme: theme,
                  country: BelarusCountry.belarus,
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await expectLater(
        find.byType(PlateView),
        matchesGoldenFile('goldens/$name.png'),
      );
      await tester.pumpWidget(const SizedBox.shrink());
      controller.dispose();
    });
  }
}
