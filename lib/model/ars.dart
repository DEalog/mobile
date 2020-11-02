import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';

enum ArsLevel { COUNTRY, STATE, COUNTY, DISTRICT, MUNICIPALITY }

String arsLevelLocalizationKey(ArsLevel arsLevel) =>
    "model.levels.${describeEnum(arsLevel)}";

String arsLevelName(ArsLevel arsLevel) =>
    arsLevelLocalizationKey(arsLevel).tr();
