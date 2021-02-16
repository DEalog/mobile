import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:flutter_typeahead/cupertino_flutter_typeahead.dart';

typedef FutureOr<Iterable<T>> SuggestionsCallback<T>(String pattern);
typedef Widget ItemBuilder<T>(BuildContext context, T itemData);
typedef void SuggestionSelectionCallback<T>(T suggestion);
typedef Widget ErrorBuilder(BuildContext context, Object error);

typedef AnimationTransitionBuilder(
    BuildContext context, Widget child, AnimationController controller);

class PlatformTypeAhead extends PlatformWidgetBase<Widget, Widget> {
  final String initialValue;
  final bool getImmediateSuggestions;
  final bool enabled;
  final AutovalidateMode autovalidateMode;
  final FormFieldSetter<String> onSaved;
  final FormFieldValidator<String> validator;
  final ErrorBuilder errorBuilder;
  final WidgetBuilder noItemsFoundBuilder;
  final WidgetBuilder loadingBuilder;
  final Duration debounceDuration;
  final SuggestionsBoxDecoration suggestionsBoxDecoration;
  final SuggestionsBoxController suggestionsBoxController;
  final SuggestionSelectionCallback onSuggestionSelected;
  final ItemBuilder itemBuilder;
  final SuggestionsCallback suggestionsCallback;
  final double suggestionsBoxVerticalOffset;
  final TextFieldConfiguration textFieldConfiguration;
  final CupertinoTextFieldConfiguration cupertinoTextFieldConfiguration;
  final AnimationTransitionBuilder transitionBuilder;
  final Duration animationDuration;
  final double animationStart;
  final AxisDirection direction;
  final bool hideOnLoading;
  final bool hideOnEmpty;
  final bool hideOnError;
  final bool hideSuggestionsOnKeyboardHide;
  final bool keepSuggestionsOnLoading;
  final bool keepSuggestionsOnSuggestionSelected;
  final bool autoFlipDirection;
  final bool hideKeyboard;

  PlatformTypeAhead({
    Key key,
    this.textFieldConfiguration,
    this.cupertinoTextFieldConfiguration,
    this.animationDuration,
    this.animationStart,
    this.autoFlipDirection,
    this.autovalidateMode,
    this.debounceDuration,
    this.direction,
    this.enabled,
    this.errorBuilder,
    this.getImmediateSuggestions,
    this.hideKeyboard,
    this.hideOnEmpty = false,
    this.hideOnError,
    this.hideOnLoading,
    this.hideSuggestionsOnKeyboardHide,
    this.initialValue,
    @required this.itemBuilder,
    this.keepSuggestionsOnLoading,
    this.keepSuggestionsOnSuggestionSelected,
    this.loadingBuilder,
    this.noItemsFoundBuilder,
    this.onSaved,
    @required this.onSuggestionSelected,
    this.suggestionsBoxController,
    this.suggestionsBoxDecoration,
    this.suggestionsBoxVerticalOffset,
    @required this.suggestionsCallback,
    this.transitionBuilder,
    this.validator,
  }) : super(key: key);

  @override
  Widget createCupertinoWidget(BuildContext context) {
    // TODO: implement createCupertinoWidget
    return CupertinoTypeAheadFormField(
      key: _toggleKey(),
      textFieldConfiguration: this.cupertinoTextFieldConfiguration,
      itemBuilder: this.itemBuilder,
      onSuggestionSelected: this.onSuggestionSelected,
      suggestionsCallback: this.suggestionsCallback,
      validator: this.validator,
      hideOnEmpty: this.hideOnEmpty,
      autovalidateMode: this.autovalidateMode,
      onSaved: this.onSaved,
    );
  }

  @override
  Widget createMaterialWidget(BuildContext context) {
    // TODO: implement createMaterialWidget
    return TypeAheadFormField(
      key: _toggleKey(),
      textFieldConfiguration: this.textFieldConfiguration,
      itemBuilder: this.itemBuilder,
      onSuggestionSelected: this.onSuggestionSelected,
      suggestionsCallback: this.suggestionsCallback,
      validator: this.validator,
      autovalidateMode: this.autovalidateMode,
      hideOnEmpty: this.hideKeyboard,
      onSaved: this.onSaved,
    );
  }

  Key _toggleKey() {
    final keyBase = (key as ValueKey).value;
    return key != null ? Key("${keyBase}_toggle") : null;
  }
}
