import 'package:flutter/material.dart';

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

  void placeholderCallbackForButtons() {
    
  }

  void menuButtonCallback() {}

  List<Widget> buildHeaderButtons(BuildContext context) {
    return [
      TextButton(
        onPressed: () =>
            Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false),
        child: const Text('Home'),
      ),
      TextButton(
        onPressed: () => Navigator.pushNamed(context, '/product'),
        child: const Text('Product'),
      ),
      TextButton(
        onPressed: () {}, // placeholder
        child: const Text('Shop'),
      ),
      TextButton(
        onPressed: () {}, // placeholder
        child: const Text('The Print Shack'),
      ),
      TextButton(
        onPressed: () {}, // placeholder
        child: const Text('SALE!'),
      ),
      TextButton(
        onPressed: () => Navigator.pushNamed(context, '/aboutus'),
        child: const Text('About Us'),
      ),
    ];
  }
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
                        buildIconButton(Icons.search, placeholderCallbackForButtons),
                        buildIconButton(Icons.person_outline, placeholderCallbackForButtons),
                        buildIconButton(Icons.shopping_bag_outlined, placeholderCallbackForButtons),
                        if (MediaQuery.of(context).size.width <= 800) ...[
                          buildIconButton(Icons.menu, menuButtonCallback),
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
