import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uperitivo/Controller/user_firebase_controller.dart';
import 'package:uperitivo/Models/user_model.dart';
import 'package:uperitivo/Screens/AddEvent/image_picker.dart';
import 'package:uperitivo/Screens/Components/cBButton.dart';
import 'package:uperitivo/Screens/Components/drawerScreen.dart';
import 'package:uperitivo/Screens/Components/footer.dart';
import 'package:uperitivo/Screens/Components/get_location.dart';
import 'package:uperitivo/Screens/Components/header.dart';
import 'package:uperitivo/Utils/helpers.dart';
import 'package:uuid/uuid.dart';

class RegisterMain extends StatefulWidget {
  const RegisterMain({Key? key}) : super(key: key);

  @override
  State<RegisterMain> createState() => _RegisterMainState();
}

class _RegisterMainState extends State<RegisterMain> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  GoogleMapController? _mapController;
  Position _currentPosition = Position(
      longitude: 0.0,
      latitude: 0.0,
      timestamp: DateTime.now(),
      accuracy: 0.0,
      altitude: 0.0,
      altitudeAccuracy: 0.0,
      heading: 0.0,
      headingAccuracy: 0.0,
      speed: 0.0,
      speedAccuracy: 0.0);
  String _currentAddress = "";

  void _openDrawer() {
    _scaffoldKey.currentState?.openEndDrawer();
  }

  bool firstButtonClicked = false;
  bool secondButtonClicked = false;

  late TextEditingController nicknameController;
  late TextEditingController nameController;
  late TextEditingController cmpNameController;
  late TextEditingController typeOfActivityController;
  late TextEditingController surnameController;
  late TextEditingController viaController;
  late TextEditingController civicoController;
  late TextEditingController cityController;
  late TextEditingController provinceController;
  late TextEditingController mobileController;
  late TextEditingController emailController;
  late TextEditingController siteController;
  late TextEditingController cfController;
  late TextEditingController imageController;
  late TextEditingController passwordController;
  late TextEditingController confirmPasswordController;

  @override
  void initState() {
    super.initState();
    nicknameController = TextEditingController();
    nameController = TextEditingController();
    cmpNameController = TextEditingController();
    typeOfActivityController = TextEditingController();
    surnameController = TextEditingController();
    viaController = TextEditingController();
    civicoController = TextEditingController();
    cityController = TextEditingController();
    provinceController = TextEditingController();
    mobileController = TextEditingController();
    emailController = TextEditingController();
    siteController = TextEditingController();
    cfController = TextEditingController();
    imageController = TextEditingController();
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
    _getUserLocation();
  }

  void _getUserLocation() async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      try {
        Position position = await Geolocator.getCurrentPosition();
        setState(() {
          _currentPosition = position;
        });
        _getAddressFromCoordinates(position.latitude, position.longitude);
      } catch (e) {
        print('Error: $e');
      }
    } else {
      print('Location permission denied.');
    }
  }

  void _getAddressFromCoordinates(double latitude, double longitude) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks[0];
        String address = placemark.street ?? '';
        String city = placemark.locality ?? '';
        String state = placemark.administrativeArea ?? '';
        String country = placemark.country ?? '';

        setState(() {
          _currentAddress = '$address, $city, $state, $country';
        });
        print(_currentAddress);
      }
    } catch (e) {
      print('Error getting address: $e');
    }
  }

  @override
  void dispose() {
    nicknameController.dispose();
    nameController.dispose();
    surnameController.dispose();
    viaController.dispose();
    civicoController.dispose();
    cityController.dispose();
    provinceController.dispose();
    mobileController.dispose();
    emailController.dispose();
    siteController.dispose();
    cfController.dispose();
    imageController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void resetControllers() {
    nicknameController.text = '';
    nameController.text = '';
    cmpNameController.text = '';
    typeOfActivityController.text = '';
    surnameController.text = '';
    viaController.text = '';
    civicoController.text = '';
    cityController.text = '';
    provinceController.text = '';
    mobileController.text = '';
    emailController.text = '';
    siteController.text = '';
    cfController.text = '';
    imageController.text = '';
    passwordController.text = '';
    confirmPasswordController.text = '';
  }

  Future<void> registerUser() async {
    String nickname = nicknameController.text;
    String name = nameController.text;
    String cmpName = cmpNameController.text;
    String typeOfActivity = typeOfActivityController.text;
    String surname = surnameController.text;
    String via = viaController.text;
    String civico = civicoController.text;
    String city = cityController.text;
    String province = provinceController.text;
    String mobile = mobileController.text;
    String email = emailController.text;
    String site = siteController.text;
    String cf = cfController.text;
    String image = imageController.text;
    String password = passwordController.text;
    String confirmPassword = confirmPasswordController.text;

    RegisterController registerController = RegisterController();
    var uuid = const Uuid();
    var v4 = uuid.v4();
    UserModel user = UserModel(
        uid: v4,
        nickname: nickname,
        name: name,
        cmpName: cmpName,
        typeOfActivity: typeOfActivity,
        surname: surname,
        via: via,
        civico: civico,
        city: city,
        province: province,
        mobile: mobile,
        email: email,
        site: site,
        cf: cf,
        image: image,
        userType: "userType",
        address: _currentAddress,
        longitude: _currentPosition.longitude,
        latitude: _currentPosition.latitude);

    if (firstButtonClicked) {
      if (nickname.isNotEmpty &&
          name.isNotEmpty &&
          surname.isNotEmpty &&
          via.isNotEmpty &&
          civico.isNotEmpty &&
          city.isNotEmpty &&
          province.isNotEmpty &&
          mobile.isNotEmpty &&
          email.isNotEmpty &&
          password.isNotEmpty &&
          confirmPassword.isNotEmpty) {
        if (password != confirmPassword) {
          showErrorSnackBar(context, "Password,Confirm Password not matched!");
        } else {
          user.userType = "person";
          await registerController.registerUser(user, password, context);
        }
      } else {
        showErrorSnackBar(context, "fill all required* fields");
      }
    } else if (secondButtonClicked) {
      if (cmpName.isNotEmpty &&
          via.isNotEmpty &&
          civico.isNotEmpty &&
          city.isNotEmpty &&
          province.isNotEmpty &&
          mobile.isNotEmpty &&
          email.isNotEmpty &&
          password.isNotEmpty &&
          confirmPassword.isNotEmpty &&
          image.isNotEmpty) {
        if (password != confirmPassword) {
          showErrorSnackBar(context, "Password,Confirm Password not matched!");
        } else {
          user.userType = "company";
          await registerController.registerUser(user, password, context);
        }
      } else {
        showErrorSnackBar(context, "fill all required* fields");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKey,
      drawerEnableOpenDragGesture: false,
      body: Column(
        children: [
          Header(
            onIconTap: () {},
            onDrawerTap: () {
              _openDrawer();
            },
          ),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Crea o modifica\n   il tuo profilo',
              style: TextStyle(
                color: Color(0xFFA04805),
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        firstButtonClicked = true;
                        secondButtonClicked = false;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor:
                          firstButtonClicked ? Colors.white : Colors.black,
                      backgroundColor: firstButtonClicked
                          ? const Color(0xFFEC6500)
                          : Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        side: const BorderSide(
                          color: Color(0xFFEC6500),
                        ),
                      ),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 24,
                      ),
                      child: Text(
                        'Privato',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        secondButtonClicked = true;
                        firstButtonClicked = false;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor:
                          secondButtonClicked ? Colors.white : Colors.black,
                      backgroundColor: secondButtonClicked
                          ? const Color(0xFFEC6500)
                          : Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        side: const BorderSide(
                          color: Color(0xFFEC6500),
                        ),
                      ),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 24,
                      ),
                      child: Text(
                        'Esercente',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (!firstButtonClicked && !secondButtonClicked)
            Image.asset('assets/images/placeholder_register_image.png'),
          if (firstButtonClicked || secondButtonClicked)
            const Padding(
              padding: EdgeInsets.only(left: 16),
              child: Row(
                children: [
                  Text(
                    "*Campi obbligatori",
                    style: TextStyle(fontSize: 14, color: Color(0xff7E84A3)),
                  ),
                ],
              ),
            ),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Column(
                      children: [
                        if (firstButtonClicked)
                          CustomTextField(
                            labelText: 'Nickname*',
                            controller: nicknameController,
                          ),
                        if (secondButtonClicked)
                          CustomTextField(
                            labelText: 'Ragione sociale*',
                            controller: cmpNameController,
                          ),
                        const SizedBox(height: 16),
                        if (secondButtonClicked)
                          CustomTextField(
                            labelText: 'Tipologia di locale',
                            controller: typeOfActivityController,
                          ),
                        const SizedBox(height: 16),
                        if (firstButtonClicked)
                          Row(
                            children: [
                              Expanded(
                                child: CustomTextField(
                                  labelText: 'Name*',
                                  controller: nameController,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: CustomTextField(
                                  labelText: 'Cognome*',
                                  controller: surnameController,
                                ),
                              ),
                            ],
                          ),
                        const SizedBox(height: 16),
                        if (firstButtonClicked || secondButtonClicked)
                          Row(
                            children: [
                              Expanded(
                                flex: 7,
                                child: CustomTextField(
                                  labelText: 'Via*',
                                  controller: viaController,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                flex: 3,
                                child: CustomTextField(
                                  labelText: 'Civico*',
                                  controller: civicoController,
                                ),
                              ),
                            ],
                          ),
                        const SizedBox(height: 16),
                        if (firstButtonClicked || secondButtonClicked)
                          Row(
                            children: [
                              Expanded(
                                flex: 7,
                                child: CustomTextField(
                                  labelText: 'Città*',
                                  controller: cityController,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                flex: 3,
                                child: CustomTextField(
                                  labelText: 'Prov.*',
                                  controller: provinceController,
                                ),
                              ),
                            ],
                          ),
                        const SizedBox(height: 16),
                        if (firstButtonClicked || secondButtonClicked)
                          CustomTextField(
                            labelText: 'Mobile*',
                            controller: mobileController,
                          ),
                        const SizedBox(height: 16),
                        if (firstButtonClicked || secondButtonClicked)
                          CustomTextField(
                            labelText: 'E-mail*',
                            controller: emailController,
                          ),
                        const SizedBox(height: 16),
                        if (firstButtonClicked || secondButtonClicked)
                          CustomTextField(
                            labelText: 'Password*',
                            controller: passwordController,
                          ),
                        const SizedBox(height: 16),
                        if (firstButtonClicked || secondButtonClicked)
                          CustomTextField(
                            labelText: 'Confirm Password*',
                            controller: confirmPasswordController,
                          ),
                        const SizedBox(height: 16),
                        if (secondButtonClicked)
                          CustomTextField(
                            labelText: 'Sito web',
                            controller: siteController,
                          ),
                        const SizedBox(height: 16),
                        if (secondButtonClicked)
                          CustomTextField(
                            labelText: 'P. IVA / C.F.*',
                            controller: cfController,
                          ),
                        const SizedBox(height: 16),
                        if (firstButtonClicked || secondButtonClicked)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  firstButtonClicked
                                      ? "Profile image"
                                      : "Default Image",
                                  style: const TextStyle(
                                    color: Color(0xFF7E84A3),
                                  ),
                                ),
                              ),
                              ImagePickerComponent(
                                onImagePicked: (base64Value) {
                                  imageController.text = base64Value;
                                },
                              ),
                            ],
                          ),
                        const SizedBox(height: 16),
                        if (firstButtonClicked || secondButtonClicked)
                          CustomOutlinedButton(
                            text: 'Salva',
                            textColor: Colors.white,
                            backgroundColor: const Color(0xff298D17),
                            onPressed: () async {
                              await registerUser();
                            },
                          ),
                        const SizedBox(height: 16),
                        if (firstButtonClicked || secondButtonClicked)
                          Row(
                            children: [
                              Expanded(
                                child: CustomOutlinedButton(
                                  text: 'Cancella il tuo profilo',
                                  textColor: Colors.red,
                                  onPressed: () {
                                    resetControllers();
                                  },
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: CustomOutlinedButton(
                                  text: 'Esci',
                                  textColor: const Color(0xFF354052),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Footer()
        ],
      ),
      endDrawer: const DrawerScreen(),
    );
  }
}

class CustomTextField extends StatelessWidget {
  final String labelText;
  final TextEditingController controller;

  const CustomTextField({
    Key? key,
    required this.labelText,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      cursorColor: Colors.black,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(
          color: Color(0xFF7E84A3),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(
            color: Color(0xFF707070),
            width: 1.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(
            color: Color(0xFF707070),
            width: 1.0,
          ),
        ),
      ),
    );
  }
}
