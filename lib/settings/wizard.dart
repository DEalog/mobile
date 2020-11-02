import 'dart:collection';

import 'package:easy_localization/easy_localization.dart';
import 'package:fimber/fimber_base.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:mobile/generated/locale_keys.g.dart';
import 'package:mobile/model/ars.dart';
import 'package:mobile/model/channel.dart';
import 'package:mobile/model/gis.dart';
import 'package:mobile/ui_kit/platform/select.dart';

final _formKey = GlobalKey<FormState>();

const _totalSteps = 3;

class FormWidget extends StatefulWidget {
  @override
  _FormWidgetState createState() => _FormWidgetState();
}

class ArsEntry {
  final String name;
  final ArsLevel arsLevel;

  ArsEntry(this.name, this.arsLevel);
}

class DataProvider {
  List<ArsEntry> fetchArsEntries(Coordinate coordinate) {
    return [
      ArsEntry("Deutschland", ArsLevel.COUNTRY),
      ArsEntry("Bayern", ArsLevel.STATE),
      ArsEntry("Oberbayern", ArsLevel.DISTRICT),
      ArsEntry("Weilheim", ArsLevel.COUNTY),
      ArsEntry("Peißenberg", ArsLevel.MUNICIPALITY)
    ];
  }
}

class _FormWidgetState extends State<FormWidget> {
  int _stepNumber = 1;
  DataProvider _dataProvider = DataProvider();

  final ctl_name = TextEditingController();
  final ctl_age = TextEditingController();
  final ctl_address = TextEditingController();
  final ctl_city = TextEditingController();

  void saveData(BuildContext context) {
    _formKey.currentState.save();

    print(ctl_name.text);
    print(ctl_age.text);
    print(ctl_address.text);
    print(ctl_city.text);
  }

  void nextPage(BuildContext context) {
    setState(() {
      _stepNumber = (_stepNumber + 1) % _totalSteps;
    });
  }

  Column formOneBuilder(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(border: Border.all(color: Colors.blue)),
              width: double.infinity,
              child: Text("STEP 1")),
        ),
        TextFormField(
          controller: ctl_age,
          decoration: const InputDecoration(labelText: 'Step 2 Age'),
        ),
      ],
    );
  }

  Column formTwoBuilder(BuildContext context) {
    final arsEntries = _dataProvider.fetchArsEntries(null);
    final arsLevels = arsEntries.map((e) => e.arsLevel).toList();
    final arsMap =
        HashMap.fromEntries(arsEntries.map((e) => MapEntry(e.arsLevel, e)));

    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(border: Border.all(color: Colors.red)),
            width: double.infinity,
            child: Text("STEP 2"),
          ),
        ),
        MultiSelectFormField(
          elements: arsLevels,
          elementName: (arsLevel) =>
              "${arsMap[arsLevel].name} (${arsLevelName(arsLevel)})",
          initialValue: arsLevels.toSet(),
        ),
      ],
    );
  }

  Column formThreeBuilder(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(border: Border.all(color: Colors.red)),
            width: double.infinity,
            child: Text("STEP 3"),
          ),
        ),
        MultiSelectFormField(
          elements: ChannelCategory.values,
          elementName: (arsLevel) => categoryName(arsLevel),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final form = buildForm(context);

    return PlatformAlertDialog(
      material: (_, __) => MaterialAlertDialogData(scrollable: true),
      content: Stack(
        overflow: Overflow.visible,
        children: [buildForm(context)],
      ),
      actions: [leftButton(), rightButton()],
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

  leftButton() {
    if (_stepNumber == 1) {
      return cancelButton();
    } else {
      return backButton();
    }
  }

  rightButton() {
    if (_stepNumber == _totalSteps) {
      return saveButton();
    } else {
      return continueButton();
    }
  }

  Widget cancelButton() {
    return PlatformButton(
      key: Key("cancel"),
      child: Text(LocaleKeys.actions_cancel.tr()),
      onPressed: () {
        Fimber.i("Cancel pressed");

        Navigator.pop(context);
      },
    );
  }

  Widget saveButton() {
    return PlatformButton(
        key: Key("save"),
        child: Text(LocaleKeys.actions_save.tr()),
        onPressed: () {
          Fimber.i("Save pressed");
          if (submit()) {
            Navigator.pop(context);
          }
        });
  }

  Widget backButton() {
    return PlatformButton(
        key: Key("back"),
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
        key: Key("continue"),
        child: Text(LocaleKeys.actions_continue.tr()),
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
    ctl_address.dispose();
    ctl_age.dispose();
    ctl_city.dispose();
    ctl_name.dispose();

    super.dispose();
  }
}
