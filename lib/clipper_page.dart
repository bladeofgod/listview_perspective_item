

import 'package:flutter/material.dart';

class ClipperWidget extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return ClipperWidgetState();
  }

}

class ClipperWidgetState extends State<ClipperWidget> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onVerticalDragUpdate: vUpdate,
      onVerticalDragEnd: vEnd,
      child: Stack(
        children: [
          Positioned(
            top: topDis,
            child: ClipPath(
              clipper: Clipper(topDis),
              child: Container(
                width: size.width,height: size.height,
                child: Image.asset('assets/lemon.png',),
              ),
            ),
          )
        ],
      ),
    );
  }

  double topDis = 0;
  void vUpdate(DragUpdateDetails updateDetails){
    topDis += updateDetails.delta.dy;
    setState(() {

    });
  }
  void vEnd(DragEndDetails endDetails){

  }
}


class Clipper extends CustomClipper<Path>{
  final double top ;

  Clipper(this.top);
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.addRect(Rect.fromLTWH(0, top, size.height, 300));
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip
    return true;
  }

}

















