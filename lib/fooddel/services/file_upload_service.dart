import 'package:firebase_storage/firebase_storage.dart';
import 'package:mealtrips/fooddel/utility/firestore_collections.dart';
import 'package:uuid/uuid.dart';
import 'dart:io';
import 'package:mealtrips/fooddel/utility/firestore_collections.dart';

Future uploadPhoto(File file) async {
  String id = Uuid().v4();
  UploadTask mStorageUploadTask =
      storageReference.child("image_$id.jpg").putFile(file);
  TaskSnapshot storageTaskSnapshot = await mStorageUploadTask;
  String downloadUrl = await storageTaskSnapshot.ref.getDownloadURL();
  return downloadUrl;
}
