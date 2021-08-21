import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';

final usersReference = FirebaseFirestore.instance.collection("Users");
final resturantRef = FirebaseFirestore.instance.collection("Vendors");
final deliveryRef = FirebaseFirestore.instance.collection("Delivery");
final reviewsRef = FirebaseFirestore.instance.collection("Reviews");
final itemsRef = FirebaseFirestore.instance.collection("Dishes");
final wishRef = FirebaseFirestore.instance.collection("Wishes");
final cartRef = FirebaseFirestore.instance.collection("Shopping Cart");
final vendorTransactionRef = FirebaseFirestore.instance.collection("Vendor Transaction");
final orderRef = FirebaseFirestore.instance.collection("Order");
final deliveryNotRef = FirebaseFirestore.instance.collection("Delivery notification");
final notificationRef = FirebaseFirestore.instance.collection("Notification");
final vendorNotRef = FirebaseFirestore.instance.collection("Vendor notification");
final orderItemsRef = FirebaseFirestore.instance.collection("Order Items");
final itemsRatingRef = FirebaseFirestore.instance.collection("Items rating");
final resRatingRef = FirebaseFirestore.instance.collection("Vendor rating");
final subscriptionRef = FirebaseFirestore.instance.collection("Subscription");
final deliveryEarningsRef = FirebaseFirestore.instance.collection("Delivery Earnings");
final extraEarningsRef = FirebaseFirestore.instance.collection("Extra Delivery Earnings");
final premiumRef = FirebaseFirestore.instance.collection("Premium plan");

final storageReference = FirebaseStorage.instance.ref().child('Images');
final DateTime timestamp = DateTime.now();
String date = DateFormat('yyyy-MM-dd').format(timestamp);
final  formatter = new NumberFormat("#,###");