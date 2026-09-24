import 'package:flutter/material.dart';

class DetectedIngredient {
  final String id;
  final String name;
  final String category; // 'meat', 'veggie', 'seasoning', 'dairy'
  final Color color;
  final Rect relativeBounds; // Normalized 0.0 to 1.0 (left, top, width, height)

  DetectedIngredient({
    required this.id,
    required this.name,
    this.category = 'veggie',
    required this.color,
    required this.relativeBounds,
  });

  DetectedIngredient copyWith({
    String? id,
    String? name,
    String? category,
    Color? color,
    Rect? relativeBounds,
  }) {
    return DetectedIngredient(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      color: color ?? this.color,
      relativeBounds: relativeBounds ?? this.relativeBounds,
    );
  }
}
