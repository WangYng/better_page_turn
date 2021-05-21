import 'package:flutter/material.dart';

class SliderPageTurn extends StatefulWidget {
  SliderPageTurn({
    Key? key,
    required this.children,
    required this.controller,
    required this.cellSize,
  }) : super(key: key);

  final List<Widget> children;

  final Size cellSize;

  final SliderPageTurnController controller;

  @override
  SliderPageTurnState createState() => SliderPageTurnState();
}

class SliderPageTurnState extends State<SliderPageTurn> with SingleTickerProviderStateMixin {
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
  void didUpdateWidget(covariant SliderPageTurn oldWidget) {
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
        final cellWidth = widget.cellSize.width;
        final cellHeight = widget.cellSize.height;

        final translateX = (_animation.value - _animation.value ~/ 1) * -cellWidth;
        final translateY = (_animation.value - _animation.value ~/ 1) * -cellHeight * 0.8;
        final scale = (_animation.value - _animation.value ~/ 1) * 0.1 + 0.9;

        return Container(
          color: Colors.transparent,
          width: cellWidth,
          height: cellHeight,
          child: Stack(
            children: <Widget>[
              Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()..scale(scale, scale),
                child: getRightWidget(),
              ),
              Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()..translate(translateX, translateY),
                child: getLeftWidget(),
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

class SliderPageTurnController {
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
