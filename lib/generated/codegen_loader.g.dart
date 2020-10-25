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

  static const Map<String,dynamic> de = {
  "navigation": {
    "home": "Home",
    "messages": "Meldungen",
    "map": "Karte",
    "settings": "Einstellungen"
  },
  "actions": {
    "cancel": "Abbrechen",
    "add": "Hinzufügen",
    "update": "Aktualisieren"
  },
  "model": {
    "category": "Kategorie",
    "categories": {
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
    },
    "levels": {
      "COUNTRY": "Land",
      "STATE": "Bundesland",
      "COUNTY": "Regierungsbezirk",
      "DISTRICT": "Landkreis",
      "MUNICIPALITY": "Gemeinde"
    },
    "location": "Ort"
  },
  "settings": {
    "channel": {
      "title": "Abonnierte Kanäle",
      "none_defined": "Bitte abonnieren Sie einen Kanal!"
    },
    "use_location": "Gerätestandort nutzen"
  }
};
static const Map<String,dynamic> en = {
  "navigation": {
    "home": "Home",
    "messages": "Messages",
    "map": "Map",
    "settings": "Settings"
  },
  "actions": {
    "cancel": "Cancel",
    "add": "Add",
    "update": "Update"
  },
  "model": {
    "category": "Category",
    "categories": {
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
    },
    "levels": {
      "COUNTRY": "Country",
      "STATE": "State",
      "COUNTY": "County",
      "DISTRICT": "District",
      "MUNICIPALITY": "Municipality"
    },
    "location": "Location"
  },
  "settings": {
    "channel": {
      "title": "Subscribed Channels",
      "none_defined": "Please subscribe a channel!"
    },
    "use_location": "Use device location"
  }
};
static const Map<String, Map<String,dynamic>> mapLocales = {"de": de, "en": en};
}
