//check vendor subscription
import 'package:mealtrips/fooddel/data/model/vendor_model.dart';
import 'package:mealtrips/fooddel/utility/firestore_collections.dart';

void checkSubscription(VendorModel vendor) {
  DateTime subDate = DateTime.parse(vendor.subDate);
  int plan = vendor.plan;
  int remainingSub = DateTime.now().difference(subDate).inDays;
  if (plan == 0) {
    if (remainingSub > 365) {
      expiredSubscription(vendor.id);
    }
  } else if (plan == 1) {
    if (remainingSub > 90) {
      expiredSubscription(vendor.id);
    }
  } else if (plan == 2){
    if (remainingSub > 180) {
      expiredSubscription(vendor.id);
    }
  } else if (plan == 3) {
    if (remainingSub > 365) {
      expiredSubscription(vendor.id);
    }
  }
}

void expiredSubscription(String resId) {
  resturantRef.doc(resId).update({
    'premium': false,
  });
}
