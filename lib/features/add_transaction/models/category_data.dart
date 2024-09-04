import 'package:flutter/material.dart';

import 'models.dart';

class CategoryData {
  final String name;
  final CategoryType type;
  final IconData iconData;

  CategoryData({
    required this.name,
    required this.type,
    required this.iconData,
  });
}
