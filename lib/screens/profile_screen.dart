import 'package:flutter/material.dart';
import 'package:step/constants.dart';
import 'package:step/models/response_model.dart';
import 'package:step/models/user_model.dart';
import 'package:step/screens/login_screen.dart';
import 'package:step/services/user_service.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  User? user; // store user details
  bool loading = true; // to show/hide progress indicator
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // get user details from API
  void getUser() async {
    ApiResponse response = await getUserDetail();
    if (response.error == null) {
      // if there is no error
      setState(() {
        user = response.data as User; // update the user object
        loading = false; // hide the progress indicator
      });
    } else if (response.error == unauthorized) {
      // if token is not valid
      logout().then((value) => {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => Login()),
                (route) =>
                    false) // redirect to login page and remove other pages from the stack
          });
    } else {
      // if there is any other error
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${response.error}')));
    }
  }

  @override
  void initState() {
    getUser(); // fetch user details on page load
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return loading // if the data is still being fetched
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 110,
                  height: 110,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(60),
                      image: DecorationImage(
                          image: NetworkImage('${user!.avatar}'),
                          fit: BoxFit.cover)),
                ),
                SizedBox(height: 8),
                Text(
                  '${user!.email}',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17),
                ),
                SizedBox(height: 10),
                Text(
                  '${user!.name}',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17),
                ),
              ],
            ),
          );
  }
}
