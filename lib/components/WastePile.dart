import 'package:flame/components.dart';
import '../klondike_game.dart';
import 'card.dart';
import 'Pile.dart';

class WastePile extends PositionComponent
    with HasGameReference<KlondikeGame> implements Pile {
  WastePile({super.position}) : super(size: KlondikeGame.cardSize);

  final List<Card> _cards = [];
  final Vector2 _fanOffset = Vector2(KlondikeGame.cardWidth * 0.2, 0);

  List<Card> removeAllCards() {
    final cards = _cards.toList();
    _cards.clear();
    return cards;
  }

  @override
  bool canMoveCard(Card card, MoveMethod method) =>
      _cards.isNotEmpty && card == _cards.last; // Tap and drag are both OK

  @override
  bool canAcceptCard(Card card) => false;

  @override
  void removeCard(Card card, MoveMethod method) {
    assert(canMoveCard(card, method));
    _cards.removeLast();
    _fanOutTopCards();
  }

  @override
  void returnCard(Card card) {
    card.priority = _cards.indexOf(card);
    _fanOutTopCards();
  }

  // puts cards into a single pile
  void acquireCard(Card card) {
    assert(card.isFaceUp);
    card.position = position;
    card.priority = _cards.length;
    _cards.add(card);
    _fanOutTopCards();
    card.pile = this;
  }

  // called to fan out cards
  void _fanOutTopCards() {
    if (game.klondikeDraw == 1)
      // No fan-out in Klondike Draw 1.
      return;

    final n = _cards.length;
    for (var i = 0; i < n; i++) {
      _cards[i].position = position;
    }

    if (n == 2) {
      _cards[1].position = position;
    } else if (n >= 3) {
      _cards[n - 2].position.add(_fanOffset);
      _cards[n - 1].position.addScaled(_fanOffset, 2);
    }
  }
}