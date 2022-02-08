import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ActivityImageViewer extends StatelessWidget {
  final String url;
  ActivityImageViewer({required this.url});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Hero(
          tag: url,
          child: PhotoView(
            tightMode: true,
            backgroundDecoration:
                BoxDecoration(color: Theme.of(context).scaffoldBackgroundColor),
            imageProvider: NetworkImage(url),
          ),
        ),
      ),
    );
  }
}
