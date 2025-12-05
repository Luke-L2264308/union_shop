import 'package:flutter/material.dart';
import '../helpers/card_classes.dart';
import '../headerandfooter/header.dart';
import 'package:union_shop/headerandfooter/footer.dart';
import 'dart:convert';
import 'package:flutter/services.dart';


Future<List<Map<String, dynamic>>> loadCollections(String category) async {
  final String jsonString =
      await rootBundle.loadString('assets/collection_list.json');
  final Map<String, dynamic> jsonData = json.decode(jsonString);

  final List<Map<String, dynamic>> list =
      List<Map<String, dynamic>>.from(jsonData[category] ?? []);

  // Normalize description key so callers can just look for 'description'
  if (list.isNotEmpty && list.first.containsKey('collectiondescription')) {
    final first = Map<String, dynamic>.from(list.first);
    first['description'] = first['collectiondescription'];
    list[0] = first;
  }

  return list;
}

Future<List<Map<String, dynamic>>> loadFeatured() async {
  final String jsonString =
      await rootBundle.loadString('assets/collection_list.json');
  final Map<String, dynamic> jsonData = json.decode(jsonString);

  final List<Map<String, dynamic>> featured = [];
  if (jsonData['featured'] is List && (jsonData['featured'] as List).isNotEmpty) {
    // normalize featured[0] description key if present
    final firstRaw = Map<String, dynamic>.from(jsonData['featured'][0]);
    if (firstRaw.containsKey('collectiondescription')) {
      firstRaw['description'] = firstRaw['collectiondescription'];
    }
    featured.add(firstRaw);
  }

  for (int i = 1; i < (jsonData['featured'] as List).length; i++) {
    final entry = jsonData['featured'][i];
    if (entry is Map) {
      final String? categoryKey = entry['category']?.toString();
      final dynamic itemNoRaw = entry['itemNo'];
      final int? itemIndex = (itemNoRaw is int) ? itemNoRaw : int.tryParse('$itemNoRaw');

      if (categoryKey != null &&
          itemIndex != null &&
          jsonData[categoryKey] is List &&
          itemIndex >= 0 &&
          itemIndex < (jsonData[categoryKey] as List).length) {
        final item = Map<String, dynamic>.from(jsonData[categoryKey][itemIndex]);
        // normalize collectiondescription on referenced item as well
        if (item.containsKey('collectiondescription')) {
          item['description'] = item['collectiondescription'];
        }
        featured.add(item);
      }
    }
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
    double effectivePrice(Map<String, dynamic> item) {
      final rp = item['reducedprice'];
      final p = item['price'];
      return double.tryParse(rp?.toString() ?? '') ??
             double.tryParse(p?.toString() ?? '') ??
             0.0;
    }
    collections.sort((a, b) => effectivePrice(a).compareTo(effectivePrice(b)));
  } else if (sortBy == 'priceHighLow') {
    double effectivePrice(Map<String, dynamic> item) {
      final rp = item['reducedprice'];
      final p = item['price'];
      return double.tryParse(rp?.toString() ?? '') ??
             double.tryParse(p?.toString() ?? '') ??
             0.0;
    }
    collections.sort((a, b) => effectivePrice(b).compareTo(effectivePrice(a)));
  }

  return collections.map((collection) {
    return ProductCard(
      title: collection['title'],
      price: "£${collection['price']}",
      imageUrl: '${collection['imageLocation']}',
      reducedprice: collection['reducedprice'] != null ? "£${collection['reducedprice']}" : null,
      routeName: '${collection['routeName']}',
    );
  }).toList();
}

//this function should be able to be used to build both the collections "e.g. like good friday sales" and also the categories within products "e.g. hoodies, t-shirts etc"
// ...existing code...
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
      if (collections.isEmpty) {
        return const Center(child: Text('No items found'));
      }

      // If first item is a description object, render it separately and exclude it from the grid.
      String? description;
      List<Map<String, dynamic>> remaining;
      final first = collections.first;
      if (first.containsKey('collectiondescription')) {
        description = first['description']?.toString();
        remaining = collections.length > 1 ? collections.sublist(1) : <Map<String, dynamic>>[];
      } else {
        remaining = collections;
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (description != null) ...[
            Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: Text(
                description,
                style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
            ),
          ],
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: MediaQuery.of(context).size.width > 600 ? 2 : 1,
            crossAxisSpacing: 24,
            mainAxisSpacing: 48,
            children: [
              ...buildCollectionCards(remaining),
            ],
          ),
        ],
      );
      
    },
  );
}


class PageMaster extends StatefulWidget {
  final Widget Function(String sortBy) childBuilder;
  final bool showFilters;
  final Widget? extraContent;
  const PageMaster(
      {super.key, required this.childBuilder, this.showFilters = true, this.extraContent});
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
                      if (widget.extraContent != null) widget.extraContent!,
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
        showFilters: false,
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
