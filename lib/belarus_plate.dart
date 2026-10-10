/// Belarus's licence plates for the `plate_core` library: the 2004 series —
/// private, truck, trailer, electric, taxi, diplomatic and service plates, in
/// one- and two-line forms.
///
/// Diplomatic code `09` is refused everywhere this package is used: by the
/// spec's `PlateRestriction`, by the validator, by `BelarusMissions`, and —
/// through `plate_core` — by the controller, the input machine and the canvas.
/// Every one of them reports `BelarusMissions.notFound`.
library;

export 'src/belarus_alphabets.dart';
export 'src/belarus_colors.dart';
export 'src/belarus_country.dart';
export 'src/belarus_missions.dart';
export 'src/belarus_plates.dart';
export 'src/belarus_themes.dart';
export 'src/belarus_validators.dart';
