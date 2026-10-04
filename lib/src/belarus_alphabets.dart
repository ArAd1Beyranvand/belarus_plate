import 'package:plate_alphabet/plate_alphabet.dart';
import 'package:plate_core/plate_core.dart';

/// The Belarusian alphabets, defined in `plate_alphabet`.
abstract final class BelarusAlphabets {
  static const PlateAlphabet letters = PlateAlphabetBelarus.letters;
  static const PlateAlphabet region = PlateAlphabetBelarus.region;
  static const PlateAlphabet electric = PlateAlphabetBelarus.electric;
  static const PlateAlphabet diplomaticFirst =
      PlateAlphabetBelarus.diplomaticFirst;
  static const PlateAlphabet diplomaticSecond =
      PlateAlphabetBelarus.diplomaticSecond;
}
