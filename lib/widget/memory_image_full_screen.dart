

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class MemoryImageFullScreen extends StatelessWidget {
  final Uint8List image;

  MemoryImageFullScreen({required this.image});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        child: Container(
          height: double.infinity,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.background,
          ),
          child: Center(
            child: Hero(
              tag: 'imageHero',
              child: Image.memory(image),

            ),
          ),
        ),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}