import 'package:flutter/material.dart';
import 'package:union_shop/headerandfooter/footer.dart';
import 'package:union_shop/headerandfooter/header.dart';

import 'dart:convert';
import 'package:union_shop/cart_storage/cart_storage.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key, required this.data});
  final List<Map<String, dynamic>> data;

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  List<Map<String, dynamic>> get data => widget.data;
  String? _colourSelected;
  String? _sizeSelected;

  void navigateToHome(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
  }

  void placeholderCallbackForButtons() {
    // This is the event handler for buttons that don't work yet
  }

  List<DropdownMenuEntry<String>> _buildDropdownEntries(String attribute) {
    List<DropdownMenuEntry<String>> entries = [];
    for (int i = 0; i < data[0][attribute].length; i++) {
      DropdownMenuEntry<String> newEntry = DropdownMenuEntry<String>(
        value: data[0][attribute][i],
        label: data[0][attribute][i].toString(),
      );
      entries.add(newEntry);
    }
    return entries;
  }

  int _quantity = 1;
  void _decreaseQuantity() {
    if (_quantity > 1) {
      setState(() {
        _quantity--;
      });
    }
  }

  void _increaseQuantity() {
    setState(() {
      _quantity++;
    });
  }

  void addToCart(String? colour, String? size, String title) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Added $_quantity $colour $size $title to cart.')),
    );
    // Append cart item as a JSON line to a local file:

    () async {
      try {
        final item = {
          'title': title,
          'colour': colour ?? '',
          'size': size ?? '',
          'quantity': _quantity,
          'addedAt': DateTime.now().toIso8601String(),
        };

        // Try to merge with existing cart entry (match on title + size + colour).
        // Requires helper functions in cart_storage.dart:
        //   Future<List<Map<String,dynamic>>> readCartItems()
        //   Future<void> writeCartItems(List<Map<String,dynamic>> items)
        //
        // If those helpers don't exist, add them to cart_storage.dart (read/write a JSON
        // list or newline-delimited JSON). If you prefer, move merging logic into cart_storage.dart.
        try {
          List<Map<String, dynamic>> existing = [];
          try {
            existing = await readCartItems();
          } catch (_) {
            existing = [];
          }

          final matchIndex = existing.indexWhere((e) =>
              (e['title'] ?? '') == title &&
              (e['size'] ?? '') == (size ?? '') &&
              (e['colour'] ?? '') == (colour ?? ''));

          if (matchIndex != -1) {
            // Merge quantities and update timestamp
            existing[matchIndex]['quantity'] =
                (existing[matchIndex]['quantity'] ?? 0) + _quantity;
            existing[matchIndex]['addedAt'] = DateTime.now().toIso8601String();
            await writeCartItems(existing);
          } else {
            await appendCartItem(item);
          }
        } catch (e) {
          // If anything goes wrong with merging, fall back to appending the item
          await appendCartItem(item);
        }
      } catch (e, st) {
        // Log failure but don't crash the UI
        // ignore: avoid_print
        print('Failed to write cart storage: $e\n$st');
      }
    }();
  }

  @override
  void initState() {
    super.initState();
    _colourSelected =
        data[0]["colours"].isNotEmpty ? data[0]["colours"][0] : '';
    _sizeSelected = data[0]["sizes"].isNotEmpty ? data[0]["sizes"][0] : '';
  }

  @override
  Widget build(BuildContext context) {
    final String title = data[0]["title"];
    final String description = data[0]["description"];
    final String imageLocation = data[0]["imageLocation"];
    final String price = data[0]["price"];
    final List<dynamic> sizes = data[0]["sizes"];
    final List<dynamic> colours = data[0]["colours"];
    final hasReduced =
        data[0].containsKey("reducedprice") && data[0]["reducedprice"] != null;
    String? reduced;
    if (hasReduced) {
      reduced = data[0]["reducedprice"] as String;
      // show reduced
    } else {
      reduced = null;
    }
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Header(),

            // Product details
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(24),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product image
                    Container(
                      height: 300,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.grey[200],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          imageLocation,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey[300],
                              child: const Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.image_not_supported,
                                      size: 64,
                                      color: Colors.grey,
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      'Image unavailable',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Product name
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Product price
                    Row(
                      children: [
                      Text(
                        price,
                        style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF4d2963),
                        decoration: hasReduced ? TextDecoration.lineThrough : TextDecoration.none,
                        ),
                      ),
                        if (hasReduced) ...[
                          const SizedBox(width: 12),
                          Text(
                            reduced!,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ],
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Product description
                    const Text(
                      'Description',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      description,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 24),
                    GridView.count(
                        crossAxisCount:
                            MediaQuery.of(context).size.width > 500 ? 3 : 1,
                        mainAxisSpacing: 8,
                        crossAxisSpacing: 8,
                        childAspectRatio:
                            MediaQuery.of(context).size.width > 500 ? 3 : 4.8,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          if (colours.isNotEmpty) ...[
                            Column(
                              children: [
                                const Text('Colours Available:'),
                                DropdownMenu<String>(
                                  initialSelection: _colourSelected,
                                  dropdownMenuEntries:
                                      _buildDropdownEntries("colours"),
                                  onSelected: (String? v) =>
                                      setState(() => _colourSelected = v),
                                ),
                              ],
                            ),
                          ],
                          if (sizes.isNotEmpty) ...[
                            Column(
                              children: [
                                const Text('Sizes Available:'),
                                DropdownMenu<String>(
                                    initialSelection: _sizeSelected,
                                    dropdownMenuEntries:
                                        _buildDropdownEntries("sizes"),
                                    onSelected: (String? v) =>
                                        setState(() => _sizeSelected = v)),
                              ],
                            )
                          ],
                          Column(
                            children: [
                              const Text('Quantity: '),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                    onPressed: _decreaseQuantity,
                                    icon: const Icon(Icons.remove),
                                  ),
                                  Text('$_quantity'.toString()),
                                  IconButton(
                                    onPressed: _increaseQuantity,
                                    icon: const Icon(Icons.add),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ]),
                    ElevatedButton.icon(
                      onPressed: () =>
                          addToCart(_colourSelected, _sizeSelected, title),
                      icon: const SizedBox(
                        width: 20,
                        height: 20,
                        child: FittedBox(
                          fit: BoxFit.contain,
                          child: Icon(Icons.shopping_cart),
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                      label: const Text('Add to Cart'),
                    ),
                  ]),
            ),
            const Footer(),
          ],
        ),
      ),
    );
  }
}
