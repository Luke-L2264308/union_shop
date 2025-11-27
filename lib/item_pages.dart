import 'package:flutter/material.dart';
// import a single symbol (function, class, const, etc.) from another file
import 'package:union_shop/collections_list.dart' show loadCollections;
import 'package:union_shop/product_page.dart';


class AutumnKnitScarfPage extends StatelessWidget {
  const AutumnKnitScarfPage({super.key});
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(future: loadCollections('Autumn Favourites'), builder:  (context, snapshot) {
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
        final items = snapshot.data ?? [];
        // make itemsList mutable so we can replace it with the found item
        List<Map<String, dynamic>> itemsList = (items as List<dynamic>?)
          ?.map((e) => Map<String, dynamic>.from(e as Map<String, dynamic>))
          .toList() ?? <Map<String, dynamic>>[];

        const query = 'autumn knit scarf';
        Map<String, dynamic>? foundItem;
        for (final item in itemsList) {
          final text = '${item['name'] ?? item['title']  ?? ''}'.toLowerCase();
          if (text.contains(query)) {
            foundItem = item;
            break;
          }
        }

        // if the item wasn't found, show not found
        if (foundItem == null) {
          return const Scaffold(
            body: Center(child: Text('Item not found')),
          );
        }

        // replace itemsList with a single-entry list containing the found item
        itemsList = [foundItem];
        return ProductPage(data: itemsList);
      },)
      
    ;  
  }
}