import 'package:flutter_test/flutter_test.dart';
import 'package:union_shop/productpagetemplates/collections_list.dart';

void main() {
  group('buildProductCards sorting', () {
    final sample = [
      {
        'title': 'Banana',
        'price': '£2.00',
        'imageLocation': '',
        'routeName': ''
      },
      {
        'title': 'Apple',
        'price': '£1.00',
        'imageLocation': '',
        'routeName': ''
      },
      {
        'title': 'Cherry',
        'price': '£3.00',
        'imageLocation': '',
        'routeName': ''
      },
    ];

    test('alphabeticala-z sorts A->Z by title', () {
      final widgets = buildProductCards(List<Map<String, dynamic>>.from(sample),
          sortBy: 'alphabeticala-z');
      final titles = widgets.map((w) {
        // ProductCard is from card_classes and its title is in a Text widget
        final pc = w as dynamic;
        return pc.title as String;
      }).toList();
      expect(titles, ['Apple', 'Banana', 'Cherry']);
    });

    test('alphabeticalz-a sorts Z->A by title', () {
      final widgets = buildProductCards(List<Map<String, dynamic>>.from(sample),
          sortBy: 'alphabeticalz-a');
      final titles =
          widgets.map((w) => (w as dynamic).title as String).toList();
      expect(titles, ['Cherry', 'Banana', 'Apple']);
    });

    test('priceLowHigh sorts by price low->high', () {
      final widgets = buildProductCards(List<Map<String, dynamic>>.from(sample),
          sortBy: 'priceLowHigh');
      final titles =
          widgets.map((w) => (w as dynamic).title as String).toList();
      expect(titles, ['Apple', 'Banana', 'Cherry']);
    });

    test('priceHighLow sorts by price high->low', () {
      final widgets = buildProductCards(List<Map<String, dynamic>>.from(sample),
          sortBy: 'priceHighLow');
      final titles =
          widgets.map((w) => (w as dynamic).title as String).toList();
      expect(titles, ['Cherry', 'Banana', 'Apple']);
    });
  });
}
