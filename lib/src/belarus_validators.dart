import 'package:plate_core/plate_core.dart';

import 'belarus_missions.dart';

/// Every Belarusian number ends in a region digit; the validator stays quiet
/// until it is filled. Advisory, like every validator — except for the spec's
/// restrictions, which [GatedPlateValidator] reports first.
class BelarusPlateValidator extends GatedPlateValidator {
  const BelarusPlateValidator();

  @override
  String get gateGroup => 'region';

  @override
  PlateValidation judge(PlateEntry entry) {
    for (final g in entry.spec.textGroups) {
      final key = g.key;
      if (key == null) continue;
      if (entry.group(key).length != g.indices.length) {
        return PlateValidation.invalid('The $key is incomplete.');
      }
    }
    return const PlateValidation.valid();
  }
}

/// [BelarusPlateValidator] plus the mission register. Refuses `09` on its own
/// account as well, so it holds even against a spec built without
/// [BelarusMissions.restriction].
class BelarusDiplomaticValidator extends BelarusPlateValidator {
  const BelarusDiplomaticValidator();

  @override
  PlateValidation validate(PlateEntry entry) {
    final mission = entry.group('mission');
    if (BelarusMissions.isRefused(mission)) {
      return const PlateValidation.invalid(BelarusMissions.notFound);
    }
    return super.validate(entry);
  }

  @override
  PlateValidation judge(PlateEntry entry) {
    final verdict = super.judge(entry);
    if (!verdict.isValid) return verdict;
    if (BelarusMissions.name(entry.group('mission')) == null) {
      return const PlateValidation.invalid(BelarusMissions.notFound);
    }
    return verdict;
  }
}

/// Service plates (`1234 MO`) carry no region digit; gated on the letters.
class BelarusServiceValidator extends GatedPlateValidator {
  const BelarusServiceValidator();

  @override
  String get gateGroup => 'letters';

  @override
  PlateValidation judge(PlateEntry entry) =>
      isDigitsOfLength(entry.group('serial'), 4)
      ? const PlateValidation.valid()
      : const PlateValidation.invalid('The serial is incomplete.');
}
