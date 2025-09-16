import 'package:flutter/material.dart';
import 'package:myapp/models/post.dart';

class CategoryList extends StatelessWidget {
  final List<Category> categories;
  final String? selectedCategory;
  final Function(int)? onCategorySelected;

  const CategoryList({
    Key? key,
    required this.categories,
    this.selectedCategory,
    this.onCategorySelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Categories',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            final isSelected = selectedCategory == category.slug;
            
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              color: isSelected ? Colors.blue[50] : null,
              child: ListTile(
                title: Text(
                  category.name,
                  style: TextStyle(
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    color: isSelected ? Colors.blue[800] : null,
                  ),
                ),
                subtitle: Text(
                  category.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.blue[200] : Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${category.postCount}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.blue[800] : Colors.grey[600],
                    ),
                  ),
                ),
                onTap: () {
                  if (onCategorySelected != null) {
                    onCategorySelected!(category.id);
                  }
                },
              ),
            );
          },
        ),
      ],
    );
  }
}