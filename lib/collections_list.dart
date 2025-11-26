import 'package:flutter/material.dart';
import 'card_classes.dart';
import 'header.dart';
import 'package:union_shop/footer.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

Future<List<Map<String, dynamic>>> loadCollections(String category) async {
  final String jsonString = await rootBundle.loadString('collection_list.json');
  final Map<String, dynamic> jsonData = json.decode(jsonString);
  return List<Map<String, dynamic>>.from(jsonData[category]);
}

List<Widget> buildCollectionCards(List<Map<String, dynamic>> collections) {
  return collections.map((collection) {
    return CollectionCard(
      title: collection['title'],
      description:
          'This is a placeholder description for ${collection['title']}.',
      imageUrl: '${collection['imageLocation']}',
      routeName: collection['routeName'],
    );
  }).toList();
}

List<Widget> buildProductCards(List<Map<String, dynamic>> collections) {
  return collections.map((collection) {
    return ProductCard(
      title: collection['title'],
      price: collection['price'],
      imageUrl: '${collection['imageLocation']}',
      routeName: collection['routeName'],
    );
  }).toList();
}

//this function should be able to be used to build both the collections "e.g. like good friday sales" and also the categories within products "e.g. hoodies, t-shirts etc"
FutureBuilder<List<Map<String, dynamic>>> buildCollectionsFutureBuilder(
    Future<List<Map<String, dynamic>>> future,
    BuildContext context,
    List<Widget> Function(List<Map<String, dynamic>>) buildCollectionCards) {
  return FutureBuilder<List<Map<String, dynamic>>>(
    future: future,
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      }
      if (snapshot.hasError) {
        return Center(child: Text('Error: ${snapshot.error}'));
      }
      final collections = snapshot.data ?? [];
      return GridView.count(
        shrinkWrap: true, // allow GridView inside a scrollable parent
        physics:
            const NeverScrollableScrollPhysics(), // let outer scroll view handle scrolling
        crossAxisCount: MediaQuery.of(context).size.width > 600 ? 2 : 1,
        crossAxisSpacing: 24,
        mainAxisSpacing: 48,
        children: [
          ...buildCollectionCards(collections),
        ],
      );
    },
  );
}

class PageMaster extends StatelessWidget {
  final Widget? child;
  const PageMaster({super.key, this.child});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // main content column (Header + provided child)
                  Column(
                    children: [
                      const Header(),
                      if (child != null) Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: child!,
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
    );
  }
}

class Collections extends StatelessWidget {
  const Collections({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageMaster(
        child: buildCollectionsFutureBuilder(
          loadCollections('categories'),
          context,
          buildCollectionCards,
        ),
      ),
    );
  }
}

class AutumnFavouritesPage extends StatelessWidget {
  const AutumnFavouritesPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageMaster(
        child: buildCollectionsFutureBuilder(
          loadCollections('Autumn Favourites'),
          context,
          buildProductCards,
        ),
      ),
    );
  }
}

class BlackFridayPage extends StatelessWidget {
  const BlackFridayPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageMaster(
        child: buildCollectionsFutureBuilder(
          loadCollections('Black Friday'),
          context,
          buildProductCards,
        ),
      ),
    );
  }
}
class ClothingPage extends StatelessWidget {
  const ClothingPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageMaster(
        child: buildCollectionsFutureBuilder(
          loadCollections('Clothing'),
          context,
          buildProductCards,
        ),
      ),
    );
  }
}

class GraduationPage extends StatelessWidget {
  const GraduationPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageMaster(
        child: buildCollectionsFutureBuilder(
          loadCollections('Graduation'),
          context,
          buildProductCards,
        ),
      ),
    );
  }
}

class MerchandisePage extends StatelessWidget {
  const MerchandisePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageMaster(
        child: buildCollectionsFutureBuilder(
          loadCollections('Merchandise'),
          context,
          buildProductCards,
        ),
      ),
    );
  }
}

class PersonalisationPage extends StatelessWidget {
  const PersonalisationPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageMaster(
        child: buildCollectionsFutureBuilder(
          loadCollections('Personalisation'),
          context,
          buildProductCards,
        ),
      ),
    );
  }
}