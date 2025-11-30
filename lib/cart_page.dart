import 'package:flutter/material.dart';
import 'package:union_shop/cart_storage.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  late Future<List<Map<String, dynamic>>> _futureCart;

  @override
  void initState() {
    super.initState();
    _loadCart();
  }

  void _loadCart() {
    _futureCart = readCart();
  }

  Future<void> _refresh() async {
    setState(() => _loadCart());
    await _futureCart;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _futureCart,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final items = snapshot.data ?? [];
          if (items.isEmpty) {
            return RefreshIndicator(
              onRefresh: _refresh,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: const [
                  SizedBox(height: 120),
                  Center(child: Text('Your cart is empty')),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: _refresh,
            child: ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: items.length,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (context, i) {
                final item = items[i];
                final title = item['title']?.toString() ?? '';
                final quantity = item['quantity']?.toString() ?? '';
                final size = (item['size'] ?? '').toString();
                final colour = (item['colour'] ?? '').toString();

                return ListTile(
                  title: Text(title),
                  subtitle: Text('Qty: $quantity${size.isNotEmpty ? ' · Size: $size' : ''}${colour.isNotEmpty ? ' · Colour: $colour' : ''}'),
                  
                );
              },
            ),
          );
        },
      ),
    );
  }
}
