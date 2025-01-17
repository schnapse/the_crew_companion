import 'package:flutter/material.dart';
import 'package:the_crew_companion/constant.dart';

class AimButton extends StatelessWidget {
  AimButton({
    Key? key,
    required this.text,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    if (text == "") return Container();

    return Container(
      height: 50,
      width: 35,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white, width: 2),
        borderRadius: BorderRadius.all(
          Radius.circular(8),
        ),
        color: primaryColor.withOpacity(0.7),
        shape: BoxShape.rectangle,
      ),
      child: IconButton(
        tooltip: text + " objectifs",
        onPressed: null,
        icon: Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
