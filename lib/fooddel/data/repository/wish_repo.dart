import 'package:mealtrips/fooddel/data/model/item_model.dart';
import 'package:mealtrips/fooddel/utility/firestore_collections.dart';

class WishRepo {
  Future<List<ItemModel>> getWhishes(String userId) async {
    List<ItemModel> items;
    await wishRef.doc(userId).collection("Items").get().then((value) {
      items = value.docs
          .map((document) => ItemModel.fromDocument(document))
          .toList();
      return items;
    });
    return items;
  }
}
