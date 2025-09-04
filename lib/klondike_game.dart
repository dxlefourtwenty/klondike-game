import 'dart:math';
import 'package:flame/game.dart';
import 'package:flame/flame.dart';
import 'package:flame/components.dart';
import 'components/Stock.dart';
import 'components/Waste.dart';
import 'components/Foundation.dart';
import 'components/Pile.dart';
import 'card.dart';

class KlondikeGame extends FlameGame {
  // dimensions of a card and gap between
  static const double cardWidth = 1000.0;
  static const double cardHeight = 1400.0;
  static const double cardGap = 175.0;
  static const double cardRadius = 100.0;
  static final Vector2 cardSize = Vector2(cardWidth, cardHeight);

  // loads the sprite images into the game
  @override
  Future<void> onLoad() async {
    await Flame.images.load('klondike-sprites.png');

    // set the component positions within the 'World'
    final stock = Stock()
      ..size = cardSize
      ..position = Vector2(cardGap, cardGap);
    final waste = Waste()
      ..size = cardSize
      ..position = Vector2(cardWidth + 2 * cardGap, cardGap);
    final foundations = List.generate(
      4,
        (i) => Foundation()
          ..size = cardSize
          ..position =
              Vector2((i + 3) * (cardWidth + cardGap) + cardGap, cardGap),
    );
    final piles = List.generate(
      7,
        (i) => Pile()
          ..size = cardSize
          ..position =
              Vector2(
                cardGap + i * (cardWidth + cardGap),
                cardHeight + 2 * cardGap,
              ),
    );

    // add the created components to the 'world'
    world.add(stock);
    world.add(waste);
    world.addAll(foundations);
    world.addAll(piles);

    // use FlameGame's camera object to look at the world
    camera.viewfinder.visibleGameSize =
        Vector2(cardWidth * 7 + cardGap * 8, 4 * cardHeight + 3 * cardGap);
    camera.viewfinder.position = Vector2(cardWidth * 3.5 + cardGap * 4, 0);
    camera.viewfinder.anchor = Anchor.topCenter;

    // add cards into game
    final random = Random();
    for (var i = 0; i < 7; i++) {
      for (var j = 0; j < 4; j++) {
        final card = Card(random.nextInt(13) + 1, random.nextInt(4))
            ..position = Vector2(100 + i * 1150, 100 + j * 1500)
            ..addToParent(world);
        if (random.nextDouble() < 0.9) { // flip face up w/ 90% probability
          card.flip();
        }
      }
    }
  }

  // helper function to extract a sprite from the sprite sheet
  static Sprite klondikeSprite(double x, double y, double width, double height) {
    return Sprite(
      Flame.images.fromCache('klondike-sprites.png'),
      srcPosition: Vector2(x, y),
      srcSize: Vector2(width, height)
    );
  }
}