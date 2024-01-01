import 'package:flutter/material.dart';
import 'package:uperitivo/Screens/Components/drawerScreen.dart';
import 'package:uperitivo/Screens/Components/footer.dart';
import 'package:uperitivo/Screens/Components/header.dart';

class RegisterMain extends StatefulWidget {
  const RegisterMain({Key? key}) : super(key: key);

  @override
  State<RegisterMain> createState() => _RegisterMainState();
}

class _RegisterMainState extends State<RegisterMain> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  void _openDrawer() {
    _scaffoldKey.currentState?.openEndDrawer();
  }

  bool firstButtonClicked = false;
  bool secondButtonClicked = false;

  late TextEditingController nicknameController;
  late TextEditingController nameController;
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

  @override
  void initState() {
    super.initState();
    nicknameController = TextEditingController();
    nameController = TextEditingController();
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
    super.dispose();
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
                          color: Color(0xFFEC6500), // Border color
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
                            controller: nicknameController,
                          ),
                        const SizedBox(height: 16),
                        if (secondButtonClicked)
                          CustomTextField(
                            labelText: 'Tipologia di locale',
                            controller: nicknameController,
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
                        if (secondButtonClicked)
                          CustomTextField(
                            labelText: 'Default image',
                            controller: imageController,
                          ),
                        const SizedBox(height: 16),
                        // Buttons
                        if (firstButtonClicked || secondButtonClicked)
                          CustomOutlinedButton(
                            text: 'Salva',
                            textColor: Colors.white,
                            backgroundColor: const Color(0xff298D17),
                            onPressed: () {},
                          ),
                        const SizedBox(height: 16),
                        if (firstButtonClicked || secondButtonClicked)
                          Row(
                            children: [
                              Expanded(
                                child: CustomOutlinedButton(
                                  text: 'Cancella il tuo profilo',
                                  textColor: Colors.red,
                                  onPressed: () {},
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: CustomOutlinedButton(
                                  text: 'Esci',
                                  textColor: const Color(0xFF354052),
                                  onPressed: () {},
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

class CustomOutlinedButton extends StatelessWidget {
  final String text;
  final Color textColor;
  final Color backgroundColor;
  final VoidCallback onPressed;

  const CustomOutlinedButton({
    Key? key,
    required this.text,
    required this.textColor,
    this.backgroundColor = Colors.white,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: backgroundColor,
          border: Border.all(
            color: backgroundColor == Colors.white
                ? const Color(0xFFD5D7E3)
                : backgroundColor,
            width: 2,
          ),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
