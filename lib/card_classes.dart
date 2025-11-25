import 'package:flutter/material.dart';

class Card extends StatelessWidget {
  final String title;
  final String imageUrl;
  final String routeName;
  const Card({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.routeName,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/product');
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey[300],
                  child: const Center(
                    child: Icon(Icons.image_not_supported, color: Colors.grey),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ProductCard extends Card {
  final String price;
  const ProductCard({
    super.key,
    required super.title,
    required this.price,
    required super.imageUrl,
    required super.routeName,
  });
  @override
  Widget build(BuildContext context) {
    final Widget inheritedImage = Expanded(
      child: super.build(context),
    );

    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, routeName),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          inheritedImage,
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(fontSize: 14, color: Colors.black),
            maxLines: 2,
          ),
          const SizedBox(height: 4),
          Text(
            price,
            style: const TextStyle(fontSize: 13, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

class CollectionCard extends Card {
  final String description;
  const CollectionCard({
    super.key,
    required super.title,
    required this.description,
    required super.imageUrl,
    required super.routeName,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, routeName),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image with translucent textbox overlapping the bottom
          Expanded(
            child: Stack(
              children: [
                Positioned.fill(
                  child: super.build(context),
                ),
                Expanded(
                  
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                    
                    color: Colors.black.withAlpha(153),
                    child: Center(
                      child: Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
        ],
      ),
    );
  }
}
