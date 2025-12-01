import 'package:flutter/material.dart';
// import a single symbol (function, class, const, etc.) from another file
import 'package:union_shop/collections_list.dart' show loadCollections;
import 'package:union_shop/product_page.dart';

class AutumnKnitScarfPage extends StatelessWidget {
  const AutumnKnitScarfPage({super.key, required this.routeName});
  final String routeName;
  List<String> get routeNames => routeName.split('/');
  @override
  Widget build(BuildContext context) {
    // normalize route parts (remove empty segments caused by leading '/')
    final parts = routeName.split('/').where((s) => s.isNotEmpty).toList();
    if (parts.length < 3) {
      return const Scaffold(body: Center(child: Text('Invalid route')));
    }

    // expected: ['/','collection-slug','item-slug'] -> use parts[1] and parts[2]
    final collectionSlug = parts.length > 1 ? parts[1] : '';
    final itemSlug = parts.length > 2 ? parts[2] : '';
    String pretty(String slug) {
      final pieces = slug.split('-');
      return pieces
          .where((p) => p.isNotEmpty)
          .map((p) => p.isNotEmpty
              ? '${p[0].toUpperCase()}${p.substring(1).toLowerCase()}'
              : p)
          .join(' ');
    }

    final collectionName = pretty(collectionSlug);
    final itemName = pretty(itemSlug);

    return FutureBuilder<List<dynamic>>(
      future: loadCollections(collectionName),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(child: Text('Error: ${snapshot.error}')),
          );
        }
        final raw = snapshot.data ?? <dynamic>[];
        final List<Map<String, dynamic>> itemsList = raw
            .whereType<Map<String, dynamic>>()
            .map((m) => Map<String, dynamic>.from(m))
            .where((m) =>
                !(m.containsKey('collectiondescription')))
            .toList();

        final query = itemName.toLowerCase().trim();
        Map<String, dynamic>? foundItem;

        for (final item in itemsList) {
          final titleText = ((item['title'] ?? item['name']) as Object)
              .toString()
              .toLowerCase();
          if (titleText == query || titleText.contains(query)) {
            foundItem = item;
            break;
          }
        }

        if (foundItem == null) {
          return const Scaffold(
            body: Center(child: Text('Item not found')),
          );
        }

        return ProductPage(data: [foundItem]);
      },
    );
  }
}
