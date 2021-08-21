import 'package:flutter/material.dart';

class FilterCategory {
  final String category;

  FilterCategory({
    @required this.category,
  });
}

List <FilterCategory> visits = [filterCategory1, filterCategory2, filterCategory3];

FilterCategory filterCategory1 = FilterCategory(
  category: '4517 Washington Ave. Manchester, Kentucky 39495',
);

FilterCategory filterCategory2 = FilterCategory(
  category: '4517 Washington Ave. Manchester, Kentucky 39495',
);

FilterCategory filterCategory3 = FilterCategory(
  category: '4517 Washington Ave. Manchester, Kentucky 39495',
);

class FilterTypes {
  final String filterType;

  FilterTypes({
    @required this.filterType,
  });
}

List <FilterTypes> filterTypes = [filterTypes1, filterTypes2, filterTypes3, filterTypes4, filterTypes5, filterTypes6];

FilterTypes filterTypes1 = FilterTypes(
  filterType: 'Pizza',
);

FilterTypes filterTypes2 = FilterTypes(
  filterType: 'BBQ',
);

FilterTypes filterTypes3 = FilterTypes(
  filterType: 'Bread',
);
FilterTypes filterTypes4 = FilterTypes(
  filterType: 'Meat',
);
FilterTypes filterTypes5 = FilterTypes(
  filterType: 'Water',
);
FilterTypes filterTypes6 = FilterTypes(
  filterType: 'Burger',
);


class FilterPrice {
  final String price;

  FilterPrice({
    @required this.price,
  });
}

List <FilterPrice> filterPrice = [filterPrice1, filterPrice2, filterPrice3];

FilterPrice filterPrice1 = FilterPrice(
  price: '< \$4',
);

FilterPrice filterPrice2 = FilterPrice(
  price: '> \$11',
);

FilterPrice filterPrice3 = FilterPrice(
  price: '< \$30',
);