import 'package:flutter/widgets.dart';

/// Every colour sampled from the reference artwork in the Wikipedia article,
/// except [electricInk], which only a photograph shows.
abstract final class BelarusColors {
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);

  /// The flag's red stripe as printed on the plate.
  static const Color flagRed = Color(0xFFED1C24);

  /// The electric-vehicle ink, sampled from the photograph of a real plate.
  static const Color electricInk = Color(0xFF38C49C);

  /// The taxi field.
  static const Color taxiYellow = Color(0xFFFFCC00);

  /// The diplomatic field, and the MVD service field.
  static const Color red = Color(0xFFFF0000);

  /// The PV (border guard) service field.
  static const Color serviceGreen = Color(0xFF006633);

  /// Shown on a red field, where the default alert colour would vanish.
  static const Color alertOnRed = Color(0xFF1A1A1A);

  static const Color inactiveOnLight = Color(0xFFB0B0B0);
  static const Color inactiveOnDark = Color(0x80FFFFFF);
}
