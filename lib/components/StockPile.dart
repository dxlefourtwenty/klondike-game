import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import '../klondike_game.dart';
import '../card.dart';
import 'WastePile.dart';

class StockPile extends PositionComponent with TapCallbacks {
  StockPile({super.position}) : super(size: KlondikeGame.cardSize);

  // which cards are currently placed onto this pile. The first card is in
  // the list at the bottom, the last card is on top
  final List<Card> _cards = [];

  // stores the provided card into the internal list
  void acquireCard(Card card) {
    assert(!card.isFaceUp);
    card.position = position;
    card.priority = _cards.length;
    _cards.add(card);
  }

  // top 3 cards to be turned face up and moved to waste pile
  @override
  void onTapUp(TapUpEvent event) {
    final wastePile = parent!.firstChild<WastePile>()!;

    for (var i = 0; i < 3; i++) {
      if (_cards.isNotEmpty) {
        wastePile.removeAllCards().reversed.forEach((card) {
          card.flip();
          acquireCard(card);
          });
      } else {
        for (var i = 0; i < 3; i++) {
          final card = _cards.removeLast();
          card.flip();
          wastePile.acquireCard(card);
        }
      }
    }
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRRect(KlondikeGame.cardRRect, _borderPaint);
    canvas.drawCircle(
      Offset(width / 2, height / 2),
      KlondikeGame.cardWidth * 0.3,
      _circlePaint,
    );
  }

  final _borderPaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 10
    ..color = const Color(0xFF3F5B5D);
  final _circlePaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 100
    ..color = const Color(0x883F5B5D);
}