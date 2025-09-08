
import 'package:flutter/material.dart';
import 'package:myapp/models/category.dart';

class CategoryList extends StatelessWidget {
  final List<Category> categories;
  final Function(int) onCategorySelected;

  const CategoryList({super.key, required this.categories, required this.onCategorySelected});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50.0,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => onCategorySelected(categories[index].id),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Chip(
                label: Text(categories[index].name),
              ),
            ),
          );
        },
      ),
    );
  }
}
