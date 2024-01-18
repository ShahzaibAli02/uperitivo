import 'package:flutter/material.dart';
import 'package:uperitivo/Controller/user_firebase_controller.dart';
import 'package:uperitivo/Models/event_model.dart';
import 'package:uperitivo/Screens/AddEvent/event_category.dart';
import 'package:uperitivo/Screens/AddEvent/event_day.dart';
import 'package:uperitivo/Screens/AddEvent/image_picker.dart';
import 'package:uperitivo/Screens/Components/cBButton.dart';
import 'package:uperitivo/Screens/Components/cTBTextField.dart';
import 'package:uperitivo/Screens/Components/drawerScreen.dart';
import 'package:uperitivo/Screens/Components/eventDatePickerRow.dart';
import 'package:uperitivo/Screens/Components/footer.dart';
import 'package:uperitivo/Screens/Components/header.dart';
import 'package:uperitivo/Utils/helpers.dart';
import 'package:uuid/uuid.dart';

class AddEventHome extends StatefulWidget {
  const AddEventHome({Key? key}) : super(key: key);

  @override
  State<AddEventHome> createState() => _AddEventHomeState();
}

class _AddEventHomeState extends State<AddEventHome> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  late TextEditingController eventNameController;
  late TextEditingController descriptionController;
  late TextEditingController eventDateController;
  late TextEditingController eventTimeController;
  late TextEditingController ueventDateController;
  late TextEditingController ueventTimeController;
  late TextEditingController imageController;
  String eventDate = "";
  String eventTime = "";
  bool isUniqueEvent = false;
  String eventDay = "";
  String dateFinalAt = "";
  String category = "";
  String categoryColor = "";

  @override
  void initState() {
    super.initState();
    eventNameController = TextEditingController();
    descriptionController = TextEditingController();
    eventDateController = TextEditingController();
    eventTimeController = TextEditingController();
    imageController = TextEditingController();
  }

  void addEvent() {
    String eventName = eventNameController.text;
    String eventDescription = descriptionController.text;
    String image = imageController.text;
    String eventDate = eventDateController.text;
    String eventTime = eventTimeController.text;
    var uuid = const Uuid();
    String eventId = uuid.v4();
    EventModel event = EventModel(
        eventId: eventId,
        eventName: eventName,
        eventDescription: eventDescription,
        eventDate: eventDate,
        eventTime: eventTime,
        eventType: isUniqueEvent ? "special" : "recurring",
        category: category,
        categoryColor: categoryColor,
        image: image,
        participants: [],
        untilDate: dateFinalAt,
        day: eventDay,
        recurring: !isUniqueEvent,
        rating: 0);
    RegisterController().addEventToUserEvents(event, context);
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
                      controller: TextEditingController(),
                      hintText: "TOCAI & BUBU",
                      icon: Icons.edit,
                      textAlign: TextAlign.start,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    EventDateTimePickerRow(
                      dateController: eventDateController,
                      timeController: eventTimeController,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        EventDay(
                          onSelectionChanged: (selectedDate, selectedDay,
                              isEventoUnicoSelected) {
                            print('Selected Date: $selectedDate');
                            print('Selected Day: $selectedDay');
                            print(
                                'Is Evento Unico Selected: $isEventoUnicoSelected');
                            dateFinalAt = selectedDate;
                            eventDay = selectedDay.toString();
                            isUniqueEvent = isEventoUnicoSelected;
                          },
                        ),
                        Category(
                          onCategoryChanged: (selectedCategory, selectedColor) {
                            print('Selected Category: $selectedCategory');
                            print('Selected Color: $selectedColor');
                            category = selectedCategory;
                            categoryColor = selectedColor.value.toString();
                          },
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    DCTBTextField(
                      controller: eventNameController,
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
                      controller: descriptionController,
                      hintText: "(max 200 caratteri)",
                      letter: "P",
                      textAlign: TextAlign.start,
                      characterLimit: 200,
                      autoMoveToNextLine: true,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    ImagePickerComponent(
                      onImagePicked: (base64Value) {
                        imageController.text = base64Value;
                      },
                    ),
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
                      onPressed: () {
                        addEvent();
                      },
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
