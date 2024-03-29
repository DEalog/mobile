import 'dart:collection';

import 'package:easy_localization/easy_localization.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:mobile/api/data_service.dart';
import 'package:mobile/api/location_service.dart';
import 'package:mobile/api/model/region_hierarchy.dart';
import 'package:mobile/generated/locale_keys.g.dart';
import 'package:mobile/main.dart';
import 'package:mobile/model/region.dart';
import 'package:mobile/model/channel.dart';
import 'package:mobile/model/gis.dart';
import 'package:mobile/ui_kit/platform/listtile.dart';
import 'package:mobile/ui_kit/platform/select.dart';
import 'package:mobile/ui_kit/platform/typeahead.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';
import '../version.dart';

final _formKey = GlobalKey<FormState>();
const _totalSteps = 3;

class ChannelWizard extends StatefulWidget {
  final Preference<List<Channel>> channelSettings;

  ChannelWizard(this.channelSettings);

  @override
  _ChannelWizardState createState() =>
      _ChannelWizardState(this.channelSettings);
}

class ArsEntry {
  final String name;
  final RegionLevel regionLevel;

  ArsEntry(this.name, this.regionLevel);
}

class DataProvider {
  List<ArsEntry> fetchArsEntries(Coordinate coordinate) {
    return [
      ArsEntry("Deutschland", RegionLevel.COUNTRY),
      ArsEntry("Bayern", RegionLevel.STATE),
      ArsEntry("Oberbayern", RegionLevel.DISTRICT),
      ArsEntry("Weilheim", RegionLevel.COUNTY),
      ArsEntry("Peißenberg", RegionLevel.MUNICIPALITY)
    ];
  }
}

class _ChannelWizardState extends State<ChannelWizard> {
  final Preference<List<Channel>> channelSettings;
  List<Channel> channels;
  int _stepNumber = 1;
  ChannelLocation channelLocation;
  Set<RegionLevel> _levels;
  List<Region> _regionHierarchy;
  Set<ChannelCategory> categories;
  DataService dataService = getIt<DataService>();
  LocationService _locationService = getIt<LocationService>();

  _ChannelWizardState(this.channelSettings)
      : _levels = {},
        _regionHierarchy = [],
        categories = {},
        channelLocation = ChannelLocation.empty(),
        channels = List.empty(growable: true);

  @override
  void initState() {
    channels.addAll(channelSettings.getValue());
    super.initState();
  }

  final editingLocation = TextEditingController();

  bool useLocation() => this.channelLocation.coordinate.isValid;

  void saveData(BuildContext context) {
    _formKey.currentState!.save();
  }

  void nextPage(BuildContext context) {
    setState(() {
      _stepNumber = (_stepNumber + 1) % _totalSteps;
    });
  }

  Column formOneBuilder(BuildContext context) {
    var mediaQuerySize = MediaQuery.of(context).size;
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(
            top: mediaQuerySize.width * 0.1,
            bottom: mediaQuerySize.width * 0.2,
          ),
          child: Container(
            key: Key('wizardFormOneText'),
            alignment: Alignment.center,
            child: Text(
              LocaleKeys.settings_select_location.tr(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24.0,
              ),
            ),
          ),
        ),
        Container(
          width: mediaQuerySize.width * 0.7,
          child: Column(
            children: [
              PlatformTypeAhead(
                key: Key('wizardLocationTextField'),
                textFieldConfiguration: TextFieldConfiguration(
                  controller: editingLocation,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: LocaleKeys.settings_enter_location.tr(),
                  ),
                  enabled: !useLocation(),
                ),
                cupertinoTextFieldConfiguration:
                    CupertinoTextFieldConfiguration(
                  onChanged: (value) {},
                  controller: editingLocation,
                  placeholder: LocaleKeys.settings_enter_location.tr(),
                  enabled: !useLocation(),
                ),
                suggestionsCallback: (pattern) {
                  return dataService.getMunicipalRegions(pattern);
                },
                itemBuilder: (context, region) {
                  return PlatformListTile(
                    key: Key('WizardLocationTextFieldSuggestionTile'),
                    title: Text(region.name),
                  );
                },
                validator: (value) {
                  if (!useLocation() && value!.length < 3) {
                    return LocaleKeys.settings_enter_location_minimum_characters
                        .tr();
                  }
                  if (channelLocation.isEmpty) {
                    return LocaleKeys.settings_no_valid_location_selected.tr();
                  }
                  return null;
                },
                autovalidateMode: AutovalidateMode.always,
                hideOnEmpty: true,
                onSaved: (suggestion) async {
                  if (!useLocation() && channelLocation.name != suggestion) {
                    Region suggestedRegion =
                        await dataService.getMunicipalRegion(suggestion!);

                    if (!suggestedRegion.isEmpty) {
                      setState(
                        () {
                          this.editingLocation.text = suggestedRegion.name;
                          this.channelLocation = ChannelLocation(
                            suggestedRegion.name,
                            Coordinate.invalid(),
                            suggestedRegion,
                          );
                        },
                      );
                    }
                  }
                },
                onSuggestionSelected: (suggestion) {
                  Region suggestedRegion = suggestion;
                  setState(() {
                    this.editingLocation.text = suggestedRegion.name;
                    this.channelLocation = ChannelLocation(
                      suggestedRegion.name,
                      Coordinate.invalid(),
                      suggestedRegion,
                    );
                  });
                },
              ),
              Padding(
                padding: EdgeInsets.only(top: mediaQuerySize.height * 0.03),
                child: PlatformButton(
                  key: Key('wizardUseLocationButton'),
                  cupertino: (context, platform) => CupertinoButtonData(
                    padding: EdgeInsets.zero,
                    color: useLocation() ? Colors.blue : Colors.white,
                  ),
                  material: (context, platform) => MaterialRaisedButtonData(
                    padding: EdgeInsets.zero,
                    color: useLocation() ? Colors.blue : Colors.white,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      useLocation()
                          ? Icon(
                              PlatformIcons(context).locationSolid,
                              key: Key('wizardUseLocationIconSolid'),
                              color: Colors.white,
                            )
                          : Icon(
                              PlatformIcons(context).location,
                              key: Key('wizardUseLocationIcon'),
                              color: Colors.black,
                            ),
                      Text(
                        LocaleKeys.settings_use_location.tr(),
                        style: TextStyle(
                            color: useLocation() ? Colors.white : Colors.black),
                      ),
                    ],
                  ),
                  onPressed: () async {
                    Fimber.i("Update useLocation: $useLocation()");
                    if (!useLocation()) {
                      _locationService.getLocationFromDevice().then(
                        (locationData) {
                          Fimber.i("Location fetched: $locationData");
                          setState(() {
                            this.editingLocation.clear();
                            this.channelLocation = ChannelLocation(
                              '',
                              Coordinate(
                                locationData.longitude!,
                                locationData.latitude!,
                              ),
                              Region.empty(),
                            );
                          });
                        },
                      );
                    } else {
                      setState(() {
                        this.channelLocation = ChannelLocation.empty();
                      });
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Column formTwoBuilder(BuildContext context) {
    final mediaQuerySize = MediaQuery.of(context).size;

    return Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(
            top: mediaQuerySize.width * 0.1,
            bottom: mediaQuerySize.width * 0.1,
          ),
          child: Container(
            alignment: Alignment.center,
            child: Text(
              LocaleKeys.settings_select_layer.tr(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24.0,
              ),
            ),
          ),
        ),
        Expanded(
          child: FutureBuilder<RegionHierarchy>(            
              future: dataService.getRegionHierarchy(channelLocation),
              builder: (BuildContext context,
                  AsyncSnapshot<RegionHierarchy> snapshot) {
                if (snapshot.hasData) {
                  final arsEntries = snapshot.data!.regionHierarchy;
                  final regionLevels = arsEntries.map((e) => e.type).toList();
                  final arsMap = HashMap.fromEntries(
                      arsEntries.map((e) => MapEntry(e.type, e)));
                  return MultiSelectFormField<RegionLevel>(
                    key: Key('RegionHierarchyMultiSelect'),
                    elements: regionLevels,
                    elementName: (regionLevel) =>
                        "${arsMap[regionLevel]!.name} (${regionLevelName(regionLevel)})",
                    initialValue: regionLevels.toSet(),
                    autovalidateMode: AutovalidateMode.always,
                    validator: (selectedRegionLevels) {
                      if (selectedRegionLevels == null ||
                          selectedRegionLevels.isEmpty) {
                        return LocaleKeys.settings_select_least_one_federal_layer.tr();
                      }
                      var selectedRegionLevelIndexesByOriginList =
                          selectedRegionLevels
                              .map((selectedRegionLevel) =>
                                  regionLevels.indexOf(selectedRegionLevel))
                              .toList();
                      selectedRegionLevelIndexesByOriginList.sort();
                      var selectedRegionLevelsIncreasingByOneAndStartingWithZero =
                          selectedRegionLevelIndexesByOriginList.fold<int>(
                        -1,
                        (previousValue, element) {
                          if (previousValue == -2) {
                            return -2;
                          } else if (previousValue == -1 && element == 0) {
                            return 0;
                          } else if (previousValue == -1 && element > 0) {
                            return -2;
                          } else if (element - previousValue > 1) {
                            return -2;
                          } else {
                            return previousValue + element;
                          }
                        },
                      );
                      if (selectedRegionLevelsIncreasingByOneAndStartingWithZero ==
                          -2) {
                        return LocaleKeys.settings_interrupted_federal_layer_sequence.tr();
                      }
                      return null;
                    },
                    onSaved: (regionLevels) {
                      Fimber.i("RegionLevels selected: $regionLevels");
                      if (regionLevels != null && regionLevels.isNotEmpty) {
                        setState(() {
                          _levels = regionLevels;
                          _regionHierarchy = arsEntries;
                        });
                      }
                    },
                  );
                } else if (snapshot.hasError) {
                  
                  SnackBar(content: Text("No Internet connection!"),).createState();
                  Fimber.e(
                    "No regionlevels could be fetched from endpoint",
                    stacktrace: snapshot.stackTrace,
                  );
                  return Column(
                    children: [
                      CircularProgressIndicator(),
                      Spacer(),
                    ],
                  );
                }
                return Container();
              }),
        ),
      ],
    );
  }

  Widget formThreeBuilder(BuildContext context) {
    return Column(
      key: Key("ChannelWizardCategory"),
      children: <Widget>[
        Spacer(),
        Center(
          child: Text(
            LocaleKeys.settings_select_category.tr(),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24.0,
            ),
          ),
        ),
        Spacer(),
        Expanded(
          flex: 20,
          child: MultiSelectFormField<ChannelCategory>(
            initialValue: ChannelCategory.values.toSet(),
            elements: ChannelCategory.values,
            elementName: (regionLevel) => categoryName(regionLevel),
            onSaved: (channelCategories) {
              Fimber.i("Channel categories selected: $channelCategories");
              if (channelCategories != null && channelCategories.isNotEmpty) {
                setState(() {
                  this.categories = channelCategories;
                  Fimber.i("Channel categories selected: $channelCategories");
                });
              }
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final Version? version = getIt<Version>();
    final form = buildForm(context);
    final mediaQuerySize = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: () async => !version!.isInitialVersion,
      child: PlatformScaffold(
        material: (context, platform) =>
            MaterialScaffoldData(resizeToAvoidBottomInset: false),
        cupertino: (context, platform) => CupertinoPageScaffoldData(
          resizeToAvoidBottomInset: false,
        ),
        iosContentPadding: true,
        body: SafeArea(
          child: Column(
            children: [
              AppBar(
                centerTitle: true,
                title: Image.asset(
                  'assets/images/dealog_logo.png',
                  key: Key('DEalogLogoKey'),
                  fit: BoxFit.cover,
                  height: MediaQuery.of(context).size.height * 0.07,
                ),
                automaticallyImplyLeading: false,
                elevation: 0.0,
                toolbarHeight: MediaQuery.of(context).size.height * 0.1,
              ),
              Expanded(
                flex: 20,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: mediaQuerySize.width * 0.1),
                  child: form,
                ),
              ),
              Spacer(),
              bottomTopButton(),
              Spacer(),
              bottomButton(),
              Spacer(),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildForm(BuildContext context) {
    switch (_stepNumber) {
      case 1:
        return Form(
          key: _formKey,
          child: formOneBuilder(context),
        );

      case 2:
        return Form(
          key: _formKey,
          child: formTwoBuilder(context),
        );

      case 3:
        return Form(
          key: _formKey,
          child: formThreeBuilder(context),
        );
      default:
        throw Error();
    }
  }

  bottomButton() {
    final Version? version = getIt<Version>();
    if (_stepNumber == 1) {
      if (version!.isInitialVersion) {
        return Container();
      } else {
        return cancelButton();
      }
    } else {
      return backButton();
    }
  }

  bottomTopButton() {
    if (_stepNumber == _totalSteps) {
      return saveButton();
    } else {
      return continueButton();
    }
  }

  Widget cancelButton() {
    return PlatformButton(
      key: Key("wizardCancel"),
      materialFlat: (context, platform) => MaterialFlatButtonData(),
      child: Text(LocaleKeys.actions_cancel.tr()),
      onPressed: () {
        Fimber.i("Cancel pressed");

        Navigator.pop(context);
      },
    );
  }

  Widget saveButton() {
    final Version? version = getIt<Version>();
    return PlatformButton(
        key: Key("wizardSave"),
        materialFlat: (context, platform) => MaterialFlatButtonData(
              color: Colors.black,
              textColor: Colors.white,
            ),
        child: Text(LocaleKeys.actions_save.tr()),
        cupertinoFilled: (_, __) => CupertinoFilledButtonData(),
        onPressed: () {
          Fimber.i("Save pressed");
          if (submit()) {
            this.channels.add(Channel(
                  this.channelLocation,
                  this._levels,
                  this._regionHierarchy,
                  this.categories,
                ));
            this.channelSettings.setValue(
                  this.channels,
                );

            if (version!.isInitialVersion) {
              version.updateVersionState();
            }

            Navigator.pop(context);
          }
        });
  }

  Widget backButton() {
    return PlatformButton(
        key: Key("wizardBack"),
        materialFlat: (context, platform) => MaterialFlatButtonData(),
        child: Text(LocaleKeys.actions_back.tr()),
        onPressed: () {
          Fimber.i("Back pressed");
          setState(() {
            --_stepNumber;
          });
        });
  }

  Widget continueButton() {
    return PlatformButton(
        key: Key("wizardContinue"),
        material: (context, platform) => MaterialRaisedButtonData(
              color: Colors.black,
              textColor: Colors.white,
            ),
        child: Text(LocaleKeys.actions_continue.tr()),
        cupertinoFilled: (_, __) => CupertinoFilledButtonData(),
        onPressed: () {
          Fimber.i("Continue pressed");
          if (submit()) {
            setState(() {
              ++_stepNumber;
            });
          }
        });
  }

  bool submit() {
    Fimber.i("Submit pressed");
    if (_formKey.currentState!.validate()) {
      Fimber.i("Form validates");
      _formKey.currentState!.save();
      return true;
    } else {
      Fimber.i("Form does not validate");
      return false;
    }
  }

  void dispose() {
    editingLocation.dispose();
    super.dispose();
  }
}
