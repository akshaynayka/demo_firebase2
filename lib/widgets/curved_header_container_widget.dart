import '../values/colors.dart';
import 'package:flutter/material.dart';

class CurvedHeaderConyainerWidget extends StatelessWidget {
  const CurvedHeaderConyainerWidget(
      {this.title, this.subTitle, this.textSize = 30, super.key});
  final String? title;
  final String? subTitle;
  final double? textSize;
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Stack(
      children: [
        Container(
          height: 150,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: <Color>[
                Theme.of(context).primaryColor,
                secondGradientColor,
              ],
            ),
          ),
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.only(top: 10.0, left: 20.0),
            child: title == null
                ? null
                : Text(
                    title!,
                    style: TextStyle(color: Colors.white, fontSize: textSize),
                  ),
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          child: Container(
            height: 60,
            width: deviceSize.width,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(100),
              ),
              color: Theme.of(context).canvasColor,
            ),
            alignment: Alignment.bottomLeft,
            child: subTitle == null
                ? null
                : Padding(
                    padding: const EdgeInsets.only(left: 25.0, bottom: 10.0),
                    child: Text(
                      subTitle!,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}
