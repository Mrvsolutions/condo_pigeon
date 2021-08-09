import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class BgImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue.withOpacity(0.9),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0,0, 0, 80),
        child: Align(
          alignment: Alignment.center,
          child: Image.asset(
            "assets/bg_img.png",
           // fit: BoxFit.fitWidth,
            color: Colors.blue.withOpacity(0.9),
            colorBlendMode: BlendMode.darken,
          ),
        ),
      ),
    );
  }
}
