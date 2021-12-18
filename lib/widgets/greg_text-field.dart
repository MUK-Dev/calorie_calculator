import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GregTextField extends Padding {
  GregTextField(
      {String? placeholder,
      Widget? prefix,
      Widget? suffix,
      String? hint,
      TextInputType? keyboardType,
      BuildContext? context,
      TextEditingController? controller,
      bool onlyNumbers = false,
      Function(String)? validator})
      : super(
          padding: const EdgeInsets.all(8.0),
          child: CupertinoTextField(
            style: TextStyle(color: Colors.black),
            placeholder: placeholder,
            padding: EdgeInsets.all(20),
            // inputFormatters: onlyNumbers ? [WhitelistingTextInputFormatter.digitsOnly] : null,
            keyboardType: keyboardType,
            textAlign: TextAlign.center,
            scrollPadding: EdgeInsets.all(120),
            prefix: prefix,
            suffix: suffix,
            controller: controller,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black54, width: 1),
              borderRadius: BorderRadius.circular(15),
              color: Colors.transparent,
            ),
          ),
        );
}

class GregTextFormField extends Padding {
  GregTextFormField(
      {Widget? prefix,
      Widget? suffix,
      String? hint,
      TextInputType? keyboardType,
      BuildContext? context,
      TextEditingController? controller,
      bool onlyNumbers = false,
      String? Function(String?)? validator})
      : super(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            maxLines: 5,
            keyboardType: keyboardType,
            scrollPadding: EdgeInsets.all(120),
            decoration: InputDecoration(
                hintText: hint,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15))),
            controller: controller,
            validator: validator,
          ),
        );
}
