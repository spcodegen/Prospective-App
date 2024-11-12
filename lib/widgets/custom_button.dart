import 'package:flutter/material.dart';
import 'package:flutter_application_coop/constants/colors.dart';

class CustomButton extends StatelessWidget {
  final String buttonName;
  final Color buttonColor;

  const CustomButton({
    super.key,
    required this.buttonName,
    required this.buttonColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.07,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: buttonColor,
      ),
      child: Center(
        child: Text(
          buttonName,
          style: const TextStyle(
            color: kBlack,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
