import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ReusableDropDown extends StatelessWidget {
  final List<UnitListItem> items;
  final UnitListItem initialValue;
  final Function() onChanged;

  ReusableDropDown(
      {Key? key, required this.onChanged,
      required this.initialValue, required this.items}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 10.0,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 0.0),
        decoration: kDropDownInputDecoration,
        child: getPicker(context),
      ),
    );
  }

  Widget getPicker(BuildContext context) {
    if (Platform.isIOS) {
      return getIosPicker(context);
    } else if (Platform.isAndroid) {
      return getAndroidPicker(context);
    } else {
      return getAndroidPicker(context);
    }
  }

  Widget getAndroidPicker(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton<UnitListItem>(
        // disabledHint: Text(initialValue.displayItem),
        isExpanded: true,
        items: items
            .map((e) => DropdownMenuItem<UnitListItem>(
                value: e, child: Text(e.displayItem)))
            .toList(),
        value: initialValue,
        onChanged: onChanged(),
      ),
    );
  }

  Widget getIosPicker(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Widget picker = CupertinoPicker(
            itemExtent: 35,
            onSelectedItemChanged: onChanged(),
            scrollController: FixedExtentScrollController(
                initialItem: initialValue.value - 1),
            children: items
                .map((e) => DropdownMenuItem<UnitListItem>(
                    value: e, child: Text(e.displayItem)))
                .toList());
        bottomSheet(
          context,
          picker,
          height: MediaQuery.of(context).size.height / 3.5,
        );
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(5.0, 15.0, 5.0, 15.0),
        child: Text(
          initialValue.displayItem,
          textAlign: TextAlign.start,
          // style: kLabelText,
        ),
      ),
    );
  }

  Future<void> bottomSheet(BuildContext context, Widget child,
      {required double height}) {
    return showModalBottomSheet(
        isScrollControlled: false,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(13), topRight: Radius.circular(13))),
        backgroundColor: Colors.white,
        context: context,
        builder: (context) => Container(
            height: height ?? MediaQuery.of(context).size.height / 3,
            child: child));
  }
}

class UnitListItem {
  int value;
  String displayItem;
  UnitListItem({required this.value, required this.displayItem});
}

var kDropDownInputDecoration = BoxDecoration(
  border: Border.all(
    color: Colors.grey,
    style: BorderStyle.solid,
    width: 0.0,
  ),
  borderRadius: BorderRadius.all(Radius.circular(3.0)),
  color: Colors.white,
);

UnitListItem? formatOutput(List<DropdownMenuItem<UnitListItem>> items, value) {
  if (value is int) {
    return items[value].value;
  } else if (value is UnitListItem) {
    return value;
  } else {
    return value; //this condition will never be true
  }
}
