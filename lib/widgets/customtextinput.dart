import 'package:flutter/material.dart';

class CustomTextInput extends StatelessWidget {
  final String hintText;
  final IconData leading;
  //final Function userTyped;
  final bool obscure;
  final TextInputType keyboard;
  final Function validator;
  final TextEditingController controller;
  final TextInputAction textInputAction;
  final Function onEditingComplete;
  final Function onFieldSubmitted;
  final FocusNode focusNode;
  CustomTextInput({this.hintText, this.leading, /* this.userTyped, */ this.obscure, this.keyboard = TextInputType.text, this.validator, this.controller, this.textInputAction, this.onEditingComplete, this.onFieldSubmitted, this.focusNode});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      padding: EdgeInsets.only(left: 10),
      width: MediaQuery.of(context).size.width * 0.70,
      child: TextFormField(
        validator: validator,
        keyboardType: keyboard,
        autofocus: false,
        controller: controller,
        decoration: InputDecoration(
          icon: Icon(
            leading,
            color: Colors.deepPurple,
          ),
          border: InputBorder.none,
          hintText: hintText,
          hintStyle: TextStyle(
            fontFamily: 'Poppins',
          ),
        ),
        textInputAction: textInputAction,
        onEditingComplete: onEditingComplete,
        obscureText: obscure ? true : false,
        focusNode: focusNode,
        /* onChanged: userTyped,
        onSubmitted: (value) {}, */
      ),
    );
  }
}
