import 'package:flutter/material.dart';
import 'package:union_shop/headerandfooter/footer.dart';
import 'package:union_shop/headerandfooter/header.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  final String textDisplay = ('''Welcome to the Union Shop!

We’re dedicated to giving you the very best University branded products, with a range of clothing and merchandise available to shop all year round! We even offer an exclusive personalisation service!

All online purchases are available for delivery or instore collection!


We hope you enjoy our products as much as we enjoy offering them to you. If you have any questions or comments, please don’t hesitate to contact us at hello@upsu.net.


Happy shopping!


The Union Shop & Reception Team​​​​​​​​​.
''');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Header(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Center(
                child: Column(
                  children: [
                    const Text(
                      'About Us',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    Text(textDisplay),
                    if (MediaQuery.of(context).size.width < 800) ...[
                      const Footer(),
                    ],
                  ],
                ),
              ),
            ),
            
          )
        , if (MediaQuery.of(context).size.width >= 800) ...[
                      const Footer(),],
      ],),
    );
  }
}
