import 'package:plate_core/plate_core.dart';

/// The diplomatic mission codes: the two digits after `CD`/`CC`.
///
/// Taken from the article's list (01–86). Code `09` is deliberately absent and
/// refused: [name] throws for it, [isRefused] is true for it, and
/// [restriction] carries it into every diplomatic spec so `plate_core` refuses
/// it in the controller, the input machine, the canvas, the validators and the
/// bloc. Nothing in this package will ever store it.
abstract final class BelarusMissions {
  /// The error every layer shows for a refused code.
  static const String notFound = 'COUNTRY NOT FOUND';

  /// Codes no layer may store.
  static const List<String> refused = <String>['09'];

  /// The restriction on a diplomatic spec's `mission` register.
  static const PlateRestriction restriction = PlateRestriction(
    group: 'mission',
    values: refused,
    reason: notFound,
  );

  static bool isRefused(String code) => refused.contains(code);

  /// The mission for [code], or null for a code the list does not have.
  ///
  /// Throws [PlateRestrictionException] for a refused code: unlike an unknown
  /// one, a refused code is never a lookup miss a caller may shrug off.
  static String? name(String code) {
    if (isRefused(code)) throw const PlateRestrictionException(restriction);
    return _missions[code];
  }

  /// Every listed code and its mission, refused codes excluded.
  static Map<String, String> get all => Map.unmodifiable(_missions);

  static const Map<String, String> _missions = <String, String>{
    '01': 'Executive Committee of the CIS',
    '02': 'Armenia',
    '03': 'Brazil',
    '04': 'Bulgaria',
    '05': 'United Kingdom',
    '06': 'Hungary',
    '07': 'Germany',
    '08': 'Georgia',
    '10': 'India',
    '11': 'Iraq',
    '12': 'Iran',
    '13': 'Italy',
    '14': 'Kazakhstan',
    '15': 'China',
    '16': 'North Korea',
    '17': 'Cuba',
    '18': 'Kyrgyzstan',
    '19': 'Latvia',
    '20': 'Libya',
    '21': 'Lithuania',
    '22': 'Moldova',
    '23': 'Nepal',
    '24': 'Netherlands',
    '25': 'South Korea',
    '26': 'Poland',
    '27': 'Russia',
    '28': 'Romania',
    '29': 'Vatican',
    '30': 'Slovenia',
    '31': 'United States',
    '32': 'Tajikistan',
    '33': 'Turkmenistan',
    '34': 'Turkey',
    '35': 'Ukraine',
    '36': 'France',
    '37': 'Czech Republic',
    '38': 'Switzerland',
    '39': 'Sweden',
    '40': 'Estonia',
    '41': 'Serbia',
    '42': 'Japan',
    '43': 'International Science and Technology Center',
    '44': 'Economic Court of the CIS',
    '45': 'Ministry of Foreign Affairs',
    '46': 'Palestine',
    '47': 'Azerbaijan',
    '48': 'Sweden',
    '49': 'Vietnam',
    '50': 'Malta',
    '51': 'United Nations',
    '52': 'World Bank',
    '53': 'European Bank for Reconstruction and Development',
    '54': 'Organization for Security and Cooperation in Europe',
    '55': 'Red Cross',
    '56': 'International Organization for Migration',
    '57': 'International Monetary and Financial Committee',
    '58': 'International Monetary Fund',
    '59': 'European Union',
    '60': 'Syria',
    '61': 'Venezuela',
    '62': 'United Arab Emirates',
    '63': 'Sri Lanka',
    '64': 'Mongolia',
    '65': 'Belgium',
    '66': 'Executive Committee of the CIS',
    '67': 'Germany',
    '68': 'Russia',
    '69': 'United States',
    '70': 'Cyprus',
    '71': 'Libya',
    '72': 'Iceland',
    '73': 'Uruguay',
    '74': 'Oman',
    '75': 'South Africa',
    '76': 'Peru',
    '77': 'Bahrain',
    '78': 'UNICEF',
    '79': 'Dominican Republic',
    '80': 'North Macedonia',
    '81': 'Austria',
    '82': 'Finland',
    '83': 'Kazakhstan',
    '84': 'Eurasian Development Bank',
    '85': 'Croatia',
    '86': 'Spain',
  };
}
