// ignore_for_file: prefer_const_constructors_in_immutables, depend_on_referenced_packages, library_private_types_in_public_api

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:zoom_lens/src/zoom_magnifier_painter.dart';

class MagnifierBank extends StatefulWidget {
  MagnifierBank(
      {super.key, required this.child,
      required this.position,
      this.visible = true,
      this.scale = 1.5,
      this.size = const Size(150, 150)})
      // ignore: unnecessary_null_comparison
      : assert(child != null);

  final Widget child;
  final Offset? position;
  final bool visible;
  final double scale;
  final Size size;

  @override
  _MagnifierBankState createState() => _MagnifierBankState();
}

class _MagnifierBankState extends State<MagnifierBank> {
  late Size _magnifierSize;
  double? _scale;
  late Matrix4 _matrix;

  @override
  void initState() {
    _magnifierSize = widget.size;
    _scale = widget.scale;
    _calculateMatrix();

    super.initState();
  }

  @override
  void didUpdateWidget(MagnifierBank oldWidget) {
    super.didUpdateWidget(oldWidget);

    _calculateMatrix();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (widget.visible && widget.position != null) _getMagnifier(context)
      ],
    );
  }

  void _calculateMatrix() {
    if (widget.position == null) {
      return;
    }

    setState(() {
      double newX = widget.position!.dx - (_magnifierSize.width / 3 / _scale!);
      double newY = widget.position!.dy - (_magnifierSize.height / 3 / _scale!);

      if (_bubbleCrossesMagnifier()) {
        final box = context.findRenderObject() as RenderBox;
        newX -= ((box.size.width - _magnifierSize.width) / _scale!);
      }

      final Matrix4 updatedMatrix = Matrix4.identity()
        ..scale(_scale, _scale)
        ..translate(-newX, -newY);

      _matrix = updatedMatrix;
    });
  }

  Widget _getMagnifier(BuildContext context) {
    return Align(
      alignment: _getAlignment(),
      child: ClipOval(
        child: BackdropFilter(
          filter: ImageFilter.matrix(_matrix.storage),
          child: CustomPaint(
            painter: MagnifierPainter(
                color: Theme.of(context).colorScheme.secondary),
            size: _magnifierSize,
          ),
        ),
      ),
    );
  }

  Alignment _getAlignment() {
    if (_bubbleCrossesMagnifier()) {
      return Alignment.topRight;
    }
    return Alignment.topLeft;
  }

  bool _bubbleCrossesMagnifier() =>
      widget.position!.dx < widget.size.width / 2 &&
      widget.position!.dy < widget.size.height / 2;
}
