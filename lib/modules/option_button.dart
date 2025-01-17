import 'package:flutter/material.dart';

class OptionButton extends StatelessWidget {
  final String text;
  final bool isSelected;
  final Function() onSelected;

  const OptionButton({
    Key? key,
    required this.text,
    required this.isSelected,
    required this.onSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Set the background color to yellow for selected, or light blue for unselected
    Color backgroundColor = isSelected ? Colors.yellow : Colors.white;

    return ElevatedButton(
      onPressed: isSelected ? null : onSelected, // Disable if already selected
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(backgroundColor),
        padding: MaterialStateProperty.all(const EdgeInsets.symmetric(vertical: 16.0)),
        shape: MaterialStateProperty.all(RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8), // Rounded corners
        )),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 18, // Set a readable font size
          fontWeight: FontWeight.bold, // Make text bold
        ),
        textAlign: TextAlign.center, // Ensure text is centered
        overflow: TextOverflow.ellipsis, // Ensure the text doesn't overflow
        maxLines: 2, // Limit text to two lines
      ),
    );
  }
}
