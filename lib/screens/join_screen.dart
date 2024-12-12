import 'package:flutter/material.dart';
import 'package:step/constants.dart';
import 'package:step/models/response_model.dart';
import 'package:step/services/join_service.dart';

class JoinRoomForm extends StatefulWidget {
  JoinRoomForm({Key? key}) : super(key: key);

  @override
  _JoinRoomFormState createState() => _JoinRoomFormState();
}

class _JoinRoomFormState extends State<JoinRoomForm> {
  final _formKey = GlobalKey<FormState>();
  String roomKey = '';

  Future<void> _joinRoom() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      ApiResponse response = await joinRoom(roomKey);

      if (response.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${response.error}'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${response.data}'),
          ),
        );
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        elevation: 0,
        title: new Text(
          'Join Room',
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(32),
          children: [
            Text('Ask your teacher for the class code, then enter it here.'),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              decoration: kInputDecoration('Room Key'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a room key';
                }
                return null;
              },
              onSaved: (value) {
                roomKey = value!;
              },
            ),
            ElevatedButton(
              onPressed: _joinRoom,
              child: Text('OK'),
            ),
          ],
        ),
      ),
    );
  }
}
