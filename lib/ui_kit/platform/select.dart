import 'dart:collection';

import 'package:fimber/fimber_base.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class MultiSelectFormField<T> extends FormField<Set<T>> {
  final Iterable<T> elements;
  final Iterable<T> selected;
  final String Function(T) elementName;

  MultiSelectFormField(
      {this.elements,
      this.selected,
      this.elementName,
      Key key,
      Set<T> initialValue,
      FormFieldValidator<Set<T>> validator,
      FormFieldSetter<Set<T>> onSaved})
      : super(
            builder: (FormFieldState<Set<T>> field) {
              void onChangedHandler(Set<T> value) {
                Fimber.i("Multiselect changed $value");
                field.didChange(value);
              }

              return MultiSelect(
                elements: elements,
                selected: selected,
                elementName: elementName,
                onChanged: onChangedHandler,
              );
            },
            key: key,
            initialValue: initialValue,
            validator: validator,
            onSaved: onSaved);
}

class MultiSelect<T> extends StatefulWidget {
  final List<T> elements;
  final Iterable<T> selected;
  final String Function(T) elementName;
  final ValueChanged<Set<T>> onChanged;

  MultiSelect({this.elements, this.selected, this.elementName, this.onChanged});

  @override
  State<StatefulWidget> createState() {
    final selected =
        HashSet<T>.from(this.selected != null ? this.selected : []);
    return _MultiSelectState<T>(
        this.elements, selected.toSet(), this.elementName, this.onChanged);
  }
}

class _MultiSelectState<E> extends State {
  final Iterable<E> elements;
  final Set<E> selected;
  final ValueChanged<Set<E>> onChanged;
  final String Function(E) elementName;
  final bool required = false;

  _MultiSelectState(
      this.elements, this.selected, this.elementName, this.onChanged);

  @override
  Widget build(BuildContext context) {
    var entries = elements.map((e) {
      final isSelected = selected.contains(e);
      return PlatformSelectListTile(
          value: isSelected,
          onChanged: () {
            setState(() {
              if (isSelected) {
                selected.remove(e);
              } else {
                selected.add(e);
              }
            });
            onChanged.call(selected);
          },
          label: elementName.call(e),
          keyId: describeEnum(e));
    }).toList();

    return Column(
        crossAxisAlignment: CrossAxisAlignment.start, children: entries);
  }
}

class PlatformSelectListTile extends PlatformWidgetBase<Widget, Widget> {
  final String label;
  final String keyId;
  final bool value;
  final void Function() onChanged;

  PlatformSelectListTile({
    this.label,
    this.value,
    this.onChanged,
    this.keyId,
    Key key,
  }) : super(key: key);

  @override
  createCupertinoWidget(BuildContext context) {
    var iconTheme = IconTheme.of(context);
    return Container(
        padding: EdgeInsets.only(top: 4.0, bottom: 4.0),
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(this.label),
              Spacer(),
              Container(
                padding: EdgeInsets.all(4.0),
                child: value
                    ? Icon(
                        CupertinoIcons.check_mark,
                        key: getStateKey(),
                      )
                    : Container(
                        width: iconTheme.size,
                        height: iconTheme.size,
                        key: getStateKey(),
                      ),
              )
            ],
          ),
          onTap: () {
            Fimber.i("Tap Gesture detected");
            onChanged();
          },
        ));
  }

  @override
  createMaterialWidget(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(this.label),
        Checkbox(
          key: getStateKey(),
          value: value,
          onChanged: (e) => onChanged(),
        )
      ],
    );
  }

  Key getStateKey() {
    return Key("state_$keyId");
  }
}
