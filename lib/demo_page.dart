
import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'dart:math' as math;

import 'clipper_page.dart';


class DemoPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return DemoPageState();
  }

}

class DemoPageState extends State<DemoPage> {

  double top = 0;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Material(
      child: Container(
        color: Colors.white,
        width: size.width,height: size.height,
        child: DrawImageItem(),
      ),
    );
  }



  Widget listView(Size size){
    return ListView(
      children: List.generate(30, (index){
        return Container(
          width: size.width,height: size.height/6,
          color: index % 2 == 0 ? Colors.blue : Colors.red,
        );
      }),
    );
  }


}


class DrawImageItem extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return DrawImageItemState();
  }

}

class DrawImageItemState extends State<DrawImageItem> {
  final Image image = Image.asset('assets/lemon.png');

  ui.Image uiImage;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final ImageStream newStream = image.image.resolve(createLocalImageConfiguration(context));
      newStream.addListener(ImageStreamListener((image,_){
        debugPrint('stream ');
        if(image?.image != null){
          debugPrint('stream image');
          uiImage = image.image;
          setState(() {

          });
        }
      }));
    });


  }

  ImageConfiguration createLocalImageConfiguration(BuildContext context, { Size size }) {
    return ImageConfiguration(
      bundle: DefaultAssetBundle.of(context),
      devicePixelRatio: MediaQuery.of(context, nullOk: true)?.devicePixelRatio ?? 1.0,
      locale: Localizations.localeOf(context, nullOk: true),
      textDirection: Directionality.of(context),
      size: size,
      platform: TargetPlatform.android,
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return uiImage == null ?
    Center(child: Text('loading'),)
        : slideViewPort(size);
  }

  double topDis = 0;

  Widget slideViewPort(Size size){
    return GestureDetector(
      onVerticalDragEnd: (endDetails){
        //topDis = 0;
      },
      onVerticalDragUpdate: (updateDetails){
        topDis += updateDetails.delta.dy;
        setState(() {

        });

      },
      child: CustomPaint(
        painter: MyPaint(uiImage,size,topDis),
      ),
    );
  }

}



class MyPaint extends CustomPainter{

  final ui.Image _image;
  final Size size;
  final double widthRatio;
  final double heightRatio;
  ///顶部偏移
  final double topDelta;

  MyPaint(this._image,this.size,this.topDelta)
      : widthRatio = _image.width / size.width,
        heightRatio = _image.height / size.height{
    srcRect= Rect.fromLTWH(0,math.min(topDelta*widthRatio, _image.height.floorToDouble() - (300*widthRatio)),
        size.width * widthRatio, 300 * heightRatio);
    dstRect = Rect.fromLTWH(0,math.min(topDelta, size.height-300), size.width, 300);
  }

  Rect srcRect ;
  Rect dstRect ;
  final Paint myPaint = Paint()..isAntiAlias = true;

  @override
  void paint(Canvas canvas, Size size) {

    canvas.drawImageRect(_image, srcRect, dstRect, myPaint);
  }

  @override
  bool shouldRepaint(MyPaint oldDelegate) {
    // TODO: implement shouldRepaint
    return srcRect != oldDelegate.srcRect || dstRect != oldDelegate.dstRect;
  }

}





























