import 'package:flame/components.dart';

//0: Empty, 1: Basic Block, 2: Switch Block (cold on start), 3: Switch Block (hot on start), 4: Goal Block, 5: Spike Block

class Level{
  Vector2 playerStartPosition;
  List<List<int>> levelData;

  Level({required this.playerStartPosition, required this.levelData});

  Vector2 indexToVector2(int x, int y){
    return Vector2(y * 32 + 16, x * 32 + 16);
  }
}