// DO NOT EDIT. This is code generated via package:easy_localization/generate.dart

// ignore_for_file: prefer_single_quotes

import 'dart:ui';

import 'package:easy_localization/easy_localization.dart' show AssetLoader;

class CodegenLoader extends AssetLoader{
  const CodegenLoader();

  @override
  Future<Map<String, dynamic>> load(String fullPath, Locale locale ) {
    return Future.value(mapLocales[locale.toString()]);
  }

  static const Map<String,dynamic> en_US = {
  "navigation": {
    "home": "Home",
    "messages": "Messages",
    "map": "Map",
    "settings": "Settings"
  },
  "model": {
    "category": {
      "GEO": "Geophysical",
      "MET": "Meteorological",
      "SAFETY": "General emergency",
      "SECURITY": "Security",
      "RESCUE": "Rescue",
      "FIRE": "Fire",
      "HEALTH": "Health",
      "ENV": "Environment",
      "TRANSPORT": "Transportation",
      "INFRA": "Infrastructure",
      "CBRNE": "Threat",
      "OTHER": "Other"
    }
  },
  "settings": {
    "channel": {
      "title": "Subscribed Channels",
      "none_defined": "Please subscribe a channel!"
    }
  }
};
static const Map<String,dynamic> de_DE = {
  "navigation": {
    "home": "Home",
    "messages": "Meldungen",
    "map": "Karte",
    "settings": "Einstellungen"
  },
  "model": {
    "category": {
      "GEO": "Erdbeben",
      "MET": "Wetter",
      "SAFETY": "Warnung",
      "SECURITY": "Sicherheit",
      "RESCUE": "Rettung",
      "FIRE": "Feuer",
      "HEALTH": "Gesundheit",
      "ENV": "Umwelt",
      "TRANSPORT": "Transport",
      "INFRA": "Infrastruktur",
      "CBRNE": "Bedrohung",
      "OTHER": "Andere"
    }
  },
  "settings": {
    "channel": {
      "title": "Abonnierte Kanäle",
      "none_defined": "Bitte abonnieren Sie einen Kanal!"
    }
  }
};
static const Map<String, Map<String,dynamic>> mapLocales = {"en_US": en_US, "de_DE": de_DE};
}
