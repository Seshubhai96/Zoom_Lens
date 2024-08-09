// ignore_for_file: must_be_immutable

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:zoom_lens/src/zoom_magnifier.dart';
import 'package:zoom_lens/src/zoom_touch.dart';

class ZoomImage extends StatefulWidget {
  Widget child;
  ZoomImage({super.key, required this.child});

  @override
  State<ZoomImage> createState() => _ZoomImageState();
}

class _ZoomImageState extends State<ZoomImage> {
  static const double touchBubbleSize = 30;

  Offset? position;
  double? currentBubbleSize;
  bool magnifierVisible = false;
  @override
  void initState() {
    currentBubbleSize = touchBubbleSize;
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.bottom]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          MagnifierBank(
              position: position,
              visible: magnifierVisible,
              child: widget.child),
          TouchBubble(
            position: position,
            bubbleSize: currentBubbleSize,
            onStartDragging: _startDragging,
            onDrag: _drag,
            onEndDragging: _endDragging,
          ),
        ],
      ),
    );
  }

  void _startDragging(Offset newPosition) {
    setState(() {
      magnifierVisible = true;
      position = newPosition;
      currentBubbleSize = touchBubbleSize * 1.5;
    });
  }

  void _drag(Offset newPosition) {
    setState(() {
      position = newPosition;
    });
  }

  void _endDragging() {
    setState(() {
      currentBubbleSize = touchBubbleSize;
      magnifierVisible = false;
    });
  }
}
