import 'dart:math';

import 'package:flutter/material.dart';

class HorizontalFlipPageTurn extends StatefulWidget {
  HorizontalFlipPageTurn({
    Key? key,
    required this.children,
    required this.controller,
    required this.cellSize,
  }) : super(key: key);

  final List<Widget> children;

  final Size cellSize;

  final HorizontalFlipPageTurnController controller;

  @override
  HorizontalFlipPageTurnState createState() => HorizontalFlipPageTurnState();
}

class HorizontalFlipPageTurnState extends State<HorizontalFlipPageTurn> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  int position = 0;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(vsync: this);
    _animation = _animationController.drive(Tween(begin: 0.0, end: widget.children.length - 1));

    widget.controller._toLeftCallback = (duration) {
      if (position > 0) {
        position = position - 1;
        _animationController.animateTo(position / (widget.children.length - 1), duration: duration);
      }
    };

    widget.controller._toRightCallback = (duration) {
      if (position < widget.children.length - 1) {
        position = position + 1;
        _animationController.animateTo(position / (widget.children.length - 1), duration: duration);
      }
    };

    widget.controller._toPositionCallback = (position, duration) {
      if (position >= 0 && position <= widget.children.length - 1) {
        _animationController.animateTo(position / (widget.children.length - 1),
            duration: duration * (position - this.position).abs());
        this.position = position;
      }
    };
  }

  @override
  void didUpdateWidget(covariant HorizontalFlipPageTurn oldWidget) {
    super.didUpdateWidget(oldWidget);
    _animation = _animationController.drive(Tween(begin: 0.0, end: widget.children.length - 1));
    if (this.position > widget.children.length - 1) {
      this.position = widget.children.length - 1;
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final angle = (_animation.value - _animation.value ~/ 1) * pi;
        final maskOpacity = _animation.value - _animation.value ~/ 1;
        final cellWidth = widget.cellSize.width;
        final cellHeight = widget.cellSize.height;

        return Container(
          width: cellWidth,
          height: cellHeight,
          child: Stack(
            children: <Widget>[
              Offstage(
                offstage: !(angle >= pi / 2),
                child: Container(
                  width: cellWidth,
                  height: cellHeight,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: ClipRect(
                      child: Align(
                        widthFactor: 0.5,
                        alignment: Alignment.centerLeft,
                        child: getLeftWidget(),
                      ),
                    ),
                  ),
                ),
              ),
              Offstage(
                offstage: angle == 0,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    width: cellWidth / 2,
                    height: cellHeight,
                    child: OverflowBox(
                      minWidth: cellWidth / 2,
                      maxWidth: cellWidth,
                      child: ClipRect(
                        child: Align(
                          widthFactor: 0.5,
                          alignment: Alignment.centerRight,
                          child: getRightWidget(),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Offstage(
                offstage: !(angle >= pi / 2),
                child: Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.0001)
                    ..rotateY(angle),
                  child: Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.rotationY(pi),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        width: cellWidth / 2,
                        height: cellHeight,
                        child: OverflowBox(
                          minWidth: cellWidth / 2,
                          maxWidth: cellWidth,
                          child: ClipRect(
                            child: Align(
                              widthFactor: 0.5,
                              alignment: Alignment.centerLeft,
                              child: Stack(
                                children: [
                                  getRightWidget() ?? SizedBox(),
                                  if (getRightWidget() != null)
                                    Offstage(
                                      offstage: 1-maskOpacity == 0,
                                      child: Container(
                                        color: Colors.black12.withOpacity(1-maskOpacity),
                                        constraints: BoxConstraints.expand(),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Offstage(
                offstage: angle >= pi / 2,
                child: Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.0001)
                    ..rotateY(angle),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      width: angle >= pi / 2 ? 0.0 : cellWidth / 2,
                      height: angle >= pi / 2 ? 0.0 : cellHeight,
                      child: OverflowBox(
                        minWidth: cellWidth / 2,
                        maxWidth: cellWidth,
                        child: ClipRect(
                          child: Align(
                            widthFactor: 0.5,
                            alignment: Alignment.centerRight,
                            child: Stack(
                              children: [
                                getLeftWidget(),
                                Offstage(
                                  offstage: maskOpacity == 0,
                                  child: Container(
                                    color: Colors.black12.withOpacity(maskOpacity),
                                    constraints: BoxConstraints.expand(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Offstage(
                offstage: angle >= pi / 2,
                child: Container(
                  width: cellWidth,
                  height: cellHeight,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: ClipRect(
                      child: Align(
                        widthFactor: 0.5,
                        alignment: Alignment.centerLeft,
                        child: getLeftWidget(),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget getLeftWidget() {
    return widget.children[_animation.value.toInt()];
  }

  Widget? getRightWidget() {
    if (_animation.value.toInt() < widget.children.length - 1) {
      return widget.children[_animation.value.toInt() + 1];
    } else {
      return null;
    }
  }
}

class HorizontalFlipPageTurnController {
  ValueChanged<Duration>? _toLeftCallback;

  ValueChanged<Duration>? _toRightCallback;

  void Function(int, Duration)? _toPositionCallback;

  void animToLeftWidget({Duration duration = const Duration(milliseconds: 350)}) {
    if (_toLeftCallback != null) {
      _toLeftCallback!(duration);
    }
  }

  void animToRightWidget({Duration duration = const Duration(milliseconds: 350)}) {
    if (_toRightCallback != null) {
      _toRightCallback!(duration);
    }
  }

  void animToPositionWidget(int position, {Duration duration = const Duration(milliseconds: 350)}) {
    if (_toPositionCallback != null) {
      _toPositionCallback!(position, duration);
    }
  }
}
