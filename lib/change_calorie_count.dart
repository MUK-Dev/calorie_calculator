import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gregdoucette/model/intake-history_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ChangeCalorieCount extends StatefulWidget {
  const ChangeCalorieCount(
      {Key? key, required this.index, required this.lastDays})
      : super(key: key);
  final int index;
  final List<IntakeHistoryModel> lastDays;

  @override
  _ChangeCalorieCountState createState() => _ChangeCalorieCountState();
}

class _ChangeCalorieCountState extends State<ChangeCalorieCount> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: 100,
              ),
              Text(
                'Calories Left',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.of(context).textTheme.headline1!.color,
                  fontSize: 17,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(children: [
                        TextSpan(
                            text: widget.lastDays[widget.index].dailyGoal
                                .toString(),
                            style: TextStyle(
                                color: Theme.of(context)
                                    .textTheme
                                    .headline1!
                                    .color,
                                fontSize: 50,
                                fontWeight: FontWeight.bold)),
                        TextSpan(
                            text: ' kcal',
                            style: TextStyle(
                                color: Theme.of(context)
                                    .textTheme
                                    .headline1!
                                    .color,
                                fontSize: 40)),
                      ])),
                  IconButton(
                      onPressed: () {
                        late int cal;
                        showModalBottomSheet(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20)),
                            ),
                            context: context,
                            builder: (context) => Column(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(top: 10),
                                      width: 50,
                                      height: 3,
                                      color: Colors.grey,
                                    ),
                                    Spacer(),
                                    Text(
                                      "Change Daily Calorie Count",
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    Divider(
                                      thickness: 2,
                                    ),
                                    Spacer(),
                                    Container(
                                      height: 300,
                                      child: CupertinoPicker.builder(
                                          itemExtent: 35,
                                          childCount: 5200,
                                          scrollController:
                                              FixedExtentScrollController(
                                                  initialItem: widget
                                                          .lastDays[
                                                              widget.index]
                                                          .dailyGoal! -
                                                      800),
                                          onSelectedItemChanged: (val) {
                                            cal = val;
                                          },
                                          itemBuilder: (context, index) {
                                            return Center(
                                              child: Text(
                                                (index + 800).toString(),
                                                style: TextStyle(
                                                    color: Theme.of(context)
                                                        .textTheme
                                                        .headline1!
                                                        .color),
                                              ),
                                            );
                                          }),
                                    ),
                                    Spacer(),
                                    Container(
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 10),
                                      child: MaterialButton(
                                        color: Colors.green,
                                        textColor: Colors.white,
                                        minWidth: double.infinity,
                                        padding: EdgeInsets.all(20),
                                        onPressed: () async {
                                          var box = await Hive.openBox(
                                              'dailyCalorieIntake');
                                          print(box.values);

                                          await box.put(
                                              'dailyCalorieIntake', cal + 800);
                                          print(box.values);
                                          widget.lastDays[widget.index]
                                              .dailyGoal = cal + 800;
                                          widget.lastDays[widget.index].save();
                                          Navigator.pop(context);
                                          setState(() {});
                                        },
                                        child: Text(
                                          'Save',
                                          style: TextStyle(fontSize: 15),
                                        ),
                                      ),
                                    ),
                                  ],
                                ));
                      },
                      icon: Icon(
                        CupertinoIcons.pencil,
                        color: Colors.green,
                      ))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
