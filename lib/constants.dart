import 'package:climbing_gym_app/models/RouteColor.dart';
import 'package:flutter/material.dart';

// custom colors

const Color polyGreen = Color(0xFF00bb56);
const Color polyDark = Color(0xFF121212);
const Color polyRed = Color(0xFFbb0000);
const Color polyGray = Color(0xFF414141);
const Color lightGray = Color(0xFF808080);

// custom text styles

const TextStyle headerText =
    TextStyle(color: polyDark, fontWeight: FontWeight.w800, fontSize: 22);

const TextStyle headerTextWhite =
    TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 22);

const TextStyle subHeaderText =
    TextStyle(color: polyDark, fontWeight: FontWeight.w800, fontSize: 18);

const TextStyle subHeaderTextWhite =
    TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 18);

const TextStyle subHeaderTextWhite600 =
    TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 18);

const TextStyle defaultText =
    TextStyle(color: polyDark, fontWeight: FontWeight.w500, fontSize: 16);

const TextStyle defaultTextWhite =
    TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 16);

const TextStyle smallTextWhite600 =
    TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14);

const TextStyle defaultTextWhite700 =
    TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16);

// custom button styles
ButtonStyle polyGreenButton = ButtonStyle(
    backgroundColor: MaterialStateProperty.all(polyGreen),
    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
      new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(24.0)),
    ));
