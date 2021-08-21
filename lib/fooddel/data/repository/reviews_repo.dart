import 'package:mealtrips/fooddel/data/model/rating_model.dart';
import 'package:mealtrips/fooddel/utility/firestore_collections.dart';

class ReviewsRepo {
  Future<List<RatingModel>> getItemReviews(String itemId) async {
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

  Future<List<RatingModel>> getResReviews(String resId) async {
    List<RatingModel> items;
    await resRatingRef
        .doc(resId)
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
