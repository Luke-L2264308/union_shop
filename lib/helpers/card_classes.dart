import 'package:flutter/material.dart';
import 'package:union_shop/helpers/item_pages.dart';

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
    return Image.asset(
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
    );
  }
}

class ProductCard extends Card {
  final String price;
  final String? reducedprice;
  const ProductCard({
    super.key,
    required super.title,
    required this.price,
    this.reducedprice,
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
          if (reducedprice != null)
            Row(
              children: [
          Text(
            price,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.grey,
              decoration: TextDecoration.lineThrough,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            reducedprice!,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
              ],
            )
          else
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
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Using super.build(context) to render the image
          super.build(context),

          // The translucent grey overlay
          Container(
            color: Colors.black.withAlpha(102),
          ),

          // The text in the center
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
