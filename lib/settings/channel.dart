import 'dart:collection';

import 'package:easy_localization/easy_localization.dart';
import 'package:fimber/fimber_base.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:mobile/generated/locale_keys.g.dart';
import 'package:mobile/model/category.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';
import 'package:streaming_shared_preferences/src/preference/preference.dart';

class HeadingItem {
  final String heading;

  HeadingItem(this.heading);

  Widget build(BuildContext context) {
    final child = Text(
      heading,
      style: Theme.of(context).textTheme.headline5,
    ).tr();
    return Container(
        alignment: Alignment.topLeft,
        padding: EdgeInsets.all(8.0),
        margin: EdgeInsets.only(top: 8.0, bottom: 2.0),
        child: child);
  }
}

class AlertItem {
  final String message;

  AlertItem(this.message);

  Widget build(BuildContext context) {
    final child = Text(
      message,
      style: Theme.of(context).textTheme.headline6,
    ).tr();
    return Container(
        alignment: Alignment.topLeft,
        padding: EdgeInsets.all(8.0),
        margin: EdgeInsets.only(top: 8.0, bottom: 2.0),
        color: Theme.of(context).focusColor,
        child: child);
  }
}

class ChannelForm extends StatefulWidget {
  final Function(String) _addChannel;

  ChannelForm(this._addChannel);

  @override
  State<StatefulWidget> createState() {
    return _ChannelFormState(_addChannel);
  }
}

class _ChannelFormState extends State<ChannelForm> {
  final Function(String) _addChannel;
  final _formKey = GlobalKey<FormState>();
  bool _useLocation = false;
  String _customLocation;
  List<dynamic> _categories;
  final _textEditingController = TextEditingController();

  Map<String, ChannelCategory> _categoryMap = HashMap();
  List<Map<String, String>> _categoryDisplayMap;

  _ChannelFormState(this._addChannel) {
    List<ChannelCategory> values = ChannelCategory.values;

    values.forEach((element) {
      final name = describeEnum(element);
      _categoryMap[name] = element;
    });

    Iterable<Map<String, String>> map = values.map((category) {
      final name = describeEnum(category);
      final text = Text("model.category.$name").tr().data;
      return {"display": text, "value": name};
    });

    _categoryDisplayMap = map.toList();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(children: [
                CheckboxListTile(
                  title: Text("Device location"),
                  value: _useLocation,
                  onChanged: (value) {
                    Fimber.d("onChanged($value)");
                    setState(() {
                      _useLocation = value;
                    });
                  },
                ),
                Visibility(
                    visible: !_useLocation,
                    child: TextFormField(
                        initialValue: _customLocation,
                        onChanged: (value) {
                          setState(() {
                            _customLocation = value;
                          });
                        }))
              ])),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: MultiSelectFormField(
              autovalidate: false,
              titleText: 'Selected categories',
              validator: (value) {
                if (value == null || value.length == 0) {
                  return 'Please select one or more options';
                }
              },
              dataSource: _categoryDisplayMap,
              textField: 'display',
              valueField: 'value',
              okButtonLabel: 'OK',
              cancelButtonLabel: 'CANCEL',
              // required: true,
              hintText: 'Please choose one or more',
              initialValue: _categories,
              onSaved: (value) {
                if (value == null) return;
                setState(() {
                  _categories = value;
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: RaisedButton(
              child: Text("Add"),
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  _formKey.currentState.save();
                  _addChannel(getEntry().toJson().toString());
                  Navigator.of(context).pop();
                }
              },
            ),
          )
        ],
      ),
      onChanged: () {},
    );
  }

  CategoryEntry getEntry() {
    final categories = _categories.map((value) => _categoryMap[value]).toList();
    return CategoryEntry(this._useLocation ? null : this._customLocation, categories);
  }
}

class CategoryEntry {
  final List<ChannelCategory> categories;
  final String location;

  CategoryEntry(this.location, this.categories);

  Map<String, dynamic> toJson() {
    return {
      'location': location,
      'categories': categories.map((e) => describeEnum(e))
    };
  }
}

class AddChannelDialog extends StatelessWidget {
  final Function(String) addChannel;

  AddChannelDialog(this.addChannel);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Stack(
        overflow: Overflow.visible,
        children: <Widget>[
          Positioned(
            right: -40.0,
            top: -40.0,
            child: InkResponse(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: CircleAvatar(
                child: Icon(Icons.close),
                backgroundColor: Colors.red,
              ),
            ),
          ),
          ChannelForm(addChannel)
        ],
      ),
    );
  }
}

class ChannelSettings extends StatefulWidget {
  final Preference<List<String>> channels;

  ChannelSettings(this.channels);

  @override
  State<StatefulWidget> createState() => _ChannelSettingsState(channels);
}

class _ChannelSettingsState extends State<ChannelSettings> {
  final Preference<List<String>> settings;
  List<String> channels;

  _ChannelSettingsState(this.settings) {
    this.channels = settings.getValue();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = <Widget>[];

    if (channels.isEmpty) {
      children.add(
          AlertItem(LocaleKeys.settings_channel_none_defined).build(context));
    }
    children.add(HeadingItem(LocaleKeys.settings_channel_title).build(context));
    children.add(Divider(color: Theme.of(context).focusColor));

    children.add(
      ListView(
        children: mapChannels(context),
        shrinkWrap: true,
      ),
    );
    if (channels.length < 3) {
      children.add(RaisedButton(
        child: Icon(context.platformIcons.add),
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AddChannelDialog(addChannel);
              });
        },
      ));
    }

    return Container(
      child: ListView(
        children: children,
        shrinkWrap: true,
      ),
    );
  }

  List<Widget> mapChannels(BuildContext context) {
    final elements = <Widget>[];
    for (var entry in channels) {
      elements.add(FlatButton(
          child: Text(entry, style: Theme.of(context).textTheme.headline6),
          onPressed: () => removeChannel(entry)));
      elements.add(Divider(
        color: Theme.of(context).focusColor,
      ));
    }
    return elements;
  }

  void addChannel(String channel) {
    final updatedChannels = List.of(channels);
    updatedChannels.add(channel);
    settings.setValue(updatedChannels);
    setState(() {
      channels = settings.getValue();
    });
  }

  void removeChannel(String channel) {
    final updatedChannels = List.of(channels);
    updatedChannels.removeAt(channels.indexOf(channel));
    setState(() {
      channels = updatedChannels;
    });
  }
}