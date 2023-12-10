import 'package:flame/game.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flame_game_jam_3/page_transition.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../level.dart';
import '../levels.dart';
import 'main_game.dart';

enum Screen{
  menu,
  game,
  levelFinished
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late PageTransition pageTransition;
  Screen currentScreen = Screen.menu;
  int currentLevelIndex = 0;
  bool isGameOver = false;

  @override
  void initState() {
    pageTransition = PageTransition(
      onMiddleState: (){
        if(currentScreen == Screen.game){
          if(!isGameOver){
            currentLevelIndex++;
            if(currentLevelIndex >= Levels.levelData.length){
              setState(() {
                currentScreen = Screen.menu;
                currentLevelIndex = 0;
              });
            }else{
              setState(() {
                currentScreen = Screen.game;
              });
            }
          }else{
            setState(() {
              isGameOver = false;
              currentScreen = Screen.game;
            });
          }
        }else if(currentScreen == Screen.menu){
          setState(() {
            currentScreen = Screen.game;
            currentLevelIndex = 0;
          });
        }
      },
    );

    WidgetsBinding.instance.addPostFrameCallback((_){
      FlameAudio.bgm.initialize();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        currentScreen == Screen.menu ? MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: (){
              if(!FlameAudio.bgm.isPlaying){
                try{
                  FlameAudio.bgm.play("background_music.wav", volume: 0.5);
                }catch(e){
                  print(e);
                }
              }
              pageTransition.startTransition();
            },
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              alignment: Alignment.center,
              child: Animate(
                onComplete: (AnimationController controller){
                  controller.repeat(reverse: true);
                },
                effects: const [
                  FadeEffect(
                    duration: Duration(milliseconds: 1000),
                    curve: Curves.easeIn,
                  )
                ],
                child: Image.asset(
                  "assets/images/play_button.png",
                  scale: 3,
                ),
              ),
            ),
          ),
        ) : GameWidget(
          game: MainGame(
            level: Levels.levelData[currentLevelIndex],
            onGameOver: (){
              isGameOver = true;
              pageTransition.startTransition();
            },
            onLevelFinished: (){
              pageTransition.startTransition();
            }
          ),
        ),
        pageTransition
      ],
    );
  }
}
