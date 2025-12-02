import 'package:flutter/material.dart';
import 'package:union_shop/cart_storage/cart_storage.dart';

// Testable function types
typedef CartReadFn = Future<List<Map<String, dynamic>>> Function();
typedef CartChangeQuantityFn = Future<void> Function({
  required String title,
  required String size,
  required String colour,
  required int count,
});
typedef CartRemoveFn = Future<void> Function({
  required String title,
  required String size,
  required String colour,
});

class CartPage extends StatefulWidget {
  /// Optional hooks for testing: if provided these will be used instead of
  /// the real storage functions.
  const CartPage({
    super.key,
    this.readCartFn,
    this.decreaseFn,
    this.increaseFn,
    this.removeFn,
  });

  final CartReadFn? readCartFn;
  final CartChangeQuantityFn? decreaseFn;
  final CartChangeQuantityFn? increaseFn;
  final CartRemoveFn? removeFn;

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
    _futureCart = widget.readCartFn?.call() ?? readCart();
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

                final quantityInt = int.tryParse(quantity) ?? 0;

                return ListTile(
                  title: Text(title),
                  subtitle: Text(
                      'Qty: $quantity${size.isNotEmpty ? ' · Size: $size' : ''}${colour.isNotEmpty ? ' · Colour: $colour' : ''}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove),
                        tooltip: 'Remove one',
                        onPressed: quantityInt > 0
                            ? () async {
                                await (widget.decreaseFn?.call(
                                      title: title,
                                      size: size,
                                      colour: colour,
                                      count: 1,
                                    ) ??
                                    decreaseCartItemQuantity(
                                        title: title,
                                        size: size,
                                        colour: colour,
                                        count: 1));
                                if (!mounted) return;
                                setState(() => _loadCart());
                              }
                            : null,
                      ),
                      Text('$quantityInt'),
                      IconButton(
                        icon: const Icon(Icons.add),
                        tooltip: 'Add one',
                        onPressed: () async {
                          await (widget.increaseFn?.call(
                                title: title,
                                size: size,
                                colour: colour,
                                count: 1,
                              ) ??
                              increaseCartItemQuantity(
                                  title: title,
                                  size: size,
                                  colour: colour,
                                  count: 1));
                          if (!mounted) return;
                          setState(() => _loadCart());
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        tooltip: 'Remove all',
                        onPressed: () async {
                          final confirmed = await showDialog<bool>(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: const Text('Remove item'),
                              content:
                                  const Text('Remove this item from the cart?'),
                              actions: [
                                TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, false),
                                    child: const Text('Cancel')),
                                TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, true),
                                    child: const Text('Remove')),
                              ],
                            ),
                          );
                          if (confirmed == true) {
                            await (widget.removeFn?.call(
                                    title: title, size: size, colour: colour) ??
                                removeCartItem(
                                    title: title, size: size, colour: colour));
                            if (!mounted) return;
                            setState(() => _loadCart());
                          }
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
