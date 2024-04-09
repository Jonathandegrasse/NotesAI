import 'package:flutter/material.dart';
import 'dart:math' as math;

class Flashcard {
  String term;
  String definition;

  Flashcard({required this.term, required this.definition});
}

class FlashcardsScreen extends StatefulWidget {
  @override
  _FlashcardsScreenState createState() => _FlashcardsScreenState();
}

class _FlashcardsScreenState extends State<FlashcardsScreen> {
  List<Flashcard> flashcards = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Flashcards')),
      body: Center(
        child: flashcards.isEmpty
            ? AddFlashcardBox(onAddFlashcard: _addFlashcard)
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FlipFlashcard(flashcard: flashcards[currentIndex]),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        onPressed: () => setState(() {
                          currentIndex = currentIndex > 0 ? currentIndex - 1 : flashcards.length - 1;
                        }),
                        child: Text('Previous'),
                      ),
                      ElevatedButton(
                        onPressed: () => setState(() {
                          currentIndex = currentIndex < flashcards.length - 1 ? currentIndex + 1 : 0;
                        }),
                        child: Text('Next'),
                      ),
                    ],
                  ),
                ],
              ),
      ),
    );
  }

  void _addFlashcard() {
    setState(() {
      flashcards.add(Flashcard(term: "", definition: ""));
    });
  }
}

class AddFlashcardBox extends StatelessWidget {
  final VoidCallback onAddFlashcard;

  AddFlashcardBox({required this.onAddFlashcard});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onAddFlashcard,
      child: Container(
        width: 250,
        height: 150,
        color: Colors.black,
        child: Center(
          child: Icon(Icons.add, color: Colors.white, size: 40),
        ),
      ),
    );
  }
}

class FlipFlashcard extends StatefulWidget {
  final Flashcard flashcard;

  FlipFlashcard({required this.flashcard});

  @override
  _FlipFlashcardState createState() => _FlipFlashcardState();
}

class _FlipFlashcardState extends State<FlipFlashcard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool isFront = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed || status == AnimationStatus.dismissed) {
        setState(() {
          isFront = !isFront;
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _flipCard() {
    if (isFront) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _flipCard,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (BuildContext context, Widget? child) {
          return Transform(
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(math.pi * _controller.value),
            alignment: Alignment.center,
            child: Container(
              width: 250,
              height: 150,
              child: _controller.value < 0.5
                  ? CardFront(term: widget.flashcard.term)
                  : CardBack(definition: widget.flashcard.definition),
            ),
          );
        },
      ),
    );
  }
}

class CardFront extends StatelessWidget {
  final String term;

  CardFront({required this.term});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue,
      child: Center(
        child: Text(term, style: TextStyle(fontSize: 24, color: Colors.white)),
      ),
    );
  }
}

class CardBack extends StatelessWidget {
  final String definition;

  CardBack({required this.definition});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
      child: Center(
        child: Text(definition, style: TextStyle(fontSize: 24, color: Colors.white)),
      ),
    );
  }
}