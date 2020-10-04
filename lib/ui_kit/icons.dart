import 'package:flutter/cupertino.dart';

mixin ExtendedCupertinoIcons implements CupertinoIcons {
  static const IconData empty = IconData(0x20,
      fontFamily: CupertinoIcons.iconFont,
      fontPackage: CupertinoIcons.iconFontPackage,
      matchTextDirection: true);
}
