import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/material.dart';

class SwipeBar extends StatefulWidget {
  const SwipeBar(
      {super.key,
      required this.appinioController,
      required this.flipcardController});

  final AppinioSwiperController appinioController;
  final FlipCardController flipcardController;

  @override
  State<SwipeBar> createState() => _SwipeBarState();
}

class _SwipeBarState extends State<SwipeBar> {
  @override
  Widget build(BuildContext context) => Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          ElevatedButton(
            onPressed: () {
              widget.appinioController.swipeLeft();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              padding: const EdgeInsets.all(16),
              shape: const CircleBorder(),
            ),
            child: const Icon(
              Icons.close,
              color: Colors.white,
              size: 32,
            ),
          ),
          /// Shows details
          ElevatedButton(
            onPressed: () {
              widget.flipcardController.toggleCard();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueGrey,
              padding: const EdgeInsets.all(16),
              shape: const CircleBorder(),
            ),
            child: const Icon(
              Icons.info_outline_rounded,
              color: Colors.white,
              size: 32,
            ),
          ),
          ElevatedButton(
            onPressed: () {
              widget.appinioController.unswipe();
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(16),
              shape: const CircleBorder(),
            ),
            child: const Icon(
              Icons.restore,
              color: Colors.blueGrey,
              size: 32,
            ),
          ),
          ElevatedButton(
            onPressed: () {
              widget.appinioController.swipeRight();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              padding: const EdgeInsets.all(16),
              shape: const CircleBorder(),
            ),
            child: const Icon(
              Icons.bookmark_add,
              color: Colors.white,
              size: 32,
            ),
          ),
        ],
      ));
}
