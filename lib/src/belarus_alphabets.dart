import 'package:plate_core/plate_core.dart';

/// The Belarusian series letters: the twelve Latin letters that share a shape
/// with a Cyrillic one, so a plate reads the same in either script.
abstract final class BelarusAlphabets {
  static const PlateAlphabet letters = PlateAlphabet(
    id: 'by.letters',
    characters: ['A', 'B', 'E', 'I', 'K', 'M', 'H', 'O', 'P', 'C', 'T', 'X'],
    input: AlphabetInput.typed,
    isNumeric: false,
  );

  /// The region digit after the dash: 1–7 for the regions and Minsk city,
  /// 8 for the 2020s overflow series, 0 for the Ministry of Defence.
  static const PlateAlphabet region = PlateAlphabet(
    id: 'by.region',
    characters: ['0', '1', '2', '3', '4', '5', '6', '7', '8'],
    input: AlphabetInput.typed,
    isNumeric: true,
  );

  /// The leading `E` of an electric vehicle's number.
  static const PlateAlphabet electric = PlateAlphabet(
    id: 'by.electric',
    characters: ['E'],
    input: AlphabetInput.typed,
    isNumeric: false,
  );

  /// First letter of a diplomatic plate: always `C`.
  static const PlateAlphabet diplomaticFirst = PlateAlphabet(
    id: 'by.diplomatic.first',
    characters: ['C'],
    input: AlphabetInput.typed,
    isNumeric: false,
  );

  /// Second letter: `D` for diplomatic corps, `C` for consular.
  static const PlateAlphabet diplomaticSecond = PlateAlphabet(
    id: 'by.diplomatic.second',
    characters: ['C', 'D'],
    input: AlphabetInput.typed,
    isNumeric: false,
  );
}
