import 'package:flutter/material.dart';

class HeaderItem {
  final String label;
  final VoidCallback onPressed;
  const HeaderItem(this.label, this.onPressed);
}

class Header extends StatelessWidget {
  const Header({super.key});
  void navigateToHome(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
  }

  void navigateToProduct(BuildContext context) {
    Navigator.pushNamed(context, '/product');
  }

  void navigateToAboutUs(BuildContext context) {
    Navigator.pushNamed(context, '/aboutus');
  }

  void placeholderCallbackForButtons() {}

  void menuButtonCallback() {}

  List<HeaderItem> buildHeaderItems(BuildContext context) {
    return [
      HeaderItem('Home',
          () => Navigator.pushNamedAndRemoveUntil(context, '/', (r) => false)),
      HeaderItem('Shop', () => Navigator.pushNamed(context, '/product')),
      HeaderItem('The Print Shack', () {}),
      HeaderItem('SALE!', () {}),
      HeaderItem('About Us', () => Navigator.pushNamed(context, '/aboutus')),
    ];
  }

  List<Widget> buildHeaderButtons(BuildContext context) => buildHeaderItems(
          context)
      .map((it) => TextButton(onPressed: it.onPressed, child: Text(it.label)))
      .toList();

  IconButton buildIconButton(IconData icon, VoidCallback onPressed) {
    return IconButton(
      icon: Icon(
        icon,
        size: 18,
        color: Colors.grey,
      ),
      padding: const EdgeInsets.all(8),
      constraints: const BoxConstraints(
        minWidth: 32,
        minHeight: 32,
      ),
      onPressed: onPressed,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      color: Colors.white,
      child: Column(
        children: [
          // Top banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 8),
            color: const Color(0xFF4d2963),
            child: const Text(
              'PLACEHOLDER HEADER TEXT',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
          // Main header
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      navigateToHome(context);
                    },
                    // Logo
                    child: Image.network(
                      'https://shop.upsu.net/cdn/shop/files/upsu_300x300.png?v=1614735854',
                      height: 18,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[300],
                          width: 18,
                          height: 18,
                          child: const Center(
                            child: Icon(Icons.image_not_supported,
                                color: Colors.grey),
                          ),
                        );
                      },
                    ),
                  ),
                  if (MediaQuery.of(context).size.width > 800) ...[
                    for (int i = 0; i < buildHeaderButtons(context).length; i++)
                      buildHeaderButtons(context)[i],
                  ],
                  const Spacer(),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 600),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        buildIconButton(
                            Icons.search, placeholderCallbackForButtons),
                        buildIconButton(Icons.person_outline,
                            placeholderCallbackForButtons),
                        buildIconButton(Icons.shopping_bag_outlined,
                            placeholderCallbackForButtons),
                        if (MediaQuery.of(context).size.width <= 800) ...[
                          PopupMenuButton<HeaderItem>(
                            icon: const Icon(Icons.menu,
                                size: 18, color: Colors.grey),
                            itemBuilder: (ctx) {
                              final items = buildHeaderItems(context);
                              return items
                                  .map((it) => PopupMenuItem<HeaderItem>(
                                      value: it, child: Text(it.label)))
                                  .toList();
                            },
                            onSelected: (item) => item.onPressed(),
                          )
                        ]
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
