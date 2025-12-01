import 'package:flutter/material.dart';
import 'card_classes.dart';
import 'header.dart';
import 'package:union_shop/footer.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

Future<List<Map<String, dynamic>>> loadCollections(String category) async {
  final String jsonString =
      await rootBundle.loadString('assets/collection_list.json');
  final Map<String, dynamic> jsonData = json.decode(jsonString);
  return List<Map<String, dynamic>>.from(jsonData[category]);
}

Future<List<Map<String, dynamic>>> loadFeatured() async {
  final String jsonString =
      await rootBundle.loadString('assets/collection_list.json');
  final Map<String, dynamic> jsonData = json.decode(jsonString);
  List<Map<String, dynamic>> featured = [];
  for (int i = 0; i < jsonData['featured'].length; i++) {
    String categoryNumber = jsonData['featured'][i]['category'];
    int itemNumber = jsonData['featured'][i]['itemNo'];
    featured
        .add(Map<String, dynamic>.from(jsonData[categoryNumber][itemNumber]));
    print(categoryNumber);
    print(itemNumber);
  }
  return featured;
}

List<Widget> buildCollectionCards(List<Map<String, dynamic>> collections) {
  return collections.map((collection) {
    return CollectionCard(
      title: collection['title'],
      description:
          'This is a placeholder description for ${collection['title']}.',
      imageUrl: '${collection['imageLocation']}',
      routeName: '${collection['routeName']}',
    );
  }).toList();
}

List<Widget> buildProductCards(List<Map<String, dynamic>> collections,
    {String sortBy = 'alphabeticala-z'}) {
  if (sortBy == 'alphabeticala-z') {
    collections
        .sort((a, b) => a['title'].toString().compareTo(b['title'].toString()));
  } else if (sortBy == 'alphabeticalz-a') {
    collections
        .sort((a, b) => b['title'].toString().compareTo(a['title'].toString()));
  } else if (sortBy == 'priceLowHigh') {
    collections.sort(
        (a, b) => (a['price'].toString()).compareTo(b['price'].toString()));
  } else if (sortBy == 'priceHighLow') {
    collections.sort(
        (a, b) => (b['price'].toString()).compareTo(a['price'].toString()));
  }

  return collections.map((collection) {
    return ProductCard(
      title: collection['title'],
      price: collection['price'],
      imageUrl: '${collection['imageLocation']}',
      routeName: '${collection['routeName']}',
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

class PageMaster extends StatefulWidget {
  final Widget Function(String sortBy) childBuilder;
  final bool showFilters;
  const PageMaster(
      {super.key, required this.childBuilder, this.showFilters = true});

  @override
  State<PageMaster> createState() => _PageMasterState();
}

class _PageMasterState extends State<PageMaster> {
  String _selectedSort = 'alphabeticala-z';
  List<DropdownMenuEntry<String>> get dropdownMenuEntries => [
        const DropdownMenuEntry<String>(
          value: 'alphabeticala-z',
          label: 'Alphabetical (A-Z)',
        ),
        const DropdownMenuEntry<String>(
          value: 'alphabeticalz-a',
          label: 'Alphabetical (Z-A)',
        ),
        const DropdownMenuEntry<String>(
          value: 'priceLowHigh',
          label: 'Price (Low-High)',
        ),
        const DropdownMenuEntry<String>(
          value: 'priceHighLow',
          label: 'Price (High-Low)',
        ),
      ];
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
                      if (widget.showFilters) ...[
                        const Text('filters'),
                        DropdownMenu<String>(
                          initialSelection: _selectedSort,
                          dropdownMenuEntries: dropdownMenuEntries,
                          onSelected: (String? v) {
                            if (v == null) return;
                            setState(() {
                              _selectedSort = v;
                            });
                          },
                        ),
                      ],
                      // build the page content using the current sort key
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: widget.childBuilder(_selectedSort),
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
        showFilters: false,
        childBuilder: (sortBy) => buildCollectionsFutureBuilder(
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
        childBuilder: (sortBy) => buildCollectionsFutureBuilder(
          loadCollections('Autumn Favourites'),
          context,
          (list) => buildProductCards(list, sortBy: sortBy),
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
        childBuilder: (sortBy) => buildCollectionsFutureBuilder(
          loadCollections('Black Friday'),
          context,
          (list) => buildProductCards(list, sortBy: sortBy),
        ),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageMaster(
        childBuilder: (sortBy) => buildCollectionsFutureBuilder(
          loadFeatured(),
          context,
          (list) => buildProductCards(list, sortBy: sortBy),
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
        childBuilder: (sortBy) => buildCollectionsFutureBuilder(
          loadCollections('Clothing'),
          context,
          (list) => buildProductCards(list, sortBy: sortBy),
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
        childBuilder: (sortBy) => buildCollectionsFutureBuilder(
          loadCollections('Graduation'),
          context,
          (list) => buildProductCards(list, sortBy: sortBy),
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
        childBuilder: (sortBy) => buildCollectionsFutureBuilder(
          loadCollections('Merchandise'),
          context,
          (list) => buildProductCards(list, sortBy: sortBy),
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
        childBuilder: (sortBy) => buildCollectionsFutureBuilder(
          loadCollections('Personalisation'),
          context,
          (list) => buildProductCards(list, sortBy: sortBy),
        ),
      ),
    );
  }
}
