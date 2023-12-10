import 'package:flame/game.dart';
import 'package:flame_game_jam_3/level.dart';
import 'package:flame_game_jam_3/pages/main_game.dart';
import 'package:flame_game_jam_3/pages/main_page.dart';
import 'package:flutter/material.dart';

void main(){
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: SizedBox(
            width: 512,
            height: 512,
            child: MainPage()
          ),
        ),
      )
    )
  );
}