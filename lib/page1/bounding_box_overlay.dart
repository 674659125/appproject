import 'package:flutter/material.dart';
import '../models/detected_ingredient.dart';

class BoundingBoxOverlay extends StatelessWidget {
  final List<DetectedIngredient> ingredients;
  final Size screenSize;

  const BoundingBoxOverlay({
    super.key,
    required this.ingredients,
    required this.screenSize,
  });

  @override
  Widget build(BuildContext context) {
    if (screenSize.width <= 0 || screenSize.height <= 0) {
      return const SizedBox.shrink();
    }

    return Stack(
      children: ingredients.map((item) {
        final left = (item.relativeBounds.left * screenSize.width).clamp(0.0, screenSize.width);
        final top = (item.relativeBounds.top * screenSize.height).clamp(0.0, screenSize.height);
        final width = (item.relativeBounds.width * screenSize.width).clamp(0.0, screenSize.width - left);
        final height = (item.relativeBounds.height * screenSize.height).clamp(0.0, screenSize.height - top);

        if (width <= 0 || height <= 0) {
          return const SizedBox.shrink();
        }

        return Positioned(
          left: left,
          top: top,
          width: width,
          height: height,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // Bounding Box Rectangle
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: item.color,
                    width: 2.5,
                  ),
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              // Label Tag at Top-Left
              Positioned(
                left: 0,
                top: -14,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: item.color,
                    borderRadius: BorderRadius.circular(6),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    item.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
