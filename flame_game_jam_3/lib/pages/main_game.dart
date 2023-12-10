import 'dart:async';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flame_game_jam_3/game_objects/basic_block.dart';
import 'package:flame_game_jam_3/game_objects/goal_block.dart';
import 'package:flame_game_jam_3/game_objects/player.dart';
import 'package:flame_game_jam_3/game_objects/switch_block.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../level.dart';

typedef VoidCallback = void Function();

class MainGame extends FlameGame with KeyboardEvents, HasCollisionDetection{
  late Player player;
  Level level;
  void Function() onGameOver, onLevelFinished;
  bool isGameOver = false, isLevelFinished = false;

  MainGame({required this.level, required this.onGameOver, required this.onLevelFinished});

  @override
  Color backgroundColor() {
    return Colors.white;
  }

  @override
  FutureOr<void> onLoad() async{
    super.onLoad();

    List<SwitchBlock> switchBlocks = [];

    for(int x = 0; x < 16; x++){
      for(int y = 0; y < 16; y++){
        if(level.levelData[x][y] == 1){
          add(BasicBlock(blockPosition: level.indexToVector2(x, y)));
        }else if(level.levelData[x][y] == 2){
          SwitchBlock currentSwitchBlock = SwitchBlock(blockPosition: level.indexToVector2(x, y), isCold: true);
          switchBlocks.add(currentSwitchBlock);
          add(currentSwitchBlock);
        }else if(level.levelData[x][y] == 3){
          SwitchBlock currentSwitchBlock = SwitchBlock(blockPosition: level.indexToVector2(x, y), isCold: false);
          switchBlocks.add(currentSwitchBlock);
          add(currentSwitchBlock);
        }else if(level.levelData[x][y] == 4){
          add(GoalBlock(blockPosition: level.indexToVector2(x, y)));
        }else if(level.levelData[x][y] == 5){
          Paint blackPaint = Paint();
          blackPaint.color = Colors.black;
          blackPaint.style = PaintingStyle.fill;
          Vector2 centerPosition = level.indexToVector2(x, y);

          PolygonComponent spikeBlock = PolygonComponent(
            [Vector2(centerPosition.x - 16, centerPosition.y + 16), Vector2(centerPosition.x + 16, centerPosition.y + 16), Vector2(centerPosition.x, centerPosition.y)],
            paint: blackPaint,
            anchor: Anchor.center,
            position: Vector2(centerPosition.x, centerPosition.y + 8),
            size: Vector2(32, 16),
            children: [RectangleHitbox()]
          );
          add(spikeBlock);
        }
      }
    }

    player = Player(
      startPosition: level.playerStartPosition,
      collisionDetection: collisionDetection,
      switchBlocks: switchBlocks,
      onGameOver: (){
        if(!isGameOver){
          isGameOver = true;
          FlameAudio.bgm.pause();
          FlameAudio.play("game_over_sound.wav").then((_){
            FlameAudio.bgm.resume();
          });
          onGameOver();
        }
      },
      onLevelFinished: (){
        if(!isLevelFinished){
          isLevelFinished = true;
          FlameAudio.bgm.pause();
          FlameAudio.play("level_finished_sound.wav").then((_){
            FlameAudio.bgm.resume();
          });
          onLevelFinished();
        }
      }
    );
    add(player);
  }

  @override
  void update(double dt) {
    super.update(dt);
    player.update(dt);
  }

  @override
  KeyEventResult onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    if(event is RawKeyDownEvent && (keysPressed.contains(LogicalKeyboardKey.arrowUp) || keysPressed.contains(LogicalKeyboardKey.space)) && !event.repeat){
      player.jump();
    }

    if(keysPressed.contains(LogicalKeyboardKey.arrowRight)){
      player.moveRight();
      return KeyEventResult.handled;
    }
    if(keysPressed.contains(LogicalKeyboardKey.arrowLeft)){
      player.moveLeft();
      return KeyEventResult.handled;
    }

    player.stopHorizontalMovement();
    return KeyEventResult.handled;
  }
}