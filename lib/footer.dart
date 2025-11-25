import 'package:flutter/material.dart';

Widget footerItem(BuildContext context, Widget childContents) {
  final double screenWidth = MediaQuery.of(context).size.width;
  final bool wide = screenWidth >= 800;
  return SizedBox(
      width: wide
          ? 250
          : double.infinity, // fixed card width on wide, full width on narrow
      child: childContents);
}
String openingTimes(){
  return """Opening Hours

❄️ Winter Break Closure Dates ❄️
Closing 4pm 19/12/2025
Reopening 10am 05/01/2026
Last post date: 12pm on 18/12/2025
------------------------
(Term Time)
Monday - Friday 10am - 4pm
(Outside of Term Time / Consolidation Weeks)
Monday - Friday 10am - 3pm
Purchase online 24/7""";
}
class Footer extends StatelessWidget {
  const Footer({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(16),
        color: Colors.grey[200],
        child: Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [footerItem(context, Text(openingTimes()))]));
  }
}
