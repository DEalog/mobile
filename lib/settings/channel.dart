import 'package:easy_localization/easy_localization.dart';
import 'package:fimber/fimber_base.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:mobile/generated/locale_keys.g.dart';
import 'package:mobile/model/channel.dart';
import 'package:mobile/ui_kit/channel.dart';
import 'package:mobile/ui_kit/platform/select.dart';
import 'package:mobile/ui_kit/platform/switch.dart';
import 'package:mobile/ui_kit/settings.dart';
import 'package:streaming_shared_preferences/src/preference/preference.dart';

class ChannelForm extends StatefulWidget {
  final Function(Channel) _addChannel;

  ChannelForm(this._addChannel);

  @override
  State<StatefulWidget> createState() {
    return _ChannelFormState(_addChannel);
  }
}

class _ChannelFormState extends State<ChannelForm> {
  final Function(Channel) _addChannel;
  final _formKey = GlobalKey<FormState>();
  bool _useLocation = true;
  String _customLocation;
  Set<ChannelCategory> _categories;

  _ChannelFormState(this._addChannel);

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
              padding: EdgeInsets.all(5.0),
              child: Column(children: [
                Text(LocaleKeys.model_location,
                        style: Theme.of(context).textTheme.caption)
                    .tr(),
                PlatformSwitchListTile(
                  label: LocaleKeys.settings_use_location,
                  value: _useLocation,
                  onChanged: (bool value) {
                    setState(() {
                      Fimber.i("useLocation: $value");
                      _useLocation = value;
                    });
                  },
                ),
                (_useLocation
                    ? Icon(PlatformIcons(context).locationSolid)
                    : buildTextForm(context))
              ])),
          Padding(
            padding: EdgeInsets.all(5.0),
            child: Column(children: [
              Text(LocaleKeys.model_category,
                      style: Theme.of(context).textTheme.caption)
                  .tr(),
              MultiSelectFormField<ChannelCategory>(
                elements: ChannelCategory.values,
                selected: _categories,
                elementName: categoryName,
                validator: (value) {
                  Fimber.i("Validate Categories: $value");
                  if (value == null || value.length == 0) {
                    return 'Please select one or more options';
                  }
                  return null;
                },
                onSaved: (value) {
                  Fimber.i("Categories saved: $value");
                  if (value == null) return;
                  setState(() {
                    _categories = value;
                  });
                },
              )
            ]),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: PlatformButton(
              child: Text("Add"),
              onPressed: () {
                Fimber.i("Add pressed");
                if (_formKey.currentState.validate()) {
                  Fimber.i("Form validates");
                  _formKey.currentState.save();
                  _addChannel(buildResult());
                  Navigator.of(context).pop();
                } else {
                  Fimber.i("Form does not validate");
                }
              },
            ),
          )
        ],
      ),
      onChanged: () {},
    );
  }

  Widget buildTextForm(BuildContext context) {
    Function(String) onChanged = (value) {
      setState(() {
        _customLocation = value;
      });
    };

    if (isMaterial(context)) {
      return TextFormField(initialValue: _customLocation, onChanged: onChanged);
    } else {
      final _controller = new TextEditingController(text: _customLocation);
      return PlatformTextField(
        controller: _controller,
        onChanged: onChanged,
      );
    }
  }

  Channel buildResult() {
    return Channel(this._useLocation ? null : mapLocation(_customLocation),
        _categories.toList());
  }

  mapLocation(String customLocation) {
    Fimber.i("mapLocation: $customLocation");
    return Location(customLocation, 0.0, 0.0);
  }
}

class AddChannelDialog extends StatelessWidget {
  final Function(Channel) addChannel;

  AddChannelDialog(this.addChannel);

  @override
  Widget build(BuildContext context) {
    return PlatformAlertDialog(
      material: (_, __) => MaterialAlertDialogData(scrollable: true),
      content: Stack(
        overflow: Overflow.visible,
        children: [ChannelForm(addChannel)],
      ),
    );
  }
}

class ChannelSettings extends StatefulWidget {
  final Preference<List<Channel>> channels;

  ChannelSettings(this.channels);

  @override
  State<StatefulWidget> createState() => _ChannelSettingsState(channels);
}

class _ChannelSettingsState extends State<ChannelSettings> {
  final Preference<List<Channel>> settings;
  List<Channel> channels;

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
      Column(
        children: mapChannels(context),
      ),
    );
    if (channels.length < 3) {
      children.add(PlatformButton(
        child: Icon(context.platformIcons.add),
        materialFlat: (_, __) => MaterialFlatButtonData(),
        onPressed: () {
          showPlatformDialog(
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
    for (var channel in channels) {
      elements.add(Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(child: ChannelView(channel)),
          PlatformButton(
              materialFlat: (_, __) => MaterialFlatButtonData(),
              child: Icon(context.platformIcons.delete),
              padding: EdgeInsets.all(2.0),
              onPressed: () => removeChannel(channel))
        ],
      ));
      elements.add(Divider(
        color: Theme.of(context).focusColor,
        height: 4.0,
      ));
    }
    return elements;
  }

  void addChannel(Channel channel) {
    final updatedChannels = List.of(channels);
    updatedChannels.add(channel);
    settings.setValue(updatedChannels);
    setState(() {
      channels = updatedChannels;
    });
  }

  void removeChannel(Channel channel) {
    final updatedChannels = List.of(channels);
    updatedChannels.removeAt(channels.indexOf(channel));
    settings.setValue(updatedChannels);
    setState(() {
      channels = updatedChannels;
    });
  }
}
