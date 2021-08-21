import 'package:mealtrips/fooddel/data/model/cart_model.dart';
import 'package:mealtrips/fooddel/data/model/rating_model.dart';
import 'package:mealtrips/fooddel/utility/firestore_collections.dart';

class RatingRepo {
  Future<List<RatingModel>> getCart(String itemId) async {
    List<RatingModel> items;
    await itemsRatingRef
        .doc(itemId)
        .collection("Items")
        .orderBy("timestamp", descending: true)
        .get()
        .then((value) {
      items = value.docs
          .map((document) => RatingModel.fromDocument(document))
          .toList();
      return items;
    });
    return items;
  }
}
