import 'package:flare_flutter/flare.dart';
import 'package:flare_dart/math/mat2d.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flare_flutter/flare_controller.dart';
import 'package:flare_flutter/provider/asset_flare.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MobileGraphic extends StatefulWidget {
  @override
  _MobileGraphicState createState() => _MobileGraphicState();
}

class _MobileGraphicState extends State<MobileGraphic> with FlareController {
  final asset = AssetFlare(bundle: rootBundle, name: "assets/m_grapic.flr");
  List<String> animations = ['Intro', 'UI', 'Responsive', 'Laptop'];
  int currentAnimation = 0;
  bool reverse = false;

  double _time = 0.0;

  ActorAnimation _grapic;
  FlutterActorArtboard _artboard;

  @override
  void initState() {
    super.initState();
  }

  @override
  bool advance(FlutterActorArtboard artboard, double elapsed) {
    _time += elapsed * (reverse ? -1 : 1);

    if (_time >= _grapic.duration && !reverse) {
      _time = _grapic.duration;
      return true;
    } else if (_time <= 0) {
      return true;
    }

    _grapic.apply(_time % _grapic.duration, artboard, 1);
    return true;
  }

  @override
  void initialize(FlutterActorArtboard artboard) {
    _artboard = artboard;
    _grapic = _artboard.getAnimation('Intro');
  }

  @override
  void setViewTransform(Mat2D viewTransform) {}

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 500,
          child: FlareActor("assets/m_grapic.flr",
              snapToEnd: false, alignment: Alignment.center, controller: this),
        ),
        ListView.builder(
          shrinkWrap: true,
          itemCount: animations.length,
          itemBuilder: (context, index) {
            return FlatButton(
              onPressed: () {
                setState(() {
                  if (index == currentAnimation - 1) {
                    reverse = true;
                  } else {
                    reverse = false;
                    _grapic = _artboard.getAnimation(animations[index]);
                    _time = 0.0;
                  }
                  currentAnimation = index;
                });
              },
              child: Text(index.toString()),
            );
          },
        ),
      ],
    );
  }
}
