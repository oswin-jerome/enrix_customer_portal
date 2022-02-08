import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:blur/blur.dart';

class CustomLoader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Blur(
      blur: 1,
      blurColor: Colors.white,
      colorOpacity: 00.6,
      child: Container(),
      overlay: Container(
        height: 55,
        child: RiveAnimation.asset(
          "assets/ani.riv",
          fit: BoxFit.contain,
          controllers: [
            SpeedController("ani1", speedMultiplier: 1.5),
          ],
        ),
      ),
    );
  }
}

class SpeedController extends SimpleAnimation {
  final double speedMultiplier;

  SpeedController(
    String animationName, {
    double mix = 1,
    this.speedMultiplier = 1,
  }) : super(animationName, mix: mix);

  @override
  void apply(RuntimeArtboard artboard, double elapsedSeconds) {
    if (instance == null || !instance!.keepGoing) {
      isActive = false;
    }
    instance!
      ..animation.apply(instance!.time, coreContext: artboard, mix: mix)
      ..advance(elapsedSeconds * speedMultiplier);
  }
}
