import 'package:flutter/material.dart';

class SwipeBar extends StatelessWidget {
  const SwipeBar({super.key});

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
              icon: const Icon(Icons.close, color: Colors.white60),
              onPressed: () {},
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.orange,
            ),
            padding: const EdgeInsets.all(8), // Adjust the padding to control the circle size
            child: IconButton(
              icon: const Icon(Icons.info, color: Colors.white60),
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
              icon: const Icon(Icons.done, color: Colors.white60),
              onPressed: () {},
            ),
          ),
        ],
      ));
}
