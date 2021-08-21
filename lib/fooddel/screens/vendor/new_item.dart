import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mealtrips/fooddel/components/default_buttons.dart';
import 'package:mealtrips/fooddel/screens/vendor/vendor_tab.dart';
import 'package:mealtrips/fooddel/services/file_upload_service.dart';
import 'package:mealtrips/fooddel/utility/firestore_collections.dart';
import 'package:mealtrips/size_config.dart';
import 'package:mealtrips/constants.dart';
import 'package:image_picker/image_picker.dart';

final List<Map<String, String>> categories = [
    {"title": "Lunch", "image": "assets/svgs/launch.svg"},
    {"title": "Break fast", "image": "assets/svgs/breakfast.svg"},
    {"title": "Dinner", "image": "assets/svgs/dinner.svg"},
    {"title": "Smoothies", "image": "assets/svgs/smoothies.svg"},
    {"title": "Cocktails", "image": "assets/svgs/cocktails.svg"},
    {"title": "Salad", "image": "assets/svgs/salad.svg"},
    {"title": "Pastries", "image": "assets/svgs/pastries.svg"},
    {"title": "Fast food", "image": "assets/svgs/fastfood.svg"},
];


class NewItem extends StatefulWidget {
  final String resId;
  NewItem({this.resId});
  @override
  _NewItemState createState() => _NewItemState();
}

class _NewItemState extends State<NewItem> {
  TextEditingController itemNameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  File file;
  int catIndex;
  List tags = [];
  String category;
  bool isLoading = false;

  void uploadItem() async {
    setState(() => isLoading = true);

    tags.forEach((element) {
      category = category +" "+element;
    });

    double price = double.parse(priceController.text);
    if (category != null) {
      if (file != null) {
        String downloadUrl = await uploadPhoto(file);
        itemsRef.doc().set({
          'resId': vendor.id,
          'vendorName':vendor.name,
          'itemName': itemNameController.text,
          'pTime': timeController.text,
          'rateId': {},
          'itemPrice': price,
          'timestamp': timestamp,
          'category': category,
          'image': downloadUrl,
          'description': descriptionController.text,
          'discount': 0,
          'totalOrder':0,
          'rating': 0.0
        });

        setState(() {
          descriptionController.text = "";
          timeController.text = "";
          itemNameController.text = "";
          priceController.text = "";
          file = null;
          tags = [];
        });

        SnackBar snackBar = SnackBar(content: Text("Item saved"));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else {
        SnackBar snackBar = SnackBar(content: Text("Please select item image"));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } else {
      SnackBar snackBar = SnackBar(content: Text("Please select category."));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    setState(() => isLoading = false);
  }

  void pickImage() async {
    File imageFile = await ImagePicker.pickImage(
        source: ImageSource.gallery, maxHeight: 680, maxWidth: 970);
    setState(() {
      this.file = imageFile;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          'Add Dish',
          style: TextStyle(
            color: kBlack,
            fontWeight: FontWeight.bold,
            fontSize: SizeConfig.screenWidth * 0.04,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: kBlack),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 25),
                    child: Column(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width,
                              height: 150.0,
                              color:Colors.grey[300],
                              child: file != null
                                  ? Image.file(file,
                                      height: 150, fit: BoxFit.cover)
                                  : Icon(Icons.image,
                                      size: 30.0, color: Colors.black87),
                            ),
                            SizedBox(height: 10.0),
                            GestureDetector(
                              onTap: () => pickImage(),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(15.0)),
                                width: 50.0,
                                height: 50.0,
                                child: Icon(Icons.add,
                                    size: 30.0, color: Colors.black87),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: getProportionateScreenHeight(30),
                        ),
                        buildNameFormField(context),
                        SizedBox(
                          height: getProportionateScreenHeight(30),
                        ),
                        buildPriceFormField(context),
                        SizedBox(
                          height: getProportionateScreenHeight(30),
                        ),
                        buildTimeField(context),
                        SizedBox(
                          height: getProportionateScreenHeight(30),
                        ),
                        buildDescriptionField(context),
                      ],
                    ),
                  ),
                  Text("Item category",
                      style: TextStyle(fontWeight: FontWeight.w700)),
                      Text("You can select multiple category",
                      style: TextStyle(color:Theme.of(context).hintColor, fontSize:10.0)),

                      SizedBox(height: 10.0),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ...List.generate(categories.length, (index) {
                            return GestureDetector(
                                onTap: () {
                                  setState(() =>
                                      category = categories[index]['title']);
                                  if (tags
                                      .contains(categories[index]['title'])) {
                                    tags.remove(categories[index]['title']);
                                  } else {
                                    tags.add(categories[index]['title']);
                                  }
                                  setState(() => tags = tags);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(10),
                                        height:
                                            getProportionateScreenHeight(60),
                                        width: getProportionateScreenHeight(60),
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                                color: tags.contains(
                                                        categories[index]
                                                            ['title'])
                                                    ? Colors.red
                                                    : Theme.of(context)
                                                        .textSelectionColor)),
                                        child: SvgPicture.asset(
                                          categories[index]['image'],
                                          height:
                                              getProportionateScreenHeight(20),
                                          width:
                                              getProportionateScreenHeight(20),
                                          color:tags.contains(
                                                        categories[index]
                                                            ['title'])
                                                    ? Colors.red
                                                    :Theme.of(context)
                                              .textSelectionColor,
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        categories[index]['title'],
                                        style: TextStyle(
                                            fontSize:
                                                SizeConfig.screenWidth * 0.03,
                                            fontWeight: FontWeight.w500,
                                            color: tags.contains(
                                                    categories[index]['title'])
                                                ? Colors.red
                                                : Theme.of(context)
                                                    .textSelectionColor),
                                      )
                                    ],
                                  ),
                                ));
                          }),
                        ],
                      ),
                    ),
                  ),
                  
                  SizedBox(height: getProportionateScreenHeight(40)),
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
                          press: () => uploadItem(),
                          text: 'Save Item',
                        ),
                  SizedBox(
                    height: getProportionateScreenHeight(20),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  TextFormField buildNameFormField(context) {
    return TextFormField(
      keyboardType: TextInputType.text,
      controller: itemNameController,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        isDense: true,
        hintText: 'Name',
        suffixIcon: Icon(Icons.label),
        labelText: 'Item name',
        hintStyle: TextStyle(fontSize: SizeConfig.screenWidth * 0.032),
        labelStyle: TextStyle(fontSize: SizeConfig.screenWidth * 0.032),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        // contentPadding: EdgeInsets.symmetric(horizontal: SizeConfig.screenWidth * 0.055, vertical: SizeConfig.screenWidth * 0.055),
        enabledBorder: OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(getProportionateScreenWidth(30)),
            borderSide: BorderSide(color: Theme.of(context).hintColor),
            gapPadding: 0),
        focusedBorder: OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(getProportionateScreenWidth(30)),
            borderSide: BorderSide(color: kBlack),
            gapPadding: 0),
        errorBorder: OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(getProportionateScreenWidth(30)),
            borderSide: BorderSide(color: Colors.red),
            gapPadding: 0),
        focusedErrorBorder: OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(getProportionateScreenWidth(20)),
            borderSide: BorderSide(color: Colors.red),
            gapPadding: 0),
      ),
    );
  }

  TextFormField buildDescriptionFormField(context) {
    return TextFormField(
      keyboardType: TextInputType.text,
      controller: descriptionController,
      minLines: 4,
      maxLines: 4,
      decoration: InputDecoration(
        isDense: true,
        hintText: 'Description',
        suffixIcon: Icon(Icons.label),
        labelText: 'Item description',
        hintStyle: TextStyle(fontSize: SizeConfig.screenWidth * 0.032),
        labelStyle: TextStyle(fontSize: SizeConfig.screenWidth * 0.032),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        // contentPadding: EdgeInsets.symmetric(horizontal: SizeConfig.screenWidth * 0.055, vertical: SizeConfig.screenWidth * 0.055),
        enabledBorder: OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(getProportionateScreenWidth(30)),
            borderSide: BorderSide(color: Theme.of(context).hintColor),
            gapPadding: 0),
        focusedBorder: OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(getProportionateScreenWidth(30)),
            borderSide: BorderSide(color: kBlack),
            gapPadding: 0),
        errorBorder: OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(getProportionateScreenWidth(30)),
            borderSide: BorderSide(color: Colors.red),
            gapPadding: 0),
        focusedErrorBorder: OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(getProportionateScreenWidth(20)),
            borderSide: BorderSide(color: Colors.red),
            gapPadding: 0),
      ),
    );
  }

  TextFormField buildTimeField(context) {
    return TextFormField(
      keyboardType: TextInputType.number,
      controller: timeController,
      decoration: InputDecoration(
        isDense: true,
        hintText: 'Packaging time(minutes)',
        labelText: 'Time(minutes)',
        hintStyle: TextStyle(fontSize: SizeConfig.screenWidth * 0.032),
        helperText: "e.g: 2",
        labelStyle: TextStyle(fontSize: SizeConfig.screenWidth * 0.032),
        focusColor: kPrimaryColor,
        suffixIcon: Icon(Icons.timelapse),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        // contentPadding: EdgeInsets.symmetric(horizontal: SizeConfig.screenWidth * 0.055, vertical: SizeConfig.screenWidth * 0.055),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(getProportionateScreenWidth(30)),
          borderSide: BorderSide(color: Theme.of(context).hintColor),
          gapPadding: 0,
        ),
        focusedBorder: OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(getProportionateScreenWidth(30)),
            borderSide: BorderSide(color: kBlack),
            gapPadding: 0),
        errorBorder: OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(getProportionateScreenWidth(30)),
            borderSide: BorderSide(color: Colors.red),
            gapPadding: 0),
        focusedErrorBorder: OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(getProportionateScreenWidth(20)),
            borderSide: BorderSide(color: Colors.red),
            gapPadding: 0),
      ),
    );
  }

  TextFormField buildDescriptionField(context) {
    return TextFormField(
      keyboardType: TextInputType.text,
      controller: descriptionController,
      maxLines: 2,
      minLines: 2,
      maxLength: 70,
      decoration: InputDecoration(
        isDense: true,
        hintText: 'Item Description',
        labelText: 'Description',
        hintStyle: TextStyle(fontSize: SizeConfig.screenWidth * 0.032),
        labelStyle: TextStyle(fontSize: SizeConfig.screenWidth * 0.032),
        focusColor: kPrimaryColor,
        suffixIcon: Icon(Icons.text_fields),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        // contentPadding: EdgeInsets.symmetric(horizontal: SizeConfig.screenWidth * 0.055, vertical: SizeConfig.screenWidth * 0.055),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(getProportionateScreenWidth(30)),
          borderSide: BorderSide(color: Theme.of(context).hintColor),
          gapPadding: 0,
        ),
        focusedBorder: OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(getProportionateScreenWidth(30)),
            borderSide: BorderSide(color: kBlack),
            gapPadding: 0),
        errorBorder: OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(getProportionateScreenWidth(30)),
            borderSide: BorderSide(color: Colors.red),
            gapPadding: 0),
        focusedErrorBorder: OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(getProportionateScreenWidth(20)),
            borderSide: BorderSide(color: Colors.red),
            gapPadding: 0),
      ),
    );
  }

  TextFormField buildPriceFormField(context) {
    return TextFormField(
      keyboardType: TextInputType.number,
      controller: priceController,
      decoration: InputDecoration(
        isDense: true,
        hintText: 'Item price',
        labelText: 'Price',
        hintStyle: TextStyle(fontSize: SizeConfig.screenWidth * 0.032),
        labelStyle: TextStyle(fontSize: SizeConfig.screenWidth * 0.032),
        suffixIcon: Icon(Icons.money),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        // contentPadding: EdgeInsets.symmetric(horizontal: SizeConfig.screenWidth * 0.055, vertical: SizeConfig.screenWidth * 0.055),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(getProportionateScreenWidth(30)),
          borderSide: BorderSide(color: Theme.of(context).hintColor),
          gapPadding: 0,
        ),
        focusedBorder: OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(getProportionateScreenWidth(30)),
            borderSide: BorderSide(color: kBlack),
            gapPadding: 0),
        errorBorder: OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(getProportionateScreenWidth(30)),
            borderSide: BorderSide(color: Colors.red),
            gapPadding: 0),
        focusedErrorBorder: OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(getProportionateScreenWidth(20)),
            borderSide: BorderSide(color: Colors.red),
            gapPadding: 0),
      ),
    );
  }
}
