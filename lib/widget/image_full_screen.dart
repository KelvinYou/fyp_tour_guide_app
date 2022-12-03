

import 'package:flutter/material.dart';

class ImageFullScreen extends StatelessWidget {
  final String imageUrl;

  ImageFullScreen({required this.imageUrl});

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
              child: Image.network(
                  imageUrl
              ),

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