import 'package:cupertino_list_tile/cupertino_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class PlatformListTile extends PlatformWidgetBase {
  final title;

  PlatformListTile({
    this.title,
    key,
  }) : super(key: key);

  @override
  Widget createCupertinoWidget(BuildContext context) {
    return CupertinoListTile(
      title: this.title,
    );
  }

  @override
  Widget createMaterialWidget(BuildContext context) {
    return ListTile(
      title: this.title,
    );
  }
}
