import 'package:flutter/material.dart';

class SwipeBar extends StatefulWidget {
  const SwipeBar({super.key});

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
          Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.red,
            ),
            padding: const EdgeInsets.all(8), // Adjust the padding to control the circle size
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              iconSize: 32,
              onPressed: () {},
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.blueGrey,
            ),
            padding: const EdgeInsets.all(8), // Adjust the padding to control the circle size
            child: IconButton(
              icon: const Icon(Icons.info, color: Colors.white),
              iconSize: 32,
              onPressed: () {},
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.green,
            ),
            padding: const EdgeInsets.all(8), // Adjust the padding to control the circle size
            child: IconButton(
              iconSize: 32,
              icon: const Icon(Icons.bookmark_add, color: Colors.white),
              onPressed: () {},
            ),
          ),
        ],
      ));
}
