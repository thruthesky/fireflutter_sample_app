import 'package:flutter/material.dart';

class DisplayPhotos extends StatelessWidget {
  DisplayPhotos({
    Key key,
    @required this.document,
  }) : super(key: key);

  final Map<String, dynamic> document;
  @override
  Widget build(BuildContext context) {
    /// Display uploaded images.
    if (document['files'] == null) {
      return Container();
    } else {
      return Column(
        children: [
          for (String url in document['files']) Image.network(url),
        ],
      );
    }
  }
}
