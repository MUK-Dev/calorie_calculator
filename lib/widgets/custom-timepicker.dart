// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class CustomTimePicker extends StatefulWidget {
  TimeOfDay? time;
  final title;
  final Function(TimeOfDay) onChanged;
  CustomTimePicker({this.title = "Time", required this.onChanged, this.time});

  @override
  createState() => _CustomTimePickerState();
}

class _CustomTimePickerState extends State<CustomTimePicker> {
  late String time;
  late TimeOfDay selectedTime;

  @override
  initState() {
    super.initState();
    selectedTime = widget.time ?? TimeOfDay.now();
    Future.delayed(Duration.zero, () {
      time = selectedTime.format(context);
    });
    widget.onChanged(selectedTime);
  }

  @override
  build(context) => Padding(
        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
        child: GestureDetector(
          onTap: () async {
            FocusScope.of(context).nextFocus();
            TimeOfDay? t = await showTimePicker(
                context: context, initialTime: selectedTime);
            if (t == null) {
              return;
            } else {
              setState(() {
                selectedTime = t;
                time = t.format(context);
                widget.onChanged(t);
              });
            }
          },
          child: Container(
            padding: EdgeInsets.all(25),
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                      color: Theme.of(context).shadowColor, blurRadius: 10)
                ]),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.timer,
                    color: Colors.green,
                  ),
                ),
                Text('${selectedTime.format(context)}')
              ],
            ),
          ),
          // child: Stack(
          //   children: [
          //     TextField(
          //       enabled: false,
          //       controller: _textFieldController,
          //       decoration: InputDecoration(
          //           isDense: true,
          //           enabledBorder: OutlineInputBorder(
          //               borderRadius: BorderRadius.circular(15),
          //               borderSide: BorderSide(color: Colors.grey)),
          //           focusedBorder: OutlineInputBorder(
          //               borderRadius: BorderRadius.circular(8),
          //               borderSide: BorderSide(color: Colors.grey)),
          //           labelText: widget.title,
          //           labelStyle: TextStyle(
          //               color: Theme.of(context).textTheme.headline1!.color),
          //           border: OutlineInputBorder(
          //               borderSide: BorderSide(color: Colors.grey))),
          //     ),
          //     Align(
          //       alignment: Alignment(1, -1),
          //       child: IconButton(
          //         icon: Icon(
          //           Icons.timer,
          //           color: Colors.green,
          //         ),
          //         onPressed: () async {
          //           FocusScope.of(context).nextFocus();
          //           TimeOfDay? t = await showTimePicker(
          //               context: context, initialTime: time);
          //           if (t == null) {
          //             return;
          //           } else {
          //             setState(() {
          //               time = t;
          //               this._textFieldController.text = t.format(context);
          //               widget.onChanged(t);
          //             });
          //           }
          //         },
          //       ),
          //     ),
          //   ],
          // ),
        ),
      );
}
