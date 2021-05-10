
import 'package:better_page_turn/better_page_turn.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    CupertinoApp(
      home: CupertinoPageScaffold(
        child: SafeArea(
          child: MyApp(),
        ),
      ),
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  HorizontalFlipPageTurnController horizontalFlipPageTurnController = HorizontalFlipPageTurnController();
  SliderPageTurnController sliderPageTurnController = SliderPageTurnController();

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Column(
        children: [
          Container(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: LayoutBuilder(builder: (context, constraints) {
                return HorizontalFlipPageTurn(
                  children: [
                    _buildWidget(
                      0,
                      Colors.yellowAccent,
                      horizontalFlipPageTurnController.animToLeftWidget,
                      horizontalFlipPageTurnController.animToRightWidget,
                    ),
                    _buildWidget(
                      1,
                      Colors.purpleAccent,
                      horizontalFlipPageTurnController.animToLeftWidget,
                      horizontalFlipPageTurnController.animToRightWidget,
                    ),
                    _buildWidget(
                      2,
                      Colors.greenAccent,
                      horizontalFlipPageTurnController.animToLeftWidget,
                      horizontalFlipPageTurnController.animToRightWidget,
                    ),
                    _buildWidget(
                      3,
                      Colors.pinkAccent,
                      horizontalFlipPageTurnController.animToLeftWidget,
                      horizontalFlipPageTurnController.animToRightWidget,
                    ),
                  ],
                  cellSize: Size(constraints.maxWidth, 200),
                  controller: horizontalFlipPageTurnController,
                );
              }),
            ),
          ),
          Container(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: LayoutBuilder(builder: (context, constraints) {
                return SliderPageTurn(
                  children: [
                    _buildWidget(
                      0,
                      Colors.yellowAccent,
                      sliderPageTurnController.animToLeftWidget,
                      sliderPageTurnController.animToRightWidget,
                    ),
                    _buildWidget(
                      1,
                      Colors.purpleAccent,
                      sliderPageTurnController.animToLeftWidget,
                      sliderPageTurnController.animToRightWidget,
                    ),
                    _buildWidget(
                      2,
                      Colors.greenAccent,
                      sliderPageTurnController.animToLeftWidget,
                      sliderPageTurnController.animToRightWidget,
                    ),
                    _buildWidget(
                      3,
                      Colors.pinkAccent,
                      sliderPageTurnController.animToLeftWidget,
                      sliderPageTurnController.animToRightWidget,
                    ),
                  ],
                  cellSize: Size(constraints.maxWidth, 200),
                  controller: sliderPageTurnController,
                );
              }),
            ),
          ),
          CupertinoButton(
            child: Text("turn to 0"),
            onPressed: () {
              horizontalFlipPageTurnController.animToPositionWidget(0);
              sliderPageTurnController.animToPositionWidget(0);
            },
          ),
          CupertinoButton(
            child: Text("turn to 3"),
            onPressed: () {
              horizontalFlipPageTurnController.animToPositionWidget(3);
              sliderPageTurnController.animToPositionWidget(3);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildWidget(int position, Color color, VoidCallback leftPressed, VoidCallback rightPressed) {
    return Container(
      color: color,
      padding: EdgeInsets.only(top: 10),
      constraints: BoxConstraints.expand(),
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Align(
            alignment: Alignment.center,
            child: Text(
              "$position",
              style: TextStyle(
                color: Color(0xFF2e282a),
                fontSize: 40.0,
              ),
            ),
          ),
          Positioned(
            left: 10,
            bottom: 10,
            child: CupertinoButton(
              onPressed: leftPressed,
              child: Text(
                "animToLeft",
              ),
            ),
          ),
          Positioned(
            right: 10,
            bottom: 10,
            child: CupertinoButton(
              onPressed: rightPressed,
              child: Text(
                "animToRight",
              ),
            ),
          ),
        ],
      ),
    );
  }
}
