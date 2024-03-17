import 'package:flutter/material.dart';
import 'package:uperitivo/Tutorial/tutorial_screen.dart';
import 'package:uperitivo/Utils/helpers.dart';

class Header extends StatelessWidget {
  final VoidCallback onIconTap;
  final VoidCallback onDrawerTap;
  final String screenName;
  final bool showSearch;
  final bool showBackButton;
  final Function(String)? onSearchChanged;

  const Header({
    Key? key,
    required this.onIconTap,
    required this.onDrawerTap,
    this.screenName = "",
    this.showSearch = false,
    this.showBackButton = false,
    this.onSearchChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final logo = Image.asset(
      'assets/images/Group 133.png',
      width: MediaQuery.of(context).size.width * 0.5,
    );

    return SafeArea(
      child: Container(
        height: MediaQuery.of(context).size.height * 0.20,
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/header light.png'),
            fit: BoxFit.fill,
          ),
        ),
        child: showSearch
            ? searchHeader(context, logo)
            : defaultHeader(context, logo),
      ),
    );
  }

  Widget searchHeader(BuildContext context, Widget logo) {
    return Column(
      children: [
        logo,
        const SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            tutorialLink(context),
            Expanded(child: buildSearchField(context)),
            drawerIcon(context),
          ],
        ),
      ],
    );
  }

  Widget defaultHeader(BuildContext context, Widget logo) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        showBackButton ? backButton(context) : tutorialLink(context),
        logo,
        drawerIcon(context),
      ],
    );
  }

  InkWell tutorialLink(BuildContext context) {
    return InkWell(
      onTap: screenName == "tutorial"
          ? null
          : () => getScreen(context, () => TutorialScreen()),
      child: const Padding(
        padding: EdgeInsets.all(8.0),
        child: Icon(Icons.info_outline, size: 24, color: Colors.white),
      ),
    );
  }

  Widget buildSearchField(BuildContext context) {
    return Container(
      height: 40,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFEDEDED),
        borderRadius: BorderRadius.circular(30.0),
      ),
      child: TextField(
        onChanged: onSearchChanged,
        style: const TextStyle(color: Colors.black),
        decoration: InputDecoration(
          hintText: 'Cerca la tua città',
          hintStyle: const TextStyle(color: Colors.grey),
          prefixIcon: const Icon(Icons.search, color: Colors.grey),
          suffixIcon: IconButton(
            icon: const Icon(Icons.clear, color: Colors.grey),
            onPressed: () {},
          ),
          filled: true,
          fillColor: const Color(0xFFEDEDED),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20),
        ),
      ),
    );
  }

  Widget drawerIcon(BuildContext context) {
    return InkWell(
      onTap: onDrawerTap,
      child: const Padding(
        padding: EdgeInsets.all(8.0),
        child: Icon(Icons.menu, size: 24, color: Colors.white),
      ),
    );
  }

  Widget backButton(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.of(context).pop(),
      child: const Padding(
        padding: EdgeInsets.all(8.0),
        child: Icon(Icons.arrow_back, size: 24, color: Colors.white),
      ),
    );
  }
}
