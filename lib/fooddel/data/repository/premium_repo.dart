import 'package:mealtrips/fooddel/data/model/premium_plan.dart';
import 'package:mealtrips/fooddel/utility/firestore_collections.dart';

class PremiumRepo {
  Future<PremiumModel> getPremium() async {
    PremiumModel items;
    await premiumRef.doc("25tqIfGs5H4aXWPBLbd1").get().then((value) {
      items = PremiumModel.fromDocument(value);
      return items;
    });
    return items;
  }
}
