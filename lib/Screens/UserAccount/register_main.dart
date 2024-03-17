import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uperitivo/Controller/user_firebase_controller.dart';
import 'package:uperitivo/Models/user_model.dart';
import 'package:uperitivo/Screens/AddEvent/image_picker.dart';
import 'package:uperitivo/Screens/Components/cBButton.dart';
import 'package:uperitivo/Screens/Components/drawer_screen.dart';
import 'package:uperitivo/Screens/Components/footer.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
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
  String adImage = "";

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
  late TextEditingController capController;
  late TextEditingController mobileController;
  late TextEditingController emailController;
  late TextEditingController siteController;
  late TextEditingController cfController;
  late TextEditingController imageController;
  late TextEditingController passwordController;
  late TextEditingController confirmPasswordController;
  File? pickedImage;

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
    capController = TextEditingController();
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
    adImage = await RegisterController().getAdImage(context);
    print(adImage);
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
    capController.dispose();
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
    capController.text = '';
    mobileController.text = '';
    emailController.text = '';
    siteController.text = '';
    cfController.text = '';
    imageController.text = '';
    passwordController.text = '';
    confirmPasswordController.text = '';
    pickedImage = null;
  }

  bool isStringDigitsAndLength(String input, int length) {
    if (input.length != length) {
      return false;
    }

    for (int i = 0; i < input.length; i++) {
      if (!isDigit(input[i])) {
        return false;
      }
    }

    return true;
  }

  bool isDigit(String input) {
    return int.tryParse(input) != null;
  }

  Future<void> registerUser() async {
    String nickname = nicknameController.text.trim();
    String name = nameController.text.trim();
    String cmpName = cmpNameController.text.trim();
    String typeOfActivity = typeOfActivityController.text.trim();
    String surname = surnameController.text.trim();
    String via = viaController.text.trim();
    String civico = civicoController.text.trim();
    String city = cityController.text.trim();
    String province = provinceController.text.trim();
    String cap = capController.text.trim();
    String mobile = mobileController.text.trim();
    String email = emailController.text.trim();
    String site = siteController.text.trim();
    String cf = cfController.text.trim();
    String password = passwordController.text;
    String confirmPassword = confirmPasswordController.text;
    String image = adImage;

    List<String> requiredFields = [];

    if (firstButtonClicked) {
      requiredFields = [
        nickname,
        name,
        surname,
        via,
        civico,
        city,
        province,
        mobile,
        email,
        password,
        confirmPassword,
        image
      ];
    } else if (secondButtonClicked) {
      requiredFields = [
        cmpName,
        via,
        civico,
        city,
        province,
        cap,
        mobile,
        email,
        password,
        confirmPassword,
        image,
      ];
    }
    if (password != confirmPassword) {
      if (mounted) {
        showErrorSnackBar(context, "Password, Confirm Password not matched!");
      }
      return;
    }
    if (!isStringDigitsAndLength(cap, 11) && secondButtonClicked) {
      if (mounted) {
        showErrorSnackBar(context, "P. IVA must be valid(11 digits)");
      }
      return;
    }
    if (validateInputs(requiredFields) && isValidEmail(email)) {
      if (pickedImage != null) {
        String imagePath = 'users_images/${const Uuid().v4()}';
        await firebase_storage.FirebaseStorage.instance
            .ref(imagePath)
            .putFile(pickedImage!);

        image = await firebase_storage.FirebaseStorage.instance
            .ref(imagePath)
            .getDownloadURL();
      }
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
        cap: cap,
        mobile: mobile,
        email: email,
        site: site,
        cf: cf,
        image: image,
        userType: "userType",
        address: _currentAddress,
        longitude: _currentPosition.longitude,
        latitude: _currentPosition.latitude,
      );

      user.userType = firstButtonClicked ? "person" : "company";
      if (mounted) {
        await registerController.registerUser(user, password, context);
      }
    } else {
      if (mounted) {
        showErrorSnackBar(
            context, "Fill all required* fields or enter a valid email");
      }
    }
  }

  bool isValidEmail(String email) {
    RegExp emailRegExp = RegExp(
      r"^[a-zA-Z0-9.!#$%&\'*+\/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$",
    );
    return emailRegExp.hasMatch(email);
  }

  bool validateInputs(List<String> fields) {
    for (String field in fields) {
      if (field.isEmpty) {
        return false;
      }
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
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
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                firstButtonClicked = true;
                                secondButtonClicked = false;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: firstButtonClicked
                                  ? Colors.white
                                  : Colors.black,
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
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  'Privato',
                                  maxLines: 1,
                                  style: TextStyle(
                                    overflow: TextOverflow.ellipsis,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Flexible(
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                secondButtonClicked = true;
                                firstButtonClicked = false;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: secondButtonClicked
                                  ? Colors.white
                                  : Colors.black,
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
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  'Esercente',
                                  maxLines: 1,
                                  style: TextStyle(
                                    overflow: TextOverflow.ellipsis,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (!firstButtonClicked &&
                      !secondButtonClicked &&
                      adImage.isNotEmpty)
                    Image.network(adImage),
                  if (firstButtonClicked || secondButtonClicked)
                    const Padding(
                      padding: EdgeInsets.only(left: 16),
                      child: Row(
                        children: [
                          Text(
                            "*Campi obbligatori",
                            style: TextStyle(
                                fontSize: 14, color: Color(0xff7E84A3)),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(
                    height: 20,
                  ),
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
                          // CustomTextField(
                          //   labelText: 'Tipologia di locale',
                          //   controller: typeOfActivityController,
                          // ),
                          DropdownWidget(
                            controller: typeOfActivityController,
                            defaultLabelText: 'Tipologia di locale',
                          ),
                        const SizedBox(height: 16),
                        if (firstButtonClicked)
                          Row(
                            children: [
                              Expanded(
                                child: CustomTextField(
                                  labelText: 'Nome*',
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                flex: 7,
                                child: CustomTextField(
                                  labelText: 'Città*',
                                  controller: cityController,
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                flex: 3,
                                child: CustomTextField(
                                  labelText: 'CAP*',
                                  controller: capController,
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
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
                            obscureText: true,
                          ),
                        const SizedBox(height: 16),
                        if (firstButtonClicked || secondButtonClicked)
                          CustomTextField(
                            labelText: 'Confirm Password*',
                            controller: confirmPasswordController,
                            obscureText: true,
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
                            labelText: 'P. IVA*',
                            controller: cfController,
                            isNumbers: true,
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
                                onImagePicked: (image) {
                                  pickedImage = File(image.path);
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
  final bool obscureText;
  final bool isNumbers;

  const CustomTextField({
    Key? key,
    required this.labelText,
    required this.controller,
    this.obscureText = false,
    this.isNumbers = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: obscureText,
      keyboardType: isNumbers ? TextInputType.number : null,
      controller: controller,
      maxLength: isNumbers ? 11 : null,
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

class DropdownWidget extends StatefulWidget {
  final TextEditingController controller;
  final String defaultLabelText;

  const DropdownWidget({
    super.key,
    required this.controller,
    required this.defaultLabelText,
  });

  @override
  State<DropdownWidget> createState() => _DropdownWidgetState();
}

class _DropdownWidgetState extends State<DropdownWidget> {
  List<String> options = [
    'Bar',
    'Birreria',
    'Enoteca',
    'Osteria',
    'Wine bar',
    'altro*'
  ];
  String selectedOption = 'Bar';
  TextEditingController txtController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: double.infinity,
          child: DropdownButtonFormField<String>(
            value: selectedOption,
            items: options.map((String option) {
              return DropdownMenuItem<String>(
                value: option,
                child: Text(option),
              );
            }).toList(),
            onChanged: (String? value) {
              setState(() {
                selectedOption = value!;
                widget.controller.text = value;
              });
            },
            decoration: InputDecoration(
              labelText: widget.defaultLabelText,
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
          ),
        ),
        if (selectedOption == "altro*")
          Column(
            children: [
              const SizedBox(height: 20),
              TextField(
                controller: txtController,
                onChanged: (value) {
                  widget.controller.text = value;
                },
                decoration: InputDecoration(
                    labelText: 'digitare il tipo di evento personalizzato',
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
                    )),
              ),
            ],
          ),
      ],
    );
  }
}
