import 'package:cartzen/core/constants.dart';
import 'package:flutter/material.dart';

class CurvedAppBar extends StatelessWidget {
  const CurvedAppBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: CustomAppBar(),
      child: Container(
        height: 200,
        width: double.infinity,
        color: themeColor,
        child: Padding(
          padding: const EdgeInsets.only(top: padding * 2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Icon(
                Icons.person,
                color: Colors.black,
                size: 50,
              ),
              Text(
                "Profile",
                style: TextStyle(
                  fontSize: 40,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class CustomAppBar extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    final double xScaling = size.width / 360;
    final double yScaling = size.height / 141;
    path.lineTo(102.515 * xScaling, 120.478 * yScaling);
    path.cubicTo(
      223.94 * xScaling,
      66.9138 * yScaling,
      322.794 * xScaling,
      103.867 * yScaling,
      360.271 * xScaling,
      126.185 * yScaling,
    );
    path.cubicTo(
      360.271 * xScaling,
      126.185 * yScaling,
      360.271 * xScaling,
      0 * yScaling,
      360.271 * xScaling,
      0 * yScaling,
    );
    path.cubicTo(
      360.271 * xScaling,
      0 * yScaling,
      -0.0000305176 * xScaling,
      0 * yScaling,
      -0.0000305176 * xScaling,
      0 * yScaling,
    );
    path.cubicTo(
      -0.0000305176 * xScaling,
      0 * yScaling,
      0 * xScaling,
      138.819 * yScaling,
      0 * xScaling,
      138.819 * yScaling,
    );
    path.cubicTo(
      23.2431 * xScaling,
      143.967 * yScaling,
      56.3983 * xScaling,
      140.822 * yScaling,
      102.515 * xScaling,
      120.478 * yScaling,
    );
    path.cubicTo(
      102.515 * xScaling,
      120.478 * yScaling,
      102.515 * xScaling,
      120.478 * yScaling,
      102.515 * xScaling,
      120.478 * yScaling,
    );
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
