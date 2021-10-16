import 'package:flutter/material.dart';

class AddToReadListButton extends StatelessWidget {
  final bool buttonStatus; // added: true
  final String buttonText;
  final VoidCallback clickCallback;
  const AddToReadListButton(
      {Key? key,
      required this.buttonStatus,
      required this.buttonText,
      required this.clickCallback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: buttonStatus ? Colors.greenAccent : Colors.amber,
          borderRadius: BorderRadius.circular(20.0)),
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
      child: GestureDetector(
          onTap: clickCallback,
          child: Row(
            children: <Widget>[
              Text(buttonText),
              buttonStatus
                  ? const Icon(Icons.book_rounded)
                  : const Icon(Icons.add)
            ],
          )),
    );
  }
}
