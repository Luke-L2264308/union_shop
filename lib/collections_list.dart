import 'package:flutter/material.dart';
import 'card_classes.dart';
import 'header.dart';
import 'package:union_shop/footer.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

Future<List<Map<String, dynamic>>> loadCollections() async {
  final String jsonString =
      await rootBundle.loadString('collection_list.json');
  final Map<String, dynamic> jsonData = json.decode(jsonString);
  return List<Map<String, dynamic>>.from(jsonData['categories']);
}

List<Widget> buildCollectionCards(List<Map<String, dynamic>> collections) {
  return collections.map((collection) {
    return CollectionCard(
      title: collection['title'],
      description:
          'This is a placeholder description for ${collection['title']}.',
      imageUrl:
          '${collection['imageLocation']}',
      routeName: collection['routeName'],
    );
  }).toList();
}

//this function should be able to be used to build both the collections "e.g. like good friday sales" and also the categories within products "e.g. hoodies, t-shirts etc"
FutureBuilder<List<Map<String, dynamic>>> buildCollectionsFutureBuilder(Future<List<Map<String, dynamic>>> future, BuildContext context, List<Widget> Function(List<Map<String, dynamic>>) buildCollectionCards) {
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
        physics: const NeverScrollableScrollPhysics(), // let outer scroll view handle scrolling
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
                        buildCollectionsFutureBuilder(loadCollections(), context, buildCollectionCards)
                        
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
