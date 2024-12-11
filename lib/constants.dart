// ----- STRINGS ------
import 'package:flutter/material.dart';
import 'package:step/palette.dart';

const baseURL = 'https://udd.steps.com.ph/api';
// const baseURL = 'http://143.198.213.49/api';
const loginURL = baseURL + '/login';
const logoutURL = baseURL + '/logout';
const userURL = baseURL + '/user';
const roomsURL = baseURL + '/rooms';
const CommentUrl = baseURL + '/announcements';
const SubmitAssignmentURL = baseURL + '/assignments';
const joinRoomURL = baseURL + '/join';
const NotificationURL = baseURL + '/notifications';
const ReadURL = baseURL + '/read';
const attendURL = baseURL + '/attendance';
const gradesURL = baseURL + '/grades';

// ----- Errors -----
const serverError = 'Server error';
const unauthorized = 'Unauthorized';
const somethingWentWrong = 'Something went wrong, try again!';

// --- input decoration
InputDecoration kInputDecoration(String label) {
  return InputDecoration(
      labelText: label,
      contentPadding: EdgeInsets.all(10),
      border: OutlineInputBorder(
          borderSide: BorderSide(width: 1, color: Colors.black)));
}

// button
TextButton kTextButton(String label, Function onPressed) {
  return TextButton(
    child: Text(
      label,
      style: TextStyle(color: Colors.white),
    ),
    style: ButtonStyle(
        backgroundColor:
            MaterialStateColor.resolveWith((states) => Palette.kToDark),
        padding: MaterialStateProperty.resolveWith(
            (states) => EdgeInsets.symmetric(vertical: 10))),
    onPressed: () => onPressed(),
  );
}
