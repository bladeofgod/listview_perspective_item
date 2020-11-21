
import 'package:flutter/material.dart';


class DemoPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return DemoPageState();
  }

}

class DemoPageState extends State<DemoPage> {

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Material(
      child: Container(
        color: Colors.white,
        width: size.width,height: size.height,
        child: Image.asset('assets/timg.jpg',
          cacheWidth: 400,cacheHeight: 400,
        ),
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


























