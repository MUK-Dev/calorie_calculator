import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gregdoucette/model/intake_model.dart';
import 'package:gregdoucette/utilities/show-toast-msg.dart';
import 'package:gregdoucette/widgets/greg_text-field.dart';
import 'custom-timepicker.dart';

class AddIntakeSheet extends StatefulWidget {
  final IntakeModel? intake;
  AddIntakeSheet({this.intake});
  @override
  _AddIntakeSheetState createState() => _AddIntakeSheetState();
}

class _AddIntakeSheetState extends State<AddIntakeSheet> {
  var formKey = GlobalKey<FormState>();
  static int defaultDailyIntake = 10;
  late String? calories;
  TimeOfDay timeOfDay = TimeOfDay.now();
  var description = TextEditingController();
  bool autoValidate = false;

  @override
  void initState() {
    super.initState();
    if (widget.intake != null) {
      calories = widget.intake!.calories.toString();
      description.text = widget.intake?.description ?? '';
      timeOfDay = TimeOfDay.fromDateTime(widget.intake!.time!);
    } else {
      calories = defaultDailyIntake.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).secondaryHeaderColor,
        elevation: 0,
        title: Text(widget.intake == null ? "Add Intake" : "Update Intake"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 50,
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                content: Container(
                                  height: 300,
                                  child: CupertinoPicker.builder(
                                      itemExtent: 35,
                                      childCount: 5200,
                                      onSelectedItemChanged: (val) {
                                        calories = (val + 10).toString();
                                        setState(() {});
                                      },
                                      scrollController:
                                          FixedExtentScrollController(
                                              initialItem:
                                                  int.parse(calories!) - 10),
                                      itemBuilder: (context, index) {
                                        return Center(
                                          child: Text(
                                            (index + defaultDailyIntake)
                                                .toString(),
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .textTheme
                                                    .headline1!
                                                    .color),
                                          ),
                                        );
                                      }),
                                ),
                              ));
                    },
                    child: Container(
                        padding: EdgeInsets.all(25),
                        decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                  color: Theme.of(context).shadowColor,
                                  blurRadius: 10)
                            ]),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Calories consumed",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Text(
                              calories.toString(),
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        )),
                  ),
                  CustomTimePicker(
                    time: widget.intake != null
                        ? TimeOfDay.fromDateTime(widget.intake!.time!)
                        : TimeOfDay.now(),
                    onChanged: (TimeOfDay time) {
                      timeOfDay = time;
                    },
                  ),
                ],
              ),
            ),

            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       Padding(
            //         padding: const EdgeInsets.all(8.0),
            //         child: Text(
            //           "Calories consumed",
            //           style: TextStyle(fontWeight: FontWeight.bold),
            //         ),
            //       ),
            //       Theme(
            //         data: ThemeData.light(),
            // child: GregTextField(
            //           controller: calories,
            //           context: context,
            //           onlyNumbers: true,
            //           keyboardType: TextInputType.number,
            //           prefix: FlatButton.icon(
            //             padding: EdgeInsets.all(0),
            //             materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            //             shape: CircleBorder(),
            //             icon: Icon(Icons.remove),
            //             label: SizedBox(),
            //             onPressed: () {
            //               FocusScope.of(context).requestFocus(FocusNode());
            //               FocusScope.of(context).requestFocus(FocusNode());
            //               var val = int.parse(calories.text);
            //               if (val > 1 && val != 10) {
            //                 setState(() {
            //                   calories.text = (val - 10).toString();
            //                 });
            //               }
            //             },
            //           ),
            //           suffix: FlatButton.icon(
            //             padding: EdgeInsets.all(0),
            //             materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            //             shape: CircleBorder(),
            //             label: SizedBox(),
            //             icon: Icon(Icons.add),
            //             onPressed: () {
            //               FocusScope.of(context).requestFocus(FocusNode());
            //               FocusScope.of(context).requestFocus(FocusNode());
            //               var val = int.parse(calories.text);
            //               setState(() {
            //                 calories.text = (val + 10).toString();
            //               });
            //             },
            //           ),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            Padding(
              padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
              child: GregTextFormField(
                hint: 'Description',
                controller: description,
                context: context,
                validator: (String? val) {
                  if (val!.isEmpty) {
                    return 'Please enter some description';
                  }
                  return '';
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: RaisedButton.icon(
                    padding: EdgeInsets.all(20),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    color: Colors.green,
                    textColor: Colors.white,
                    onPressed: () {
                      int val = int.parse(calories!);
                      if (val.isNegative) {
                        showToastMsg("Cannot be negative", true);
                        return;
                      }
                      if (val == 0) {
                        showToastMsg("Cannot be zero", true);
                        return;
                      }
                      if (val > 6000) {
                        showToastMsg("Cannot exceed 6000", true);
                        return;
                      }

                      var now = DateTime.now();
                      Navigator.pop(
                          context,
                          IntakeModel(
                              calories: int.parse(calories!),
                              description: description.text,
                              time: DateTime(now.year, now.month, now.day,
                                  timeOfDay.hour, timeOfDay.minute)));

                      // if(formKey.currentState.validate()){
                      //
                      // } else {
                      //   setState(() {
                      //     autoValidate=true;
                      //   });
                      // }
                      // CustomNavigator.navigateTo(context, HomePage());
                    },
                    icon: Text(
                      widget.intake == null ? "Add Intake" : "Update Intake",
                      style: TextStyle(fontSize: 15),
                    ),
                    label: Icon(
                      CupertinoIcons.check_mark_circled,
                      size: 20,
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
