import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RaisedGradientButton extends StatelessWidget {
  final Widget child;
  final Gradient gradient;
  final BorderRadius borderRadius;
  final border;
  final width;
  final height;
  final Function() onPressed;

  const RaisedGradientButton({
    this.child,
    this.gradient = const LinearGradient(
        colors: <Color>[Color(0xFFF0F0F0), Color(0xFFF0F0F0)]),
    this.borderRadius = const BorderRadius.all(Radius.circular(50)),
    this.border,
    this.width = 200.0,
    this.height,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: gradient,
        border: border,
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            offset: Offset(0.0, 2.0),
            blurRadius: 4.0,
          ),
        ],
        borderRadius: borderRadius,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
            onTap: onPressed,
            child: Center(
              child: child,
            )),
      ),
    );
  }
}
