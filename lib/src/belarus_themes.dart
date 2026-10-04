import 'package:flutter/widgets.dart';
import 'package:plate_core/plate_core.dart';

import 'belarus_colors.dart';

/// One ink on one field, with the frame in the ink — except [mvd], whose red
/// field has a black frame around white ink.
abstract final class BelarusThemes {
  /// Measured off the 520×110 artwork: frame ~3% of the height, corners ~6%.
  static const double _border = 0.03;
  static const double _radius = 0.06;

  static PlateTheme _mono(
    Color field,
    Color ink,
    Color inactive, {
    Color alert = const Color(0xFFF87171),
  }) => PlateTheme.monochrome(
    field: field,
    ink: ink,
    inactive: inactive,
    borderWidthRatio: _border,
    plateRadiusRatio: _radius,
    alertColor: alert,
  );

  static final PlateTheme standard = _mono(
    BelarusColors.white,
    BelarusColors.black,
    BelarusColors.inactiveOnLight,
  );

  static final PlateTheme electric = _mono(
    BelarusColors.white,
    BelarusColors.electricInk,
    BelarusColors.inactiveOnLight,
  );

  static final PlateTheme taxi = _mono(
    BelarusColors.taxiYellow,
    BelarusColors.black,
    BelarusColors.inactiveOnLight,
  );

  /// The "COUNTRY NOT FOUND" banner is drawn in [PlateTheme.alertColor]; on a
  /// red field the default red would not show, so it is near-black here.
  static final PlateTheme diplomatic = _mono(
    BelarusColors.red,
    BelarusColors.white,
    BelarusColors.inactiveOnDark,
    alert: BelarusColors.alertOnRed,
  );

  /// MO — armed forces.
  static final PlateTheme mo = _mono(
    BelarusColors.black,
    BelarusColors.white,
    BelarusColors.inactiveOnDark,
  );

  /// PV — border guard.
  static final PlateTheme pv = _mono(
    BelarusColors.serviceGreen,
    BelarusColors.white,
    BelarusColors.inactiveOnDark,
  );

  /// MVD — interior ministry: white on red inside a black frame.
  static const PlateTheme mvd = PlateTheme(
    plateBackground: BelarusColors.red,
    plateBorder: BelarusColors.black,
    ink: BelarusColors.white,
    dividerColor: BelarusColors.white,
    borderWidthRatio: _border,
    plateRadiusRatio: _radius,
    activeColor: BelarusColors.white,
    inactiveColor: BelarusColors.inactiveOnDark,
    alertColor: BelarusColors.alertOnRed,
  );
}
