import 'package:flutter/material.dart';
import 'package:uperitivo/Screens/AddEvent/event_category.dart';
import 'package:uperitivo/Screens/AddEvent/image_picker.dart';
import 'package:uperitivo/Screens/Components/cBButton.dart';
import 'package:uperitivo/Screens/Components/cTBTextField.dart';
import 'package:uperitivo/Screens/Components/drawerScreen.dart';
import 'package:uperitivo/Screens/Components/eventDatePickerRow.dart';
import 'package:uperitivo/Screens/Components/footer.dart';
import 'package:uperitivo/Screens/Components/header.dart';

class AddEventHome extends StatefulWidget {
  const AddEventHome({Key? key}) : super(key: key);

  @override
  State<AddEventHome> createState() => _AddEventHomeState();
}

class _AddEventHomeState extends State<AddEventHome> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  late TextEditingController nicknameController;
  late TextEditingController eventNameController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    eventNameController = TextEditingController();
  }

  void _openDrawer() {
    _scaffoldKey.currentState?.openEndDrawer();
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
              'Crea il tuo evento',
              style: TextStyle(
                color: Color(0xFFA04805),
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CTBTextField(
                      controller: eventNameController,
                      hintText: "TOCAI & BUBU",
                      icon: Icons.edit,
                      textAlign: TextAlign.start,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    EventDateTimePickerRow(
                      dateController: TextEditingController(),
                      timeController: TextEditingController(),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        EventDay(),
                        Category(),
                      ],
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    DCTBTextField(
                      controller: TextEditingController(),
                      hintText: "(max 50 caratteri)",
                      letter: "T",
                      textAlign: TextAlign.start,
                      autoMoveToNextLine: true,
                      characterLimit: 50,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    DCTBTextField(
                      controller: TextEditingController(),
                      hintText: "(max 200 caratteri)",
                      letter: "P",
                      textAlign: TextAlign.start,
                      characterLimit: 200,
                      autoMoveToNextLine: true,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    ImagePickerComponent(),
                    Row(
                      children: [
                        Expanded(
                          child: CustomOutlinedButton(
                            text: 'Resetta',
                            textColor: Colors.red,
                            onPressed: () {},
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: CustomOutlinedButton(
                            text: 'Esci',
                            textColor: const Color(0xFF7E84A3),
                            onPressed: () {},
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    CustomOutlinedButton(
                      text: 'Pubblica',
                      textColor: Colors.white,
                      backgroundColor: const Color(0xff298D17),
                      onPressed: () {},
                    ),
                  ],
                ),
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
