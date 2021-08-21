import 'package:flutter/material.dart';

class ShippingAddresses {
  final String address;

  ShippingAddresses({
    @required this.address,
  });
}

List <ShippingAddresses> shippingAddresses = [shippingAddress1, shippingAddress2, shippingAddress3];

ShippingAddresses shippingAddress1 = ShippingAddresses(
  address: '4517 Washington Ave. Manchester, Kentucky 39495',
);

ShippingAddresses shippingAddress2 = ShippingAddresses(
  address: '3 Newbridge Court Chino Hills, CA 91709, United States',
);

ShippingAddresses shippingAddress3 = ShippingAddresses(
  address: '51 Riverside Chino Hills, CA 91709, United States',
);



