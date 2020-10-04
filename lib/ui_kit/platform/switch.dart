import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class PlatformSwitchListTile extends PlatformWidgetBase<Widget, Widget> {
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  PlatformSwitchListTile({
    this.label,
    this.value,
    this.onChanged,
    Key key,
  }) : super(key: key);

  @override
  createCupertinoWidget(BuildContext context) {
    return _wrap(
        CupertinoSwitch(key: _toggleKey(), value: value, onChanged: onChanged));
  }

  @override
  createMaterialWidget(BuildContext context) {
    return _wrap(Switch(key: _toggleKey(), value: value, onChanged: onChanged));
  }

  _wrap(Widget child) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [Text(this.label).tr(), child],
    );
  }

  Key _toggleKey() {
    final keyBase = (key as ValueKey).value;
    return key != null ? Key("${keyBase}_toggle") : null;
  }
}
