import 'package:flutter/material.dart';
import 'package:step/models/user_model.dart';

class Profile extends StatefulWidget {
  final User? user;
  const Profile({Key? key, required this.user}) : super(key: key);
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 110,
            height: 110,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(60),
                image: DecorationImage(
                    image: NetworkImage('${widget.user!.avatar}'),
                    fit: BoxFit.cover)),
          ),
          SizedBox(height: 8),
          Text(
            '${widget.user!.email}',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17),
          ),
          SizedBox(height: 10),
          Text(
            '${widget.user!.name}',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17),
          ),
        ],
      ),
    );
  }
}
