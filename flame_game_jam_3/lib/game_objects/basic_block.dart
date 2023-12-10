import 'dart:ui';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class BasicBlock extends RectangleComponent{
  BasicBlock({required Vector2 blockPosition}){
    size = Vector2.all(32);

    Paint blockPaint = Paint();
    blockPaint.color = Colors.black;
    blockPaint.style = PaintingStyle.fill;
    paint = blockPaint;

    position = blockPosition;
    anchor = Anchor.center;
    add(RectangleHitbox());
  }
}