import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mealtrips/fooddel/components/default_buttons.dart';
import 'package:mealtrips/fooddel/screens/homepage/home_tab.dart';
import 'package:mealtrips/fooddel/screens/vendor/premium_package.dart';
import 'package:mealtrips/fooddel/services/file_upload_service.dart';
import 'package:mealtrips/fooddel/utility/firestore_collections.dart';
import 'package:mealtrips/size_config.dart';
import 'package:uuid/uuid.dart';

class ProfilePicture extends StatefulWidget {
  final int catIndex;
  final String userId;
  final String email;
  final String name;
  ProfilePicture(this.userId, this.email, this.name, this.catIndex);
  @override
  _ProfilePictureState createState() => _ProfilePictureState();
}

class _ProfilePictureState extends State<ProfilePicture> {
  File file;
  String id = Uuid().v4();
  bool isLoading = false;

  void pickImageFromGallery() async {
    print(widget.userId);
    File imageFile = await ImagePicker.pickImage(
        source: ImageSource.gallery, maxHeight: 680, maxWidth: 970);
    setState(() {
      this.file = imageFile;
    });
  }

  void savePhoto(context) async {
    setState(() {
      isLoading = true;
    });

    String downloadUrl = await uploadPhoto(file);
    usersReference.doc(widget.userId).update({"image": downloadUrl});
    setState(() {
      isLoading = false;
      file = null;
    });
    handleView(downloadUrl);
  }

  void handleView(String url) async {
    if (widget.catIndex == 1) {
      resturantRef.doc(widget.userId).update({"image": url});
      if (widget.email == "") {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomeTabs()));
      } else {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PremiumPackage(
                    email: widget.email,
                    name: widget.name,
                    screen: "newUser",
                    userId: widget.userId)));
      }
    } else if (widget.catIndex == 2) {
      deliveryRef.doc(widget.userId).update({"image": url});
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => HomeTabs()));
    } else if (widget.catIndex == 0) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => HomeTabs()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 40.0),
          child: Center(
            child: Column(
              children: [
                SizedBox(height: 100),
                file != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(100.0),
                        child: Container(
                          width: 150.0,
                          height: 150.0,
                          child: Image.file(
                            file,
                            height: 200,
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
                    : CircleAvatar(
                        radius: 80.0,
                        backgroundColor: Colors.grey[300],
                        child: IconButton(
                          icon: Icon(
                            Icons.add_a_photo,
                            size: 40.0,
                            color: Colors.black87,
                          ),
                          onPressed: () => pickImageFromGallery(),
                        ),
                      ),
                SizedBox(height: 5.0),
                Text(
                  widget.catIndex == 0
                      ? "Profile Picture"
                      : widget.catIndex == 1
                          ? "Restuarant picture"
                          : "Delivery service picture",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14.0,
                      color: Theme.of(context).textSelectionColor),
                ),
                SizedBox(height: 20.0),
                isLoading
                    ? SizedBox(
                        width: 20.0,
                        height: 20.0,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(Colors.red),
                          strokeWidth: 3.0,
                        ),
                      )
                    : DefaultButton(
                        press: () {
                          if (file == null) {
                            SnackBar snackBar = SnackBar(
                                content: Text("Please select an image."));
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          } else {
                            savePhoto(context);
                          }
                        },
                        text: "Upload",
                      ),
                SizedBox(height: getProportionateScreenHeight(20)),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.white,
          onPressed: () => pickImageFromGallery(),
          tooltip: "Add Image",
          child: Icon(Icons.add_a_photo, color: Colors.red),
        ));
  }
}
