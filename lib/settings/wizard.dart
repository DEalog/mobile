import 'dart:collection';

import 'package:easy_localization/easy_localization.dart';
import 'package:fimber/fimber_base.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:mobile/generated/locale_keys.g.dart';
import 'package:mobile/main.dart';
import 'package:mobile/model/region.dart';
import 'package:mobile/model/channel.dart';
import 'package:mobile/model/gis.dart';
import 'package:mobile/ui_kit/platform/select.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';
import '../version.dart';

final _formKey = GlobalKey<FormState>();
const _totalSteps = 3;

class ChannelWizard extends StatefulWidget {
  final Preference<List<Channel>> channelSettings;

  ChannelWizard({this.channelSettings});

  @override
  _ChannelWizardState createState() =>
      _ChannelWizardState(channelSettings: this.channelSettings);
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
  List<Channel> channels = List<Channel>();
  int _stepNumber = 1;
  Location location;
  Set<RegionLevel> levels;
  Set<ChannelCategory> categories;

  DataProvider _dataProvider = DataProvider();

  _ChannelWizardState({this.channelSettings}) {
    this.channels.addAll(channelSettings.getValue());
    this.location = Location.empty();
  }

  @override
  void initState() {
    super.initState();
  }

  final editingLocation = TextEditingController();

  bool useLocation() => this.location == null;

  void saveData(BuildContext context) {
    _formKey.currentState.save();
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
              PlatformTextField(
                key: Key('wizardLocationTextField'),
                controller: editingLocation,
                enabled: !useLocation(),
                onChanged: (value) {
                  setState(() {
                    this.location = Location(value, null, null);
                  });
                },
                material: (context, platform) => MaterialTextFieldData(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: LocaleKeys.settings_enter_location.tr(),
                  ),
                ),
                cupertino: (context, platform) => CupertinoTextFieldData(
                  placeholder: LocaleKeys.settings_enter_location.tr(),
                ),
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
                              color: Colors.white,
                            )
                          : Icon(
                              PlatformIcons(context).location,
                              color: Colors.black,
                            ),
                      Text(
                        LocaleKeys.settings_use_location.tr(),
                        style: TextStyle(
                            color: useLocation() ? Colors.white : Colors.black),
                      ),
                    ],
                  ),
                  onPressed: () {
                    setState(() {
                      Fimber.i("Update useLocation: $useLocation()");
                      if (useLocation()) {
                        this.location = Location.empty();
                      } else {
                        this.editingLocation.clear();
                        this.location = null;
                      }
                    });
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
    final arsEntries = _dataProvider.fetchArsEntries(null);
    final regionLevels = arsEntries.map((e) => e.regionLevel).toList();
    final arsMap =
        HashMap.fromEntries(arsEntries.map((e) => MapEntry(e.regionLevel, e)));
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
          child: MultiSelectFormField<RegionLevel>(
            elements: regionLevels,
            elementName: (regionLevel) =>
                "${arsMap[regionLevel].name} (${regionLevelName(regionLevel)})",
            initialValue: regionLevels.toSet(),
            onSaved: (regionLevels) {
              Fimber.i("RegionLevels selected: $regionLevels");
              if (regionLevels != null && regionLevels.isNotEmpty) {
                setState(() {
                  levels = regionLevels;
                });
              }
            },
          ),
        ),
      ],
    );
  }

  Widget formThreeBuilder(BuildContext context) {
    var mediaQuerySize = MediaQuery.of(context).size;
    return Column(
      key: Key("ChannelWizardCategory"),
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(
            top: mediaQuerySize.width * 0.1,
            bottom: mediaQuerySize.width * 0.1,
          ),
          child: Container(
            alignment: Alignment.center,
            child: Text(
              LocaleKeys.settings_select_category.tr(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24.0,
              ),
            ),
          ),
        ),
        Expanded(
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
    final version = getIt<Version>();
    final form = buildForm(context);
    final mediaQuerySize = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: () async => !version.isInitialVersion,
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
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: mediaQuerySize.width * 0.1),
                  child: form,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: mediaQuerySize.height * 0.01,
                ),
                child: bottomTopButton(),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: mediaQuerySize.height * 0.005,
                  bottom: mediaQuerySize.height * 0.02,
                ),
                child: bottomButton(),
              ),
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
    final version = getIt<Version>();
    if (_stepNumber == 1) {
      if (version.isInitialVersion) {
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
    final version = getIt<Version>();
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
                  this.location,
                  this.levels,
                  this.categories,
                ));
            this.channelSettings.setValue(
                  this.channels,
                );

            if (version.isInitialVersion) {
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
    if (_formKey.currentState.validate()) {
      Fimber.i("Form validates");
      _formKey.currentState.save();
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
