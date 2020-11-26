import 'package:easy_localization/easy_localization.dart';
import 'package:fimber/fimber_base.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:mobile/generated/locale_keys.g.dart';
import 'package:mobile/model/region.dart';
import 'package:mobile/model/channel.dart';
import 'package:mobile/model/gis.dart';
import 'package:mobile/ui_kit/channel.dart';
import 'package:mobile/ui_kit/platform/select.dart';
import 'package:mobile/ui_kit/platform/switch.dart';
import 'package:mobile/ui_kit/settings.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

class Model<T> {
  Channel _value;

  Model(Channel initialValue) : _value = initialValue;

  Channel get() => _value;

  void update(Channel Function(Channel) updater) {
    final before = _value;
    _value = updater.call(_value);
    Fimber.i("Model update: ${before.location} -> ${_value.location}");
  }
}

class ChannelForm extends StatefulWidget {
  final Function(Channel) onUpdate;
  final Model<Channel> model;
  final GlobalKey<FormState> formKey;

  ChannelForm({this.onUpdate, Channel initialValue, this.formKey})
      : model = Model(initialValue != null ? initialValue : Channel.empty());

  @override
  State<StatefulWidget> createState() {
    return _ChannelFormState(
        onUpdate: onUpdate, model: model, formKey: formKey);
  }

  void submit() {
    Fimber.i("Submit pressed");
    if (formKey.currentState.validate()) {
      Fimber.i("Form validates");
      formKey.currentState.save();
      onUpdate(model.get());
    } else {
      Fimber.i("Form does not validate");
    }
  }
}

class _ChannelFormState extends State<ChannelForm> {
  final Function(Channel) onUpdate;
  final Model<Channel> model;
  final GlobalKey<FormState> _formKey;

  _ChannelFormState({this.onUpdate, this.model, GlobalKey<FormState> formKey})
      : _formKey = formKey != null ? formKey : GlobalKey<FormState>();

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
                Text(
                  LocaleKeys.model_location.tr(),
                ),
                PlatformSwitchListTile(
                  key: Key("use_location"),
                  label: LocaleKeys.settings_use_location,
                  value: useLocation(),
                  onChanged: (bool value) {
                    setState(() {
                      Fimber.i("Update useLocation: $value");
                      model.update((channel) => Channel(
                          value ? null : Location.empty(),
                          channel.levels,
                          channel.categories));
                    });
                  },
                ),
                (useLocation()
                    ? Icon(PlatformIcons(context).locationSolid)
                    : buildTextForm(context))
              ])),
          Padding(
            padding: EdgeInsets.all(4.0),
            child: Column(children: [
              Text(LocaleKeys.model_category.tr(),
                  style: Theme.of(context).textTheme.caption),
              MultiSelectFormField<ChannelCategory>(
                elements: ChannelCategory.values,
                initialValue: model.get().categories,
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
                    model.update((channel) => Channel(channel.location,
                        Set.of(RegionLevel.values), value.toSet()));
                  });
                },
              )
            ]),
          ),
        ],
      ),
      onChanged: () {},
    );
  }

  bool useLocation() => model.get().location == null;

  Widget buildTextForm(BuildContext context) {
    Function(String) onChanged = (value) {
      setState(() {
        model.update((channel) {
          var location = channel.location;
          return Channel(Location(value, location.coordinate, location.region),
              channel.levels, channel.categories);
        });
      });
    };

    final key = Key("location_input");
    if (isMaterial(context)) {
      return TextFormField(
          key: key,
          initialValue: model.get().location.name,
          onChanged: onChanged);
    } else {
      final _controller =
          new TextEditingController(text: model.get().location.name);
      return PlatformTextField(
        key: key,
        controller: _controller,
        onChanged: onChanged,
      );
    }
  }

  mapLocation(String customLocation) {
    Fimber.i("mapLocation: $customLocation");
    return Location(customLocation, Coordinate(0, 0), Region.empty());
  }
}

class ChannelDialog extends StatelessWidget {
  final Function(Channel) onUpdate;
  final String submitText;
  final Channel initialValue;

  ChannelDialog({this.onUpdate, this.submitText, this.initialValue});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    final channelForm = ChannelForm(
      onUpdate: onUpdate,
      initialValue: initialValue,
      formKey: formKey,
    );
    return PlatformAlertDialog(
      material: (_, __) => MaterialAlertDialogData(scrollable: true),
      content: Stack(
        overflow: Overflow.visible,
        children: [channelForm],
      ),
      actions: [
        PlatformButton(
          key: Key("cancel_channel"),
          child: Text(LocaleKeys.actions_cancel.tr()),
          onPressed: () {
            Fimber.i("Cancel pressed");

            Navigator.pop(context);
          },
        ),
        PlatformButton(
            key: Key("submit_channel"),
            child: Text(submitText),
            onPressed: () {
              Fimber.i("Submit pressed");
              channelForm.submit();
              Navigator.pop(context);
            }),
      ],
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
        key: Key("add_channel"),
        child: Icon(context.platformIcons.add),
        materialFlat: (_, __) => MaterialFlatButtonData(),
        onPressed: () {
          showPlatformDialog(
              context: context,
              builder: (BuildContext context) {
                return ChannelDialog(
                    onUpdate: addChannel,
                    submitText: LocaleKeys.actions_add.tr());
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
    for (var i = 0; i < channels.length; i++) {
      var channel = channels[i];
      elements.add(Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
              child: PlatformButton(
                  key: Key("edit_channel_$i"),
                  materialFlat: (_, __) => MaterialFlatButtonData(),
                  child: ChannelView(channel),
                  padding: EdgeInsets.all(2.0),
                  onPressed: () => editChannel(i))),
          PlatformButton(
              key: Key("delete_channel_$i"),
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
    update(updatedChannels);
  }

  void editChannel(int index) {
    showPlatformDialog(
        context: context,
        builder: (BuildContext context) {
          return ChannelDialog(
              onUpdate: (channel) {
                final updatedChannels = List.of(channels);
                updatedChannels[index] = channel;
                update(updatedChannels);
              },
              submitText: LocaleKeys.actions_update.tr(),
              initialValue: channels[index]);
        });
  }

  void removeChannel(Channel channel) {
    final updatedChannels = List.of(channels);
    updatedChannels.removeAt(channels.indexOf(channel));
    update(updatedChannels);
  }

  void update(List<Channel> updatedChannels) {
    settings.setValue(updatedChannels);
    setState(() {
      channels = updatedChannels;
    });
  }
}
