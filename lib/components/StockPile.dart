import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import '../klondike_game.dart';
import 'card.dart';
import 'Pile.dart';
import 'WastePile.dart';

class StockPile extends PositionComponent
    with TapCallbacks, HasGameReference<KlondikeGame> implements Pile {
  StockPile({super.position}) : super(size: KlondikeGame.cardSize);

  // which cards are currently placed onto this pile. The first card is in
  // the list at the bottom, the last card is on top
  final List<Card> _cards = [];

  //#region Pile API

  // stores the provided card into the internal list
  void acquireCard(Card card) {
    assert(card.isFaceDown);
    card.position = position;
    card.priority = _cards.length;
    _cards.add(card);
    card.pile = this;
  }

  // top 3 cards to be turned face up and moved to waste pile
  void handleTapUp(Card card) {
    final wastePile = parent!.firstChild<WastePile>()!;
    if (_cards.isEmpty) {
      assert(card.isBaseCard, 'Stock Pile is empty, but no Base Card present');
      card.position = position; // Force Base Card (back) into correct position.
      wastePile.removeAllCards().reversed.forEach((card) {
        card.flip();
        acquireCard(card);
      });
    } else {
      for (var i = 0; i < game.klondikeDraw; i++) {
        if (_cards.isNotEmpty) {
          final card = _cards.removeLast();
          card.doMoveAndFlip(
            wastePile.position,
            whenDone: () {
              wastePile.acquireCard(card);
            },
          );
        }
      }
    }

  }

  @override
  bool canMoveCard(Card card, MoveMethod method) => false;

  @override
  bool canAcceptCard(Card card) => false;

  @override
  void removeCard(Card card, MoveMethod method) => throw StateError('cannot remove cards from here');

  @override
  void returnCard(Card card) => card.priority = _cards.indexOf(card);

  //#region Rendering
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

  //#endregion
}