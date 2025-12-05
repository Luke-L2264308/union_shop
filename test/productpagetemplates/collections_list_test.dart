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
      // Use a sample that includes a reducedprice so we verify the effective
      // price (reducedprice when present) is used for sorting.
      final samplePrice = [
        {
          'title': 'Banana',
          'price': 2.0,
          'imageLocation': '',
          'routeName': ''
        },
        {
          'title': 'Apple',
          'price': 1.0,
          'imageLocation': '',
          'routeName': ''
        },
        {
          'title': 'Cherry',
          'price': 3.0,
          // Cherry has a reduced price that should make it the cheapest
          'reducedprice': 0.5,
          'imageLocation': '',
          'routeName': ''
        },
      ];

      final widgets = buildProductCards(List<Map<String, dynamic>>.from(samplePrice),
          sortBy: 'priceLowHigh');
      final titles = widgets.map((w) => (w as dynamic).title as String).toList();
      // Effective prices: Cherry(0.5), Apple(1.0), Banana(2.0)
      expect(titles, ['Cherry', 'Apple', 'Banana']);
    });

    test('priceHighLow sorts by price high->low', () {
      final samplePrice = [
        {
          'title': 'Banana',
          'price': 2.0,
          'imageLocation': '',
          'routeName': ''
        },
        {
          'title': 'Apple',
          'price': 1.0,
          'imageLocation': '',
          'routeName': ''
        },
        {
          'title': 'Cherry',
          'price': 3.0,
          // Cherry has a reduced price; effective price is 0.5
          'reducedprice': 0.5,
          'imageLocation': '',
          'routeName': ''
        },
      ];

      final widgets = buildProductCards(List<Map<String, dynamic>>.from(samplePrice),
          sortBy: 'priceHighLow');
      final titles = widgets.map((w) => (w as dynamic).title as String).toList();
      // Effective prices: Banana(2.0), Apple(1.0), Cherry(0.5)
      expect(titles, ['Banana', 'Apple', 'Cherry']);
    });
  });
}
