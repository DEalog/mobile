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
    "update": "Aktualisieren",
    "save": "Speichern",
    "continue": "Weiter",
    "back": "Zurück"
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
    "use_location": "Gerätestandort nutzen",
    "current_location": "Aktueller Standort",
    "select_location": "Für welchen Ort möchtest du informiert werden?",
    "select_layer": "Aus welchen föderalen Ebenen möchtest du informiert werden?",
    "select_category": "Für welche Bereiche möchtest du informiert werden?",
    "enter_location": "Ort eingeben",
    "enter_location_minimum_characters": "Mindestens 3 Buchstaben sind erforderlich",
    "no_valid_location_selected": "Es wurde noch keiner gültiger Ort gewählt"
  },
  "messages": {
    "no_feed_messages_available": "Es sind keine Nachrichten für diesen Bereich verfügbar"
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
    "update": "Update",
    "save": "Save",
    "continue": "Continue",
    "back": "Back"
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
    "use_location": "Use device location",
    "current_location": "Current location",
    "select_location": "For which location do you want to be informed?",
    "select_layer": "From which federal layers would you like to be informed?",
    "select_category": "For which areas would you like to be informed?",
    "enter_location": "Enter location",
    "enter_location_minimum_characters": "A minimum of 3 characters is required",
    "no_valid_location_selected": "No valid location selected"
  },
  "messages": {
    "no_feed_messages_available": "No messages available for this area"
  }
};
static const Map<String, Map<String,dynamic>> mapLocales = {"de": de, "en": en};
}
