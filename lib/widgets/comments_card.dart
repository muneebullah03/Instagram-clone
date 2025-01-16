import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CommentsCard extends StatefulWidget {
  final snap;
  const CommentsCard({super.key, required this.snap});

  @override
  State<CommentsCard> createState() => _CommentsCardState();
}

class _CommentsCardState extends State<CommentsCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundImage:
                MemoryImage(base64Decode(widget.snap['profilePic'])),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                      text: TextSpan(children: [
                    TextSpan(
                        text: widget.snap['name'],
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    TextSpan(
                      text: widget.snap['text'],
                    ),
                  ])),
                  Padding(
                    padding: EdgeInsets.only(top: 4),
                    child: Text(
                      DateFormat.yMMMd()
                          .format(widget.snap['datePublished'].toDate()),
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 4),
            child: Icon(
              Icons.favorite_border,
              size: 16,
            ),
          ),
        ],
      ),
    );
  }
}
