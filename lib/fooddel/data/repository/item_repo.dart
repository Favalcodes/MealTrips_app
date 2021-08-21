import 'package:mealtrips/fooddel/data/model/item_model.dart';
import 'package:mealtrips/fooddel/utility/firestore_collections.dart';

class ItemRepo {
  Future<List<ItemModel>> getitems() async {
    List<ItemModel> items;
    await itemsRef
        .orderBy('timestamp', descending: true)
        .limit(10)
        .get()
        .then((value) {
      items = value.docs
          .map((document) => ItemModel.fromDocument(document))
          .toList();
      return items;
    });
    return items;
  }

    Future<List<ItemModel>> hotMeals() async {
    List<ItemModel> items;
    await itemsRef
        .orderBy('totalOrder', descending: true)
        .limit(10)
        .get()
        .then((value) {
      items = value.docs
          .map((document) => ItemModel.fromDocument(document))
          .toList();
      return items;
    });
    return items;
  }

   Future<List<ItemModel>> topRated() async {
    List<ItemModel> items;
    await itemsRef
        .orderBy('rating', descending: true)
        .limit(10)
        .get()
        .then((value) {
      items = value.docs
          .map((document) => ItemModel.fromDocument(document))
          .toList();
      return items;
    });
    return items;
  }

  Future<List<ItemModel>> catItems(String category) async {
    List<ItemModel> items = [];
     List<ItemModel> filterHolder = [];
    await itemsRef.get().then((value) {
          items = value.docs.map((document) => ItemModel.fromDocument(document)).toList();
          items.forEach((element) {

        RegExp regExp = RegExp("\\b" + category + "\\b", caseSensitive: false);

        if (regExp.hasMatch(element.category)) {
            filterHolder.add(element);
          }
        });
    
      return filterHolder;
    });
    return filterHolder;
  }

  Future<ItemModel> itemDetails(String itemId) async {
    ItemModel items;
    await itemsRef.doc(itemId).get().then((value) {
      items = ItemModel.fromDocument(value);
      return items;
    });
    return items;
  }

  Future<List<ItemModel>> resturantItems(String resId) async {
    List<ItemModel> items;
    await itemsRef.where("resId", isEqualTo: resId).get().then((value) {
      items = value.docs
          .map((document) => ItemModel.fromDocument(document))
          .toList();
      return items;
    });
    return items;
  }
}
