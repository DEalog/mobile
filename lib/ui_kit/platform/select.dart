import 'dart:collection';

import 'package:fimber/fimber_base.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class MultiSelectFormField<E> extends FormField<Set<E>> {
  final Iterable<E> elements;
  final Iterable<E> selected;
  final String Function(E) elementName;

  MultiSelectFormField(
      {this.elements,
      this.selected,
      this.elementName,
      Key key,
      Set<E> initialValue,
      FormFieldValidator<Set<E>> validator,
      FormFieldSetter<Set<E>> onSaved})
      : super(
            builder: (FormFieldState<Set<E>> field) {
              void onChangedHandler(Set<E> value) {
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

class MultiSelect<E> extends StatefulWidget {
  final List<E> elements;
  final Iterable<E> selected;
  final String Function(E) elementName;
  final ValueChanged<Set<E>> onChanged;

  MultiSelect({this.elements, this.selected, this.elementName, this.onChanged});

  @override
  State<StatefulWidget> createState() {
    final selected =
        HashSet<E>.from(this.selected != null ? this.selected : []);
    return _MultiSelectState<E>(
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
          label: elementName.call(e));
    }).toList();

    return Column(
        crossAxisAlignment: CrossAxisAlignment.start, children: entries);
  }
}

class PlatformSelectListTile extends PlatformWidgetBase<Widget, Widget> {
  final String label;
  final bool value;
  final void Function() onChanged;

  PlatformSelectListTile({
    this.label,
    this.value,
    this.onChanged,
    Key key,
  }) : super(key: key);

  @override
  createCupertinoWidget(BuildContext context) {
    return GestureDetector(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(this.label),
          Spacer(),
          Container(
            padding: EdgeInsets.all(5.0),
            child: Icon(value ? PlatformIcons(context).checkMark : null),
          )
        ],
      ),
      onTap: onChanged,
    );
  }

  @override
  createMaterialWidget(BuildContext context) {
    var themeData = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(this.label),
        Checkbox(
          value: value,
          onChanged: (e) => onChanged(),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        )
      ],
    );
  }
}
