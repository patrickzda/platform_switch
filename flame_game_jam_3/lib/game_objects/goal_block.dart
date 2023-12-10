import 'dart:ui';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class GoalBlock extends RectangleComponent{
  GoalBlock({required Vector2 blockPosition}){
    size = Vector2.all(32);

    Paint blockPaint = Paint();
    blockPaint.color = const Color.fromARGB(255, 0, 175, 84);
    blockPaint.style = PaintingStyle.fill;
    paint = blockPaint;

    position = blockPosition;
    anchor = Anchor.center;
    add(RectangleHitbox());
  }
}