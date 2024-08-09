// ignore_for_file: non_constant_identifier_names

library zoom_lens;

import 'package:flutter/widgets.dart';
import 'package:zoom_lens/src/zoom_image.dart';

Widget ZoomLens({required Widget child}) {
  return ZoomImage(child: child);
}
