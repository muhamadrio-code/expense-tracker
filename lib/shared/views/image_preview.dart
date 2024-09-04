import 'dart:io';

import 'package:flutter/material.dart';

class ImagePreview extends StatefulWidget {
  const ImagePreview(
      {super.key, required this.images, required this.startIndex});

  final List<String> images;

  final int startIndex;

  @override
  State<ImagePreview> createState() => _ImagePreviewState();
}

class _ImagePreviewState extends State<ImagePreview> {
  late PageController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PageController(initialPage: widget.startIndex);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Preview"),
      ),
      body: PageView.builder(
          controller: _controller,
          itemCount: widget.images.length,
          itemBuilder: (context, index) {
            return Hero(
                tag: "hero image",
                child: SizedBox(
                  width: double.infinity,
                  height: double.infinity,
                  child: Image.file(File(widget.images[index])),
                ));
          }),
    );
  }
}
