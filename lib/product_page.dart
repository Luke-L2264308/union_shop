import 'package:flutter/material.dart';
import 'package:union_shop/footer.dart';
import 'package:union_shop/header.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key, required this.data});
  final List<Map<String, dynamic>> data;

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  List<Map<String, dynamic>> get data => widget.data;
  @override
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

  @override
  Widget build(BuildContext context) {
    final String title = data[0]["title"];
    final String description = data[0]["description"];
    final String imageLocation = data[0]["imageLocation"];
    final String price = data[0]["price"];
    final List<dynamic> sizes = data[0]["sizes"];
    final List<dynamic> colours = data[0]["colours"];

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
                      child: Image.network(
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
                  Text(
                    price,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4d2963),
                    ),
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
                  Row(children: [
                    if (colours.isNotEmpty) ...[
                      Column(
                        children: [
                          const Text('Colours Available:'),
                          DropdownMenu<String>(
                            initialSelection: colours[0],
                            dropdownMenuEntries:
                                _buildDropdownEntries("colours"),
                          ),
                        ],
                      ),
                    ],
                    if (sizes.isNotEmpty) ...[
                      const SizedBox(width: 40),
                      Column(
                        children: [
                          const Text('Sizes Available:'),
                          DropdownMenu<String>(
                            initialSelection: sizes[0],
                            dropdownMenuEntries: _buildDropdownEntries("sizes"),
                          ),
                        ],
                      )
                    ]
                  ]),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Quantity: '),
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
            ),

            const Footer()
          ],
        ),
      ),
    );
  }
}
