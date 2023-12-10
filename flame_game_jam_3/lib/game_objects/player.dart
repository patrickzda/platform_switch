import 'dart:math';
import 'dart:ui';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/geometry.dart';
import 'package:flame_game_jam_3/game_objects/goal_block.dart';
import 'package:flame_game_jam_3/game_objects/switch_block.dart';
import 'package:flame_game_jam_3/pages/main_game.dart';

enum JumpState{
  started,
  jumped,
  landed
}

typedef VoidCallback = void Function();

class Player extends RectangleComponent with CollisionCallbacks{
  late Paint playerPaint;
  double worldWidth = 512, worldHeight = 512;
  late double topWorldBound, rightWorldBound, bottomWorldBound, leftWorldBound;
  Vector2 upVector = Vector2(0, -1);
  Vector2 startPosition;
  CollisionDetection collisionDetection;
  List<SwitchBlock> switchBlocks = [];
  void Function() onGameOver, onLevelFinished;

  double gravity = -800, fallGravityMultiplier = 2.5, jumpGravityMultiplier = 1, jumpStrength = 400, movementSpeed = 200;
  Vector2 velocity = Vector2(0, 0);
  JumpState jumpState = JumpState.jumped;

  Player({required this.startPosition, required this.collisionDetection, required this.switchBlocks, required this.onGameOver, required this.onLevelFinished}){
    size = Vector2.all(32);
    position = startPosition;
    anchor = Anchor.center;

    topWorldBound = size.y / 2;
    rightWorldBound = worldWidth - size.x / 2;
    bottomWorldBound = worldHeight - size.y / 2;
    leftWorldBound = size.x / 2;

    playerPaint = Paint();
    playerPaint.color = const Color.fromARGB(255, 32, 164, 243);
    playerPaint.style = PaintingStyle.fill;
    paint = playerPaint;

    add(RectangleHitbox());
  }

  @override
  void update(double dt){
    if(jumpState == JumpState.started){
      velocity = Vector2(velocity.x, (upVector * jumpStrength).y);
      jumpState = JumpState.jumped;
    }

    if(velocity.y >= 0){
      velocity += upVector * gravity * fallGravityMultiplier * dt;
    }else if(jumpState == JumpState.jumped && velocity.y < 0){
      velocity += upVector * gravity * jumpGravityMultiplier * dt;
    }

    position += velocity * dt;

    if(position.y > bottomWorldBound){
      position.y = bottomWorldBound;
      velocity.y = 0;
      jumpState = JumpState.landed;
    }else if(position.y < topWorldBound){
      position.y = topWorldBound;
    }

    if(position.x > rightWorldBound){
      position.x = rightWorldBound;
    }else if(position.x < leftWorldBound){
      position.x = leftWorldBound;
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if(other is PolygonComponent && intersectionPoints.isNotEmpty){
      Vector2 distance = position - other.position;

      if(other.vertices.length == 3){
        onGameOver();
      }

      if(distance.length > 38){
        return;
      }

      if(distance.x.abs() > distance.y.abs()){
        if(distance.x > 0 && velocity.x < 0){
          RaycastResult<ShapeHitbox>? raycastResult = collisionDetection.raycast(Ray2(origin: position, direction: Vector2(-1, 0))) as RaycastResult<ShapeHitbox>?;
          if(raycastResult == null || raycastResult.distance == null || raycastResult.distance! > 33){
            return;
          }

          if(other is SwitchBlock && !other.isCold){
            onGameOver();
          }

          if(other is GoalBlock){
            onLevelFinished();
          }

          velocity.x = 0;
          position.x = other.x + size.x + 0.1;
        }else if(velocity.x > 0){
          RaycastResult<ShapeHitbox>? raycastResult = collisionDetection.raycast(Ray2(origin: position, direction: Vector2(1, 0))) as RaycastResult<ShapeHitbox>?;
          if(raycastResult == null || raycastResult.distance == null || raycastResult.distance! > 33){
            return;
          }

          if(other is SwitchBlock && !other.isCold){
            onGameOver();
          }

          if(other is GoalBlock){
            onLevelFinished();
          }

          velocity.x = 0;
          position.x = other.x - size.x - 0.1;
        }
      }else{
        if(distance.y > 0 && velocity.y < 0){
          RaycastResult<ShapeHitbox>? raycastResult = collisionDetection.raycast(Ray2(origin: position, direction: Vector2(0, -1))) as RaycastResult<ShapeHitbox>?;
          if(raycastResult == null || raycastResult.distance == null || raycastResult.distance! > 33){
            return;
          }

          if(other is SwitchBlock && !other.isCold){
            onGameOver();
          }

          if(other is GoalBlock){
            onLevelFinished();
          }

          velocity.y = 0;
          position.y = other.y + size.y + 0.1;
        }else if(velocity.y > 0){
          RaycastResult<ShapeHitbox>? raycastResult = collisionDetection.raycast(Ray2(origin: position, direction: Vector2(0, 1))) as RaycastResult<ShapeHitbox>?;
          if(raycastResult == null || raycastResult.distance == null || raycastResult.distance! > 33){
            return;
          }

          if(other is SwitchBlock && !other.isCold){
            onGameOver();
          }

          if(other is GoalBlock){
            onLevelFinished();
          }

          jumpState = JumpState.landed;
          velocity.y = 0;
          position.y = other.y - size.y - 0.1;
        }
      }
    }
  }

  void jump(){
    if(jumpState == JumpState.landed){
      jumpState = JumpState.started;
      for(int i = 0; i < switchBlocks.length; i++){
        switchBlocks[i].switchColor();
      }
    }
  }

  void moveRight(){
    velocity.x = movementSpeed;
  }

  void moveLeft(){
    velocity.x = -movementSpeed;
  }

  void stopHorizontalMovement(){
    velocity = Vector2(0, velocity.y);
  }

}