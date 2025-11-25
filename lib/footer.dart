import 'package:flutter/material.dart';

Widget footerItem(double size, BuildContext context, Widget childContents) {
  final double screenWidth = MediaQuery.of(context).size.width;
  final bool wide = screenWidth >= 800;
  return SizedBox(
      width: wide
          ? size
          : double.infinity, // fixed card width on wide, full width on narrow
      child: childContents);
}

Widget openingTimes() {
  return const Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'Opening Hours',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      SizedBox(height: 8),
      Text(
        '❄️ Winter Break Closure Dates ❄️\n'
        'Closing 4pm 19/12/2025\n'
        'Reopening 10am 05/01/2026\n'
        'Last post date: 12pm on 18/12/2025\n'
        '------------------------\n'
        '(Term Time)\n'
        'Monday - Friday 10am - 4pm\n'
        '(Outside of Term Time / Consolidation Weeks)\n'
        'Monday - Friday 10am - 3pm\n'
        'Purchase online 24/7',
      ),
    ],
  );
}

void searchButtonClick() {
  // Placeholder for search button functionality
}

Widget helpAndInformationContents() {
  return const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Text(
      'Help & Information',
      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    ),
    TextButton(onPressed: searchButtonClick, child: Text('Search')),
  ]);
}

Widget latestOffersContents() {
  return const Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text( 
        'Latest Offers',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Enter your email',
              ),
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(width: 8),
          FilledButton(onPressed: searchButtonClick, child: Text('Subscribe')),
        ],
      ),
    ],
  );
}

class Footer extends StatelessWidget {
  const Footer({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(
          horizontal: (() {
            final double screenWidth = MediaQuery.of(context).size.width;
            const double minPad = 16.0;
            // total fixed widths of the footer items plus Wrap spacing (adjust if you change items)
            const double contentWidth = 250 + 250 + 400 + 12 * 2;
            final double sideSpace = (screenWidth - contentWidth) / 2;
            return sideSpace > minPad ? sideSpace : minPad;
          })(),
          vertical: 16,
        ),
        color: Colors.grey[200],
        child: Wrap(spacing: 12, runSpacing: 12, children: [
          footerItem(250, context, openingTimes()),
          footerItem(250, context, helpAndInformationContents()),
          footerItem(400, context, latestOffersContents())
        ]));
  }
}
