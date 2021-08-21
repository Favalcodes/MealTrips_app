import 'package:mealtrips/fooddel/data/model/delivery_earnings.dart';
import 'package:mealtrips/fooddel/utility/firestore_collections.dart';

class DeliveryEarningsRepo {
  Future<List<DeliveryEarnings>> getEarnings() async {
    List<DeliveryEarnings> items;
    await deliveryEarningsRef
        .orderBy("timestamp", descending: true)
        .get()
        .then((value) {
      items = value.docs
          .map((document) => DeliveryEarnings.fromDocument(document))
          .toList();
      return items;
    });
    return items;
  }

  Future<List<DeliveryEarnings>> todayEarnings() async {
    List<DeliveryEarnings> items;
    await deliveryEarningsRef
        .where('date', isEqualTo: date)
        .get()
        .then((value) {
      items = value.docs
          .map((document) => DeliveryEarnings.fromDocument(document))
          .toList();
      return items;
    });
    return items;
  }

  Future<List<DeliveryEarnings>> getExtraEarnings() async {
    List<DeliveryEarnings> items;
    await extraEarningsRef
        .orderBy("timestamp", descending: true)
        .get()
        .then((value) {
      items = value.docs
          .map((document) => DeliveryEarnings.fromDocument(document))
          .toList();
      return items;
    });
    return items;
  }

  Future<List<DeliveryEarnings>> todayExtraEarnings() async {
    List<DeliveryEarnings> items;
    await extraEarningsRef
        .where('date', isEqualTo: date)
        .get()
        .then((value) {
      items = value.docs
          .map((document) => DeliveryEarnings.fromDocument(document))
          .toList();
      return items;
    });
    return items;
  }
}
