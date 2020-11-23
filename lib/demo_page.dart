
import 'package:flutter/cupertino.dart';
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

  final ScrollController controller = ScrollController();

  double top = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // controller.addListener(() {
    //   //debugPrint('${controller.position.pixels}');
    //   if(key.currentContext != null){
    //     RenderBox renderBox = key.currentContext.findRenderObject() as RenderBox;
    //     debugPrint('${renderBox.localToGlobal(Offset.zero)}');
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Material(
      child: Container(
        color: Colors.white,
        width: size.width,height: size.height,
        child: listView(size),
        // DrawImageItem(size: size,),
      ),
    );
  }



  Widget listView(Size size){
    return ListView(
      padding: EdgeInsets.all(0),
      key: key,
      controller: controller,
      children: List.generate(30, (index){
        return (index == 10 || index == 5) ? specialOne(size): Container(
          width: size.width,height: size.height/6,
          color: index % 2 == 0 ? Colors.blue : Colors.red,
        );
      }),
    );
  }

  final GlobalKey key = GlobalKey();

  Widget specialOne(Size size){
    return Container(
      width: size.width,height: size.height/6,
      child: DrawImageItem(size: size, controller: controller,viewPortHeight: size.height/6,
        parentKey: key,),
    );
  }


}


class DrawImageItem extends StatefulWidget{
  final Size size;
  final ScrollController controller;
  final double viewPortHeight;
  final GlobalKey parentKey;

  const DrawImageItem({Key key, @required this.size,@required this.controller,this.viewPortHeight
  ,this.parentKey}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return DrawImageItemState(size,controller,viewPortHeight,parentKey);
  }

}

class DrawImageItemState extends State<DrawImageItem> {
  final Image image = Image.asset('assets/lemon.png');
  final ScrollController controller;
  final double viewPortHeight;
  final GlobalKey parentKey;

  final Size size ;

  ui.Image uiImage;
  DrawImageItemState(this.size,this.controller,this.viewPortHeight,this.parentKey);

  ///屏幕/图片
  double widthRatio;
  double heightRatio;
  ///image
  Rect srcRect ;
  ///view
  Rect dstRect ;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final ImageStream newStream = image.image.resolve(createLocalImageConfiguration(context));
      newStream.addListener(ImageStreamListener((image,_){
        if(image?.image != null){
          uiImage = image.image;
          widthRatio = uiImage.width / size.width;
          heightRatio = uiImage.height / size.height;
          initRect();
          initListener();
          setState(() {

          });
        }
      }));
    });




  }
  void initRect(){
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    Offset globalPos = renderBox.localToGlobal(Offset.zero,ancestor: parentKey.currentContext.findRenderObject());
    debugPrint('$globalPos');
    srcRect = Rect.fromLTWH(
        globalPos.dx,
        math.min(globalPos.dy*heightRatio, uiImage.height.floorToDouble() - (viewPortHeight*widthRatio)),
        size.width * widthRatio,
        viewPortHeight * heightRatio);
    dstRect = Rect.fromLTWH(
        0,
        0,
        //math.min(globalPos.dy, size.height-viewPortHeight),
        size.width,
        viewPortHeight);
  }






  void initListener(){
    controller.addListener(() {
      if(mounted && context != null){
        final RenderBox renderBox = context.findRenderObject() as RenderBox;
        final Offset dstOffset = renderBox.localToGlobal(Offset.zero,ancestor: parentKey.currentContext.findRenderObject());
        //debugPrint('$heightRatio -- $dstOffset');
        final Offset realOffset = dstOffset.dy <= 0
            ? Offset(dstOffset.dx,0)
             : (dstOffset.dy * heightRatio) >= uiImage.height
                ? Offset(dstOffset.dx,uiImage.height.toDouble()) :dstOffset;
        srcRect = Rect.fromLTWH(
            realOffset.dx,
            math.min(realOffset.dy*heightRatio, uiImage.height.floorToDouble() - (viewPortHeight*widthRatio)),
            size.width * widthRatio,
            viewPortHeight * heightRatio);
        //dstRect = dstRect.shift(realOffset);
        setState(() {

        });
      }
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

    return uiImage == null ?
    Center(child: Text('loading'),)
        :  CustomPaint(
      painter: MyPaint(uiImage,srcRect,dstRect),
    );
    //slideViewPort(size);
  }



//  Widget slideViewPort(Size size){
//    return GestureDetector(
//      onVerticalDragEnd: (endDetails){
//        //topDis = 0;
//      },
//      onVerticalDragUpdate: (updateDetails){
////        topDis += updateDetails.delta.dy;
////        topDis = math.min(0, topDis);
////        setState(() {
////
////        });
//
//      },
//      child: CustomPaint(
//        painter: MyPaint(uiImage,size,topDis,300),
//      ),
//    );
//  }

}



class MyPaint extends CustomPainter{
  final ui.Image _image;
  final Rect srcRect ;
  final Rect dstRect ;
  MyPaint(this._image, this.srcRect, this.dstRect);


//  final double viewPortHeight;
//  final ui.Image _image;
//  final Size size;
//  final double widthRatio;
//  final double heightRatio;
//  ///顶部偏移
//  final double topDelta;

//  MyPaint(this._image,this.size,this.topDelta,this.viewPortHeight)
//      : widthRatio = _image.width / size.width,
//        heightRatio = _image.height / size.height{
//    srcRect= Rect.fromLTWH(0,math.min(topDelta*widthRatio, _image.height.floorToDouble() - (viewPortHeight*widthRatio)),
//        size.width * widthRatio, viewPortHeight * heightRatio);
//    dstRect = Rect.fromLTWH(0,math.min(topDelta, size.height-viewPortHeight), size.width, viewPortHeight);
//  }


  final Paint myPaint = Paint()..isAntiAlias = true;



  @override
  void paint(Canvas canvas, Size size) {
    //debugPrint('$srcRect');
    canvas.drawImageRect(_image, srcRect, dstRect, myPaint);
  }

  @override
  bool shouldRepaint(MyPaint oldDelegate) {
    // TODO: implement shouldRepaint
    return srcRect != oldDelegate.srcRect || dstRect != oldDelegate.dstRect;
  }

}





























