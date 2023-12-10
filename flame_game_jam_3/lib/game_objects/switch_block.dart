import 'dart:ui';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class SwitchBlock extends RectangleComponent{
  late Paint coldPaint, hotPaint;
  bool isCold;

  SwitchBlock({required Vector2 blockPosition, required this.isCold}){
    size = Vector2.all(32);

    coldPaint = Paint();
    coldPaint.color = const Color.fromARGB(255, 32, 164, 243);
    coldPaint.style = PaintingStyle.fill;

    hotPaint = Paint();
    hotPaint.color = const Color.fromARGB(255, 216, 17, 89);
    hotPaint.style = PaintingStyle.fill;

    if(isCold){
      paint = coldPaint;
    }else{
      paint = hotPaint;
    }

    position = blockPosition;
    anchor = Anchor.center;
    add(RectangleHitbox());
  }

  void switchColor(){
    isCold = !isCold;
    if(isCold){
      paint = coldPaint;
    }else{
      paint = hotPaint;
    }
  }

}