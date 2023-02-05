import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

const String title = 'Your\nThings';
const kHomePage = '/homePage';
const kTaskPage = '/taskPage';
const kAddPage = '/addPage';
const kEditPage = '/editPage';
var titleStyle =
    TextStyle(fontSize: 50.0, color: Colors.white, fontWeight: FontWeight.w700);

String dateFormatter(DateTime date) {
  var formatter = DateFormat('dd-MM-yyyy');
  return formatter.format(date);
}
