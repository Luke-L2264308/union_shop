import 'package:flutter/material.dart';
import 'card_classes.dart';
import 'header.dart';
import 'package:union_shop/footer.dart';

class Collections extends StatelessWidget {
  const Collections({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Main content column (will grow as needed)
                    Column(
                      children: [
                        const Header(),
                        GridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount:
                              MediaQuery.of(context).size.width > 600 ? 2 : 1,
                          crossAxisSpacing: 24,
                          mainAxisSpacing: 48,
                          children: const [
                            CollectionCard(
                              title: 'Placeholder Collection 1',
                              description:
                                  'This is a placeholder description for Collection 2.',
                              imageUrl:
                                  'https://shop.upsu.net/cdn/shop/files/PortsmouthCityMagnet1_1024x1024@2x.jpg?v=1752230282',
                              routeName: '/product',
                            ),
                            CollectionCard(
                                title: 'Placeholder Collection 2',
                                description:
                                    'This is a placeholder description for Collection 2.',
                                imageUrl:
                                    'https://shop.upsu.net/cdn/shop/files/PortsmouthCityMagnet1_1024x1024@2x.jpg?v=1752230282',
                                routeName: '/product'),
                            CollectionCard(
                              title: 'Placeholder Collection 3',
                              description:
                                  'This is a placeholder description for Collection 3.',
                              imageUrl:
                                  'https://shop.upsu.net/cdn/shop/files/PortsmouthCityMagnet1_1024x1024@2x.jpg?v=1752230282',
                              routeName: '/product',
                            ),
                            CollectionCard(
                              title: 'Placeholder Collection 4',
                              description:
                                  'This is a placeholder description for Collection 4.',
                              imageUrl:
                                  'https://shop.upsu.net/cdn/shop/files/PortsmouthCityMagnet1_1024x1024@2x.jpg?v=1752230282',
                              routeName: '/product',
                            ),
                            CollectionCard(
                              title: 'Placeholder Collection 5',
                              description:
                                  'This is a placeholder description for Collection 1.',
                              imageUrl:
                                  'https://shop.upsu.net/cdn/shop/files/PortsmouthCityMagnet1_1024x1024@2x.jpg?v=1752230282',
                              routeName: '/collection',
                            ),
                          ],
                        ),
                      ],
                    ),

                    // Footer will sit at bottom when content is short, or below content when long
                    const Footer(),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
