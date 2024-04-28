import 'package:flutter/material.dart';

class Category extends StatefulWidget {
  final Function(String selectedCategory, Color selectedColor)
      onCategoryChanged;
  final String defaultSelectedValue;
  final Color defaultSelectedColor;

  const Category({
    Key? key,
    required this.onCategoryChanged,
    required this.defaultSelectedValue,
    required this.defaultSelectedColor,
  }) : super(key: key);

  @override
  State<Category> createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  late int? selectedValue;
  late Color selectedColor;

  @override
  void initState() {
    super.initState();
    selectedValue = getSelectedValueByLabel(widget.defaultSelectedValue);
    selectedColor = widget.defaultSelectedColor ?? Colors.black;
  }

  int? getSelectedValueByLabel(String label) {
    switch (label) {
      case 'Vino':
        return 1;
      case 'Spritz':
        return 2;
      case 'Bollicine':
        return 3;
      case 'Superalcolici':
        return 4;
      case 'Analcolico':
        return 5;
      case 'Street Food':
        return 6;
      case 'Vegano':
        return 7;
      default:
        return null; // Default to null if label is not recognized
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.45,
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFD5D7E3)),
        borderRadius: BorderRadius.circular(15.0),
      ),
      padding: const EdgeInsets.all(5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              buildCategoryRow(1, 'Vino', Colors.brown),
              buildCategoryRow(2, 'Spritz', Colors.orange),
              buildCategoryRow(3, 'Bollicine', Colors.yellow),
              buildCategoryRow(4, 'Superalcolici', Colors.blue),
              buildCategoryRow(5, 'Analcolico', Colors.green),
              buildCategoryRow(6, 'Street Food', Colors.amber),
              buildCategoryRow(7, 'Vegano', Colors.greenAccent),
            ],
          ),
        ],
      ),
    );
  }

  Color getCategoryColor(int categoryValue) {
    switch (categoryValue) {
      case 1:
        return Colors.red;
      case 2:
        return Colors.blue;
      case 3:
        return Colors.green;
      case 4:
        return Colors.orange;
      case 5:
        return Colors.purple;
      case 6:
        return Colors.brown;
      default:
        return Colors.black; // Default color if value is not recognized
    }
  }

  Widget buildCategoryRow(int value, String label, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Radio(
          value: value,
          fillColor: MaterialStateColor.resolveWith(
              (states) => const Color(0xFFEC6500)),
          groupValue: selectedValue,
          onChanged: (int? value) {
            setState(() {
              selectedValue = value;
              selectedColor = getCategoryColor(value ?? 0);
            });

            // Call the callback function immediately when a value is selected
            if (selectedValue != null) {
              widget.onCategoryChanged(label, selectedColor);
            }
          },
        ),
        Text(label),
        const SizedBox(
          width: 10,
        ),
        Container(
          width: 30.0,
          height: 20.0,
          color: color,
        ),
      ],
    );
  }
}
