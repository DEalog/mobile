import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

Future<T?> showPlatformModalBottomSheet<T>({
  required BuildContext context,
  double? closeProgressThreshold,
  required WidgetBuilder builder,
  Color? backgroundColor,
  double? elevation,
  ShapeBorder? shape,
  Clip? clipBehavior,
  Color? barrierColor,
  bool bounce = false,
  bool expand = false,
  AnimationController? secondAnimation,
  Curve? animationCurve,
  bool useRootNavigator = false,
  bool isDismissible = true,
  bool enableDrag = true,
  Duration? duration,
}) async {
  if (isMaterial(context)) {
    return showMaterialModalBottomSheet(
      context: context,
      closeProgressThreshold: closeProgressThreshold,
      builder: builder,
      backgroundColor: backgroundColor,
      elevation: elevation,
      expand: expand,
      secondAnimation: secondAnimation,
      animationCurve: animationCurve,
    );
  } else if (isCupertino(context)) {
    return showCupertinoModalBottomSheet(
      context: context,
      closeProgressThreshold: closeProgressThreshold,
      builder: builder,
      backgroundColor: backgroundColor,
      elevation: elevation,
      expand: expand,
      secondAnimation: secondAnimation,
      animationCurve: animationCurve,
    );
  }
}
