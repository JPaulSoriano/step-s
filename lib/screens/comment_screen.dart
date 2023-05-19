import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:step/constants.dart';
import 'package:step/models/comment_model.dart';
import 'package:step/models/response_model.dart';
import 'package:step/screens/login_screen.dart';
import 'package:step/services/comment_service.dart';
import 'package:step/services/user_service.dart';

class CommentScreen extends StatefulWidget {
  final int? announcementID;

  CommentScreen({this.announcementID});

  @override
  _CommentScreenState createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  List<dynamic> _commentsList = [];
  bool _loading = true;
  int userId = 0;
  TextEditingController _txtCommentController = TextEditingController();

  Future<void> _getComments() async {
    userId = await getUserId();
    ApiResponse response = await getComments(widget.announcementID ?? 0);

    if (response.error == null) {
      setState(() {
        _commentsList = response.data as List<dynamic>;
        _loading = _loading ? !_loading : _loading;
      });
    } else if (response.error == unauthorized) {
      logout().then((value) => {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => Login()),
                (route) => false)
          });
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${response.error}')));
    }
  }

  void _createComment() async {
    ApiResponse response = await createComment(
        widget.announcementID ?? 0, _txtCommentController.text);

    if (response.error == null) {
      _txtCommentController.clear();
      _getComments();
    } else if (response.error == unauthorized) {
      logout().then((value) => {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => Login()),
                (route) => false)
          });
    } else {
      setState(() {
        _loading = false;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${response.error}')));
    }
  }

  @override
  void initState() {
    _getComments();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('Class Comments'),
      ),
      body: _loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(children: [
              Expanded(
                  child: RefreshIndicator(
                      onRefresh: () {
                        return _getComments();
                      },
                      child: _commentsList.isEmpty
                          ? Center(child: Text('No Comments'))
                          : ListView.builder(
                              itemCount: _commentsList.length,
                              itemBuilder: (BuildContext context, int index) {
                                Comment comment = _commentsList[index];
                                return Container(
                                  padding: EdgeInsets.all(10),
                                  width: MediaQuery.of(context).size.width,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                width: 30,
                                                height: 30,
                                                decoration: BoxDecoration(
                                                  image: comment.user!.avatar !=
                                                          null
                                                      ? DecorationImage(
                                                          image: CachedNetworkImageProvider(
                                                              '${comment.user!.avatar}'),
                                                          fit: BoxFit.cover)
                                                      : null,
                                                ),
                                                child: comment.user?.avatar ==
                                                        null
                                                    ? Center(
                                                        child: Text(
                                                          '${comment.user?.name?[0]}',
                                                          style: TextStyle(
                                                              fontSize: 20.0),
                                                        ),
                                                      )
                                                    : null,
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                '${comment.user!.name}',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 16),
                                              ),
                                              Text(
                                                '${DateFormat.yMMMMd().format(DateTime.parse(comment.created!))}',
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.grey),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Container(
                                        margin:
                                            const EdgeInsets.only(left: 40.0),
                                        child: Text('${comment.body}'),
                                      )
                                    ],
                                  ),
                                );
                              }))),
              Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border(
                      top: BorderSide(color: Colors.black26, width: 0.5)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        decoration: kInputDecoration('Comment'),
                        controller: _txtCommentController,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.send),
                      onPressed: () {
                        if (_txtCommentController.text.isNotEmpty) {
                          setState(() {
                            _loading = true;
                          });

                          _createComment();
                        }
                      },
                    )
                  ],
                ),
              )
            ]),
    );
  }
}
