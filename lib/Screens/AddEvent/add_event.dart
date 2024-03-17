import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:uperitivo/Controller/user_firebase_controller.dart';
import 'package:uperitivo/Models/event_model.dart';
import 'package:uperitivo/Models/user_model.dart';
import 'package:uperitivo/Screens/AddEvent/event_category.dart';
import 'package:uperitivo/Screens/AddEvent/event_day.dart';
import 'package:uperitivo/Screens/AddEvent/image_picker.dart';
import 'package:uperitivo/Screens/Components/cBButton.dart';
import 'package:uperitivo/Screens/Components/cTBTextField.dart';
import 'package:uperitivo/Screens/Components/drawer_screen.dart';
import 'package:uperitivo/Screens/Components/eventDatePickerRow.dart';
import 'package:uperitivo/Screens/Components/footer.dart';
import 'package:uperitivo/Screens/Components/header.dart';
import 'package:uperitivo/SplashScreen.dart';
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
  // late TextEditingController ueventDateController;
  // late TextEditingController ueventTimeController;
  // late TextEditingController imageController;
  String eventDate = "";
  String eventTime = "";
  bool isUniqueEvent = false;
  List eventDays = [];
  String dateFinalAt = "";
  String category = "";
  String categoryColor = "";
  UserModel? user;
  bool isAddingEvent = false;
  File? pickedImage;

  @override
  void initState() {
    super.initState();
    eventNameController = TextEditingController();
    descriptionController = TextEditingController();
    eventDateController = TextEditingController();
    eventTimeController = TextEditingController();
    // imageController = TextEditingController();

    user = getCurrentUser(context);
    print(user!.name);
    setState(() {});
  }

  void resetControllers() {
    eventNameController.text = '';
    descriptionController.text = '';
    // eventDateController.text = '';
    // eventTimeController.text = '';
    // ueventDateController.text = '';
    // ueventTimeController.text = '';
    // imageController.text = '';
    eventDate = '';
    eventTime = '';
    isUniqueEvent = false;
    eventDays = [];
    dateFinalAt = '';
    category = '';
    categoryColor = '';
    pickedImage = null;
  }

  Future<void> addEvent() async {
    if (user != null) {
      setState(() {
        isAddingEvent = true;
      });

      String eventName = eventNameController.text.trim();
      String eventDescription = descriptionController.text.trim();
      String eventDate = eventDateController.text;
      String eventTime = eventTimeController.text;

      if (eventName.isEmpty ||
          eventDescription.isEmpty ||
          eventDate.isEmpty ||
          eventTime.isEmpty ||
          category.isEmpty ||
          categoryColor.isEmpty) {
        showErrorSnackBar(context, "Fill all fields");
        setState(() {
          isAddingEvent = false;
        });
        return;
      }

      if (!isUniqueEvent) {
        if (eventDays.isEmpty) {
          showErrorSnackBar(context, "Seleziona il/i giorno/i dell'evento");
          setState(() {
            isAddingEvent = false;
          });
          return;
        }
        if (dateFinalAt.isEmpty) {
          showErrorSnackBar(context, "Select fino al(compresso)");
          setState(() {
            isAddingEvent = false;
          });
          return;
        }
        if (dateFinalAt == eventDate) {
          showErrorSnackBar(
              context, "Select different fino al(compresso) from event date");
          setState(() {
            isAddingEvent = false;
          });
          return;
        }
      }

      if (!isEventDateTimeValid(eventDate, eventTime)) {
        showErrorSnackBar(context,
            "Selected date and time have already passed. Please choose a future date and time.");
        setState(() {
          isAddingEvent = false;
        });
        return;
      }

      String image =
          'https://firebasestorage.googleapis.com/v0/b/uperitivo-b5e06.appspot.com/o/event_images%2Fplaceholder_register_image.png?alt=media&token=d2a7a5ea-536d-4da7-a29c-a5f2bf717460';

      if (pickedImage != null) {
        String imagePath = 'event_images/${Uuid().v4()}';
        await firebase_storage.FirebaseStorage.instance
            .ref(imagePath)
            .putFile(pickedImage!);

        image = await firebase_storage.FirebaseStorage.instance
            .ref(imagePath)
            .getDownloadURL();
      }

      var uuid = const Uuid();
      String eventId = uuid.v4();

      EventModel event = EventModel(
        eventId: eventId,
        companyId: user!.uid,
        eventName: eventName,
        eventDescription: eventDescription,
        eventDate: eventDate,
        eventTime: eventTime,
        eventType: isUniqueEvent ? "special" : "recurring",
        category: category,
        city: user!.city,
        categoryColor: categoryColor,
        image: image,
        participants: [],
        untilDate: dateFinalAt,
        day: eventDays,
        recurring: !isUniqueEvent,
        rating: {},
        companyName: user!.cmpName,
        address: user!.address,
        longitude: user!.longitude,
        latitude: user!.latitude,
      );

      if (mounted) {
        await RegisterController().addEventToUserEvents(event, context);
      }

      setState(() {
        isAddingEvent = false;
      });
    } else {
      showErrorSnackBar(context, "user not exists");
      await RegisterController().signOut(context);
      if (context.mounted) {
        getScreen(context, () => SplashScreen());
      }
    }
  }

  void _openDrawer() {
    _scaffoldKey.currentState?.openEndDrawer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      drawerEnableOpenDragGesture: false,
      body: Column(
        children: [
          Header(
            onIconTap: () {},
            onDrawerTap: () {
              _openDrawer();
            },
            showBackButton: true,
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
                      hintText: user!.cmpName,
                      icon: Icons.edit,
                      textAlign: TextAlign.start,
                      readOnly: false,
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
                          onSelectionChanged: (selectedDays, selectedDate,
                              isEventoUnicoSelected) {
                            // print('Selected Date: $selectedDate');
                            // print('Selected Day: $selectedDays');
                            // print(
                            //     'Is Evento Unico Selected: $isEventoUnicoSelected');
                            dateFinalAt = selectedDate;
                            eventDays = selectedDays;
                            isUniqueEvent = isEventoUnicoSelected;
                          },
                        ),
                        Category(
                          onCategoryChanged: (selectedCategory, selectedColor) {
                            // print('Selected Category: $selectedCategory');
                            // print('Selected Color: $selectedColor');
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
                      onImagePicked: (image) {
                        setState(() {
                          pickedImage = File(image.path);
                        });
                      },
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: CustomOutlinedButton(
                            text: 'Resetta',
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
                            textColor: const Color(0xFF7E84A3),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    CustomOutlinedButton(
                      text: isAddingEvent ? 'Pubblicazione...' : 'Pubblica',
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
