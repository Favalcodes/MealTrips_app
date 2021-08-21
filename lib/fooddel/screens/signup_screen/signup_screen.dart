import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mealtrips/fooddel/components/default_buttons.dart';
import 'package:mealtrips/fooddel/screens/login_screen/login_screen.dart';
import 'package:mealtrips/fooddel/screens/profile_picture/profile_picture.dart';
import 'package:mealtrips/fooddel/services/Authentication.dart';
import 'package:mealtrips/fooddel/services/users_service.dart';
import 'package:mealtrips/size_config.dart';
import 'package:mealtrips/constants.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final List<Map<String, String>> categories = [
    {"title": "Customer  ", "image": "assets/svgs/user.svg"},
    {"title": "Vendor", "image": "assets/svgs/user.svg"},
    {"title": "Delivery", "image": "assets/svgs/user.svg"},
  ];
  final TextEditingController emailController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController vendourNameController = TextEditingController();
  final TextEditingController vendourAddressController =
      TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  
  AuthImplementation auth = Auth();
  String userId;
  int catIndex;
  bool additionalField = false;
  bool showLoader = false;
  int visibleCount = 0;
  Icon visibilityIcon = Icon(Icons.visibility);
  bool obscurePassword = true;


  @override
  void initState() {
    super.initState();
  }


  void btnPressed() async {
    if (catIndex == null) {
      SnackBar snackBar = SnackBar(content: Text("Please select a category."));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      if (catIndex == 0) {
        await handleUserSignUp(
          nameController.text,
          emailController.text.toLowerCase(),
          passwordController.text,
          phoneController.text,
        );
      } else {
        setState(() => additionalField = true);
      }
    }
  }

  Future<void> handleUserSignUp(
      String name, String email, String password, String phone) async {
    setState(() => showLoader = true);
    if (password == "" || email == "") {
      SnackBar snackBar =
          SnackBar(content: Text("Please fill out all fields."));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      try {
        userId = await auth.SignUp(email, password);
        if (userId != null) {
          registerUser(userId, name, email, phone, catIndex, );
          setState(() => userId = userId);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      ProfilePicture(userId, email, name, catIndex)));
        } else {
          SnackBar snackBar =
              SnackBar(content: Text("Email in use, please try another one."));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      } catch (e) {
        SnackBar snackBar = SnackBar(content: Text(e.code.toString()));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }
    setState(() => showLoader = false);
  }

  Future<void> handleVendourSignUp(
      {String name,
      String email,
      String password,
      String address,
      String phone}) async {
    setState(() => showLoader = true);
    if (password == "" || email == "") {
      setState(() => additionalField = false);
      SnackBar snackBar =
          SnackBar(content: Text("Please fill out all fields."));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      try {
        userId = await auth.SignUp(email, password);
        if (userId != null) {
          await registerUser(userId, name, email, phone, catIndex);
         if (catIndex == 1) {
            await vendourReg(userId, name, address, email, phone);
         } else if (catIndex == 2) {
            await deliveryReg(userId, name, address, email, phone);
         }
          setState(() => userId = userId);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      ProfilePicture(userId, email, name, catIndex)));
        } else {
          SnackBar snackBar =
              SnackBar(content: Text("Email in use, please try another one."));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      } catch (e) {
        setState(() => additionalField = false);
        SnackBar snackBar = SnackBar(content: Text(e.message.toString()));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }
    setState(() => showLoader = false);
  }

  void vendourSignup() async {
    await handleVendourSignUp(
        name: vendourNameController.text,
        email: emailController.text,
        password: passwordController.text,
        address: vendourAddressController.text,
        phone: phoneController.text);
  }

  void visibilityChange() {
    visibleCount++;
    if (visibleCount == 1) {
      setState(() {
        obscurePassword = false;
        visibilityIcon = Icon(Icons.visibility_off);
      });
    } else {
      setState(() {
        obscurePassword = true;
        visibilityIcon = Icon(Icons.visibility);
        visibleCount = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Text(
                    catIndex == 1
                        ? "Vendor Registration"
                        : catIndex == 2
                            ? "Delivery Merchant registration"
                            : "Registration",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: SizeConfig.screenWidth * 0.07,
                        color: Theme.of(context).textSelectionColor),
                  ),
                ),
                additionalField
                    ? Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: vendourField(context),
                      )
                    : Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 25),
                        child: Column(
                          children: [
                            SizedBox(height: getProportionateScreenHeight(20)),
                            fullNameTextField(context),
                            SizedBox(height: getProportionateScreenHeight(15)),
                            buildEmailFormField(context),
                            SizedBox(height: getProportionateScreenHeight(15)),
                            buildPhoneFormField(context),
                            SizedBox(height: getProportionateScreenHeight(15)),
                            buildCityField(context),
                            SizedBox(height: getProportionateScreenHeight(15)),
                            buildPasswordFormField(context),
                            SizedBox(height: getProportionateScreenHeight(15)),
                            Text("User Category",
                                style: TextStyle(fontWeight: FontWeight.w700)),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Container(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    ...List.generate(categories.length,
                                        (index) {
                                      return GestureDetector(
                                          onTap: () {
                                            setState(() => catIndex = index);
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              children: [
                                                Container(
                                                  padding: EdgeInsets.all(10),
                                                  height:
                                                      getProportionateScreenHeight(
                                                          60),
                                                  width:
                                                      getProportionateScreenHeight(
                                                          60),
                                                  decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      border: Border.all(
                                                          color: catIndex ==
                                                                  index
                                                              ? Colors.red
                                                              : Theme.of(
                                                                      context)
                                                                  .textSelectionColor)),
                                                  child: SvgPicture.asset(
                                                    categories[index]['image'],
                                                    height:
                                                        getProportionateScreenHeight(
                                                            20),
                                                    width:
                                                        getProportionateScreenHeight(
                                                            20),
                                                    color:catIndex == index
                                                          ? Colors.red
                                                    : Theme.of(context)
                                                        .textSelectionColor
                                                  ),
                                                ),
                                                SizedBox(height: 5),
                                                Text(
                                                  categories[index]['title'],
                                                  style: TextStyle(
                                                      fontSize: SizeConfig
                                                              .screenWidth *
                                                          0.03,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: catIndex == index
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
                            SizedBox(height: getProportionateScreenHeight(15)),
                          ],
                        ),
                      ),
                showLoader
                    ? SizedBox(
                        width: 20.0,
                        height: 20.0,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(Colors.redAccent),
                          strokeWidth: 2.0,
                        ),
                      )
                    : DefaultButton(
                        press: () =>
                            additionalField ? vendourSignup() : btnPressed(),
                        text: catIndex == null
                            ? 'Sign Up'
                            : catIndex == 0
                                ? "Sign Up"
                                : "Continue",
                      ),
                SizedBox(height: getProportionateScreenHeight(20)),
                GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LoginScreen()));
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account?",
                        style: TextStyle(
                            fontSize: getProportionateScreenWidth(18),
                            fontWeight: FontWeight.w500),
                      ),
                      SizedBox(width: 5),
                      Text(
                        "SignIn",
                        style: TextStyle(
                            fontSize: getProportionateScreenWidth(18),
                            fontWeight: FontWeight.bold,
                            color: kPrimaryColor),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget vendourField(BuildContext context) {
    return Container(
      child: Column(
        children: [
          vendourNameFormField(context),
          SizedBox(height: getProportionateScreenHeight(15)),
          vendourAddressFormField(context)
        ],
      ),
    );
  }

  TextFormField buildEmailFormField(context) {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      controller: emailController,
      decoration: InputDecoration(
        isDense: true,
        hintText: 'Enter your email',
        suffixIcon: Icon(Icons.mail_outline),
        labelText: 'Email',
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
            borderSide: BorderSide(color: Theme.of(context).textSelectionColor),
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

  TextFormField fullNameTextField(context) {
    return TextFormField(
      keyboardType: TextInputType.text,
      controller: nameController,
      decoration: InputDecoration(
        isDense: true,
        hintText: 'Enter your name',
        suffixIcon: Icon(Icons.person),
        labelText: 'Full name',
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
            borderSide: BorderSide(color: Theme.of(context).textSelectionColor),
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

  TextFormField buildPasswordFormField(context) {
    return TextFormField(
      obscureText: obscurePassword,
      keyboardType: TextInputType.text,
      controller: passwordController,
      decoration: InputDecoration(
        isDense: true,
        hintText: 'Enter your password',
        labelText: 'Password',
        hintStyle: TextStyle(fontSize: SizeConfig.screenWidth * 0.032),
        labelStyle: TextStyle(fontSize: SizeConfig.screenWidth * 0.032),
        focusColor: kPrimaryColor,
        suffixIcon: IconButton(
            icon: visibilityIcon, onPressed: () => visibilityChange()),
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
            borderSide: BorderSide(color: Theme.of(context).textSelectionColor),
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
   TextFormField buildCityField(context) {
    return TextFormField(
      keyboardType: TextInputType.phone,
      initialValue:"Makurdi",
      readOnly: true,
      decoration: InputDecoration(
        isDense: true,
        hintText: 'City',
        labelText: 'City',
        helperText:'Only available to Makurdi users at the moment.',
        helperStyle:TextStyle(
          fontWeight: FontWeight.w600
        ),
        hintStyle: TextStyle(fontSize: SizeConfig.screenWidth * 0.032),
        labelStyle: TextStyle(fontSize: SizeConfig.screenWidth * 0.032),
        suffixIcon: Icon(Icons.location_city),
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
            borderSide: BorderSide(color: Theme.of(context).textSelectionColor),
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

  TextFormField buildPhoneFormField(context) {
    return TextFormField(
      keyboardType: TextInputType.phone,
      controller: phoneController,
      decoration: InputDecoration(
        isDense: true,
        hintText: 'Phone Number',
        labelText: 'Phone number',
        hintStyle: TextStyle(fontSize: SizeConfig.screenWidth * 0.032),
        labelStyle: TextStyle(fontSize: SizeConfig.screenWidth * 0.032),
        suffixIcon: Icon(Icons.phone),
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
            borderSide: BorderSide(color: Theme.of(context).textSelectionColor),
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

  TextFormField vendourNameFormField(context) {
    return TextFormField(
      keyboardType: TextInputType.text,
      controller: vendourNameController,
      decoration: InputDecoration(
        isDense: true,
        hintText: catIndex == 1 ? 'Resturant name' : "Delivery Merchant name",
        labelText: 'name',
        hintStyle: TextStyle(fontSize: SizeConfig.screenWidth * 0.032),
        labelStyle: TextStyle(fontSize: SizeConfig.screenWidth * 0.032),
        suffixIcon: Icon(Icons.label),
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
            borderSide: BorderSide(color: Theme.of(context).textSelectionColor),
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

  TextFormField vendourAddressFormField(context) {
    return TextFormField(
      keyboardType: TextInputType.text,
      controller: vendourAddressController,
      decoration: InputDecoration(
        isDense: true,
        hintText:
            catIndex == 1 ? 'Resturant Address' : "Delivery Merchant Address",
        labelText: 'Address',
        hintStyle: TextStyle(fontSize: SizeConfig.screenWidth * 0.032),
        labelStyle: TextStyle(fontSize: SizeConfig.screenWidth * 0.032),
        suffixIcon: Icon(Icons.location_on),
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
            borderSide: BorderSide(color: Theme.of(context).textSelectionColor),
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
