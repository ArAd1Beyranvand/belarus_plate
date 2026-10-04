import 'package:belarus_plate/belarus_plate.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plate_core/plate_core.dart';

/// Code 09 must be refused in every layer, always with "COUNTRY NOT FOUND".
void main() {
  const notFound = 'COUNTRY NOT FOUND';
  final spec = BelarusPlates.diplomatic;
  List<String?> values(String s) => s.split('');

  test('registry: name() throws, all omits it', () {
    expect(
      () => BelarusMissions.name('09'),
      throwsA(
        isA<PlateRestrictionException>().having(
          (e) => e.toString(),
          'reason',
          notFound,
        ),
      ),
    );
    expect(BelarusMissions.all.containsKey('09'), isFalse);
    expect(BelarusMissions.name('31'), 'United States');
  });

  test('spec: restriction is declared and checkRestrictions throws', () {
    expect(spec.restrictions, contains(BelarusMissions.restriction));
    expect(spec.restrictionViolatedBy(values('CD09123'))?.reason, notFound);
    expect(
      () => spec.checkRestrictions(values('CD09123')),
      throwsA(isA<PlateRestrictionException>()),
    );
  });

  test('controller: setAt / setValues / setGroup refuse 09', () {
    final c = PlateController.fromValues(spec, values('CD0_123'));
    expect(c.setAt(3, '9'), isFalse);
    expect(c.valueAt(3), isNull);
    expect(c.rejection.value?.reason, notFound);
    expect(c.validation?.reason, notFound);
    expect(c.setValues(values('CD09123')), isFalse);
    expect(c.setGroup('mission', '09'), isFalse);
    expect(c.setAt(3, '8'), isTrue);
    expect(c.rejection.value, isNull);
    c.dispose();
  });

  test('controller: constructed with 09 drops it', () {
    final c = PlateController.fromValues(spec, values('CD09123'));
    expect(spec.valueOfGroup('mission', c.values), isNot('09'));
    expect(c.rejection.value?.reason, notFound);
    c.dispose();
  });

  test(
    'validators: both report it, even on a spec without the restriction',
    () {
      final entry = PlateEntry(spec: spec, values: values('CD09123'));
      expect(
        const BelarusDiplomaticValidator().validate(entry).reason,
        notFound,
      );
      expect(const BelarusPlateValidator().validate(entry).reason, notFound);
      expect(restrictionVerdict(entry)?.reason, notFound);

      final bare = PlateSpec(
        id: 'bare',
        country: spec.country,
        canvasWidth: spec.canvasWidth,
        canvasHeight: spec.canvasHeight,
        panel: spec.panel,
        slots: spec.slots,
        textGroups: spec.textGroups,
      );
      expect(
        const BelarusDiplomaticValidator()
            .validate(PlateEntry(spec: bare, values: values('CD09123')))
            .reason,
        notFound,
      );
    },
  );

  test('a listed mission validates', () {
    final entry = PlateEntry(spec: spec, values: values('CD31123'));
    expect(const BelarusDiplomaticValidator().validate(entry).isValid, isTrue);
  });
}
