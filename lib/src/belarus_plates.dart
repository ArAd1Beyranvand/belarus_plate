import 'package:flutter/widgets.dart';
import 'package:plate_core/plate_core.dart';

import 'belarus_alphabets.dart';
import 'belarus_country.dart';
import 'belarus_missions.dart';

/// Where the ink sits, in plate coordinates. Measured off the article's
/// artwork (`BY-auto-number-*.png`, the diplomatic and service PNGs) by
/// normalising each plate to its canvas.
///
/// Only 520×110 is documented. The two-line canvases (280×200, 280×156) are
/// the artwork's aspect ratios at a 280 width — estimates, not regulation.
///
/// Reference caps are ~77.6 of the 110 height. `glyphStyle` paints ink at
/// ~0.55 of the box, so matching would need a ~141 box; the boxes below fill
/// the plate (106) and the ink comes out at ~75% of the reference. The same
/// trade applies to every row on the two-line plates.
abstract final class _Layout {
  static const double width = 520;
  static const double height = 110;
  static const double rowTop = 2;
  static const double rowHeight = 106;

  /// Digit pitch ~50.25 on every one-line private series.
  static const double digitRun = 201;

  /// Letter cells: 70 wide, on a 70 pitch.
  static const double letter = 70;

  /// Dash ink y 48.5..58.2, centre x 438.5.
  static const double dashCentre = 438.5;

  /// Region digit centre.
  static const double regionCentre = 482.8;
  static const double regionWidth = 44;

  /// Flag x 17.3..71.1, y 16.2..40.4; `BY` ink y 63..92. Narrowed to 42: the
  /// reference's condensed digits clear a 54-wide block, DejaVu's do not.
  static const PlatePanel panel = PlatePanel(
    box: PlateBox(15, 16, 42, 78),
    padding: EdgeInsets.zero,
    captionScale: 1.7,
  );

  static const PlatePanel none = PlatePanel(
    box: PlateBox(0, 0, 0, 0),
    padding: EdgeInsets.zero,
  );
}

/// The 2004-series designs. Colour lives on `BelarusThemes`; electric is
/// [car]/[truck] with an `E` cell, printed in `BelarusThemes.electric`.
abstract final class BelarusPlates {
  static List<PlateSlot> _digits(double left, {int count = 4}) =>
      plateRegisterAcross(
        alphabet: PlateAlphabet.latinDigits,
        count: count,
        left: left,
        right: left + _Layout.digitRun / 4 * count,
        top: _Layout.rowTop,
        height: _Layout.rowHeight,
      );

  static PlateSlot _cell(
    PlateAlphabet a,
    double centre,
    double w, {
    double top = _Layout.rowTop,
    double h = _Layout.rowHeight,
  }) => PlateSlot(alphabet: a, box: PlateBox(centre - w / 2, top, w, h));

  static PlateLabel _dash(double centre, double top, double h) => PlateLabel(
    text: '-',
    // The hyphen sits above mid-height in the face; the reference's is
    // centred, so the box drops by 8% of the row.
    box: PlateBox(centre - 15, top + h * 0.08, 30, h),
    glyphHeight: h,
  );

  static PlateSlot _region([double centre = _Layout.regionCentre]) =>
      _cell(BelarusAlphabets.region, centre, _Layout.regionWidth);

  static PlateLabel get _oneLineDash =>
      _dash(_Layout.dashCentre, _Layout.rowTop, _Layout.rowHeight);

  /// Private car, `1234 AB-7`; [electric] makes it `E123 AB-7`.
  static PlateSpec _car({required String id, bool electric = false}) {
    final digits = _digits(59);
    return PlateSpec(
      id: id,
      country: BelarusCountry.belarus,
      canvasWidth: _Layout.width,
      canvasHeight: _Layout.height,
      panel: _Layout.panel,
      slots: [
        if (electric)
          PlateSlot(alphabet: BelarusAlphabets.electric, box: digits.first.box)
        else
          digits.first,
        ...digits.skip(1),
        _cell(BelarusAlphabets.letters, 321.5, _Layout.letter),
        _cell(BelarusAlphabets.letters, 391.5, _Layout.letter),
        _region(),
      ],
      labels: [_oneLineDash],
      textGroups: const [
        PlateTextGroup([0, 1, 2, 3], key: 'serial'),
        PlateTextGroup([4, 5], key: 'letters', prefix: ' '),
        PlateTextGroup([6], key: 'region', prefix: '-'),
      ],
    );
  }

  /// Truck/bus, `AB 1234-7`; [electric] makes it `EB 1234-7`.
  static PlateSpec _truck({required String id, bool electric = false}) =>
      PlateSpec(
        id: id,
        country: BelarusCountry.belarus,
        canvasWidth: _Layout.width,
        canvasHeight: _Layout.height,
        panel: _Layout.panel,
        slots: [
          _cell(
            electric ? BelarusAlphabets.electric : BelarusAlphabets.letters,
            112.6,
            _Layout.letter,
          ),
          _cell(BelarusAlphabets.letters, 182.6, _Layout.letter),
          ..._digits(225.4),
          _region(),
        ],
        labels: [_oneLineDash],
        textGroups: const [
          PlateTextGroup([0, 1], key: 'letters'),
          PlateTextGroup([2, 3, 4, 5], key: 'serial', prefix: ' '),
          PlateTextGroup([6], key: 'region', prefix: '-'),
        ],
      );

  static final PlateSpec car = _car(id: 'by.car');
  static final PlateSpec electricCar = _car(
    id: 'by.car.electric',
    electric: true,
  );
  static final PlateSpec truck = _truck(id: 'by.truck');
  static final PlateSpec electricTruck = _truck(
    id: 'by.truck.electric',
    electric: true,
  );

  /// Trailer, `A1234B-5`.
  static final PlateSpec trailer = PlateSpec(
    id: 'by.trailer',
    country: BelarusCountry.belarus,
    canvasWidth: _Layout.width,
    canvasHeight: _Layout.height,
    panel: _Layout.panel,
    slots: [
      _cell(BelarusAlphabets.letters, 112.6, _Layout.letter),
      ..._digits(140.4),
      _cell(BelarusAlphabets.letters, 391.75, _Layout.letter),
      _region(),
    ],
    labels: [_oneLineDash],
    textGroups: const [
      PlateTextGroup([0, 5], key: 'letters'),
      PlateTextGroup([1, 2, 3, 4], key: 'serial'),
      PlateTextGroup([6], key: 'region', prefix: '-'),
    ],
  );

  /// Taxi, `7 TAX 1234`, on yellow: region first, no flag.
  static final PlateSpec taxi = PlateSpec(
    id: 'by.taxi',
    country: BelarusCountry.belarus,
    canvasWidth: _Layout.width,
    canvasHeight: _Layout.height,
    panel: _Layout.none,
    slots: [
      _region(51),
      ...plateRegisterAcross(
        alphabet: PlateAlphabet.latinDigits,
        count: 4,
        left: 300,
        right: 501,
        top: _Layout.rowTop,
        height: _Layout.rowHeight,
      ),
    ],
    labels: const [
      // TAX ink centres 129/193/261.
      PlateLabel(
        text: 'TAX',
        // A label sits higher than a slot's glyph; dropped to share the
        // digits' baseline.
        box: PlateBox(97, 12, 196, _Layout.rowHeight - 12),
        glyphHeight: 96,
      ),
    ],
    textGroups: const [
      PlateTextGroup([0], key: 'region', prefix: ''),
      PlateTextGroup([1, 2, 3, 4], key: 'serial', prefix: ' TAX '),
    ],
  );

  /// Diplomatic, `CD 1234-7` (corps) / `CC 1234-7` (consular), white on red.
  ///
  /// The first two digits are the mission code ([BelarusMissions]); `09` is
  /// refused by [BelarusMissions.restriction], so no write can store it.
  static final PlateSpec diplomatic = PlateSpec(
    id: 'by.diplomatic',
    country: BelarusCountry.belarus,
    canvasWidth: _Layout.width,
    canvasHeight: _Layout.height,
    panel: _Layout.none,
    slots: [
      _cell(BelarusAlphabets.diplomaticFirst, 79.7, 63),
      _cell(BelarusAlphabets.diplomaticSecond, 142.7, 63),
      // Digits pitch 51.1, register 208.65..413.05.
      ...plateRegisterAcross(
        alphabet: PlateAlphabet.latinDigits,
        count: 4,
        left: 208.65,
        right: 413.05,
        top: _Layout.rowTop,
        height: _Layout.rowHeight,
      ),
      _region(468.9),
    ],
    labels: [_dash(424.6, _Layout.rowTop, _Layout.rowHeight)],
    textGroups: const [
      PlateTextGroup([0, 1], key: 'letters'),
      PlateTextGroup([2, 3], key: 'mission', prefix: ' '),
      PlateTextGroup([4, 5], key: 'serial'),
      PlateTextGroup([6], key: 'region', prefix: '-'),
    ],
    restrictions: const [BelarusMissions.restriction],
  );

  /// Service plate, `1234 MO`: armed forces (MO), border guard (PV) and
  /// interior ministry (MVD) differ only in theme.
  static final PlateSpec service = PlateSpec(
    id: 'by.service',
    country: BelarusCountry.belarus,
    canvasWidth: _Layout.width,
    canvasHeight: _Layout.height,
    panel: _Layout.none,
    slots: [
      // Pitch 53.7.
      ...plateRegisterAcross(
        alphabet: PlateAlphabet.latinDigits,
        count: 4,
        left: 52,
        right: 266.8,
        top: _Layout.rowTop,
        height: _Layout.rowHeight,
      ),
      _cell(BelarusAlphabets.letters, 347.5, 81.5),
      _cell(BelarusAlphabets.letters, 429, 81.5),
    ],
    textGroups: const [
      PlateTextGroup([0, 1, 2, 3], key: 'serial'),
      PlateTextGroup([4, 5], key: 'letters', prefix: ' '),
    ],
  );

  /// A two-line plate: a four-digit row and a `LL-R` row with the flag
  /// block beside it. [digitsOnTop] swaps the rows; everything else is
  /// [_TwoLine] geometry for that canvas.
  static PlateSpec _twoLine({
    required String id,
    required _TwoLine g,
    required bool digitsOnTop,
  }) {
    final digitsTop = digitsOnTop ? g.topRow : g.bottomRow;
    final lettersTop = digitsOnTop ? g.bottomRow : g.topRow;
    final h = g.rowHeight;
    return PlateSpec(
      id: id,
      country: BelarusCountry.belarus,
      canvasWidth: 280,
      canvasHeight: g.height,
      panel: PlatePanel(
        box: PlateBox(
          g.flagLeft,
          lettersTop + g.flagInset,
          g.flagWidth,
          h - g.flagInset - g.flagFoot,
        ),
        padding: EdgeInsets.zero,
        captionScale: 1.4,
      ),
      slots: [
        for (final c in g.digitCentres)
          _cell(
            PlateAlphabet.latinDigits,
            c,
            g.digitWidth,
            top: digitsTop,
            h: h,
          ),
        for (final c in g.letterCentres)
          _cell(
            BelarusAlphabets.letters,
            c,
            g.letterWidth,
            top: lettersTop,
            h: h,
          ),
        _cell(
          BelarusAlphabets.region,
          g.regionCentre,
          g.digitWidth,
          top: lettersTop,
          h: h,
        ),
      ],
      labels: [_dash(g.dashCentre, lettersTop, h)],
      textGroups: const [
        PlateTextGroup([0, 1, 2, 3], key: 'serial'),
        PlateTextGroup([4, 5], key: 'letters', prefix: ' '),
        PlateTextGroup([6], key: 'region', prefix: '-'),
      ],
    );
  }

  /// Square car plate (280×200), digits over `AB-7`.
  static final PlateSpec carSquare = _twoLine(
    id: 'by.car.square',
    g: _TwoLine.tall,
    digitsOnTop: true,
  );

  /// Square truck plate (280×200), `AB-7` over digits.
  static final PlateSpec truckSquare = _twoLine(
    id: 'by.truck.square',
    g: _TwoLine.tall,
    digitsOnTop: false,
  );

  /// Motorcycle (280×156), `AB-7` over digits.
  static final PlateSpec motorcycle = _twoLine(
    id: 'by.motorcycle',
    g: _TwoLine.short,
    digitsOnTop: false,
  );

  /// Tractor (280×156), digits over `AB-7`.
  static final PlateSpec tractor = _twoLine(
    id: 'by.tractor',
    g: _TwoLine.short,
    digitsOnTop: true,
  );

  static final List<PlateSpec> all = [
    car,
    electricCar,
    truck,
    electricTruck,
    trailer,
    taxi,
    diplomatic,
    service,
    carSquare,
    truckSquare,
    motorcycle,
    tractor,
  ];
}

/// Geometry of a two-line canvas.
class _TwoLine {
  const _TwoLine({
    required this.height,
    required this.topRow,
    required this.bottomRow,
    required this.rowHeight,
    required this.digitCentres,
    required this.digitWidth,
    required this.letterCentres,
    required this.letterWidth,
    required this.dashCentre,
    required this.regionCentre,
    required this.flagLeft,
    required this.flagWidth,
    required this.flagInset,
    required this.flagFoot,
  });

  final double height, topRow, bottomRow, rowHeight;
  final List<double> digitCentres, letterCentres;
  final double digitWidth, letterWidth, dashCentre, regionCentre;
  final double flagLeft, flagWidth, flagInset, flagFoot;

  /// 280×200, from BY-auto-number-4: digit centres 67.9..199.3 (pitch 43.8),
  /// letters at 100/157.2, dash 200.5, region 238.8, flag x 22.3..58.4.
  static const _TwoLine tall = _TwoLine(
    height: 200,
    topRow: 4,
    bottomRow: 100,
    rowHeight: 96,
    digitCentres: [67.9, 111.7, 155.5, 199.3],
    digitWidth: 43.8,
    letterCentres: [100, 157.2],
    letterWidth: 57,
    dashCentre: 200.5,
    regionCentre: 238.8,
    flagLeft: 22,
    flagWidth: 36,
    flagInset: 8,
    flagFoot: 14,
  );

  /// 280×156, from BY-auto-number-6/7: digit centres 82..190 (pitch 36),
  /// letters at 119/170, dash 206, region 236, flag x 34..70.
  static const _TwoLine short = _TwoLine(
    height: 156,
    topRow: 4,
    bottomRow: 78,
    rowHeight: 74,
    digitCentres: [82, 118, 154, 190],
    digitWidth: 36,
    letterCentres: [119, 170],
    letterWidth: 51,
    dashCentre: 206,
    regionCentre: 236,
    flagLeft: 34,
    flagWidth: 36,
    flagInset: 2,
    flagFoot: 8,
  );
}
