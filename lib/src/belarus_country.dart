import 'package:plate_core/plate_core.dart';

import 'belarus_colors.dart';

/// The flag over `BY`, printed straight on the white field: the panel is the
/// field colour, so no block shows.
abstract final class BelarusCountry {
  static const PlateCountry belarus = PlateCountry(
    code: 'by',
    captionLines: <String>['BY'],
    panelColor: BelarusColors.white,
    panelTextColor: BelarusColors.black,
    flagAspectRatio: 2,
    flag: SvgPlateAsset(
      'assets/flags/Flag_of_Belarus.svg',
      package: 'belarus_plate',
    ),
  );
}
