import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gregdoucette/model/intake-history_model.dart';
import 'package:gregdoucette/utilities/custom-navigator.dart';
import 'package:gregdoucette/widgets/add-intake-bottom_sheet.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

class CalorieDismissible extends StatefulWidget {
  const CalorieDismissible({Key? key, this.i, this.days, this.totalConsumed})
      : super(key: key);
  final int? i;
  final IntakeHistoryModel? days;
  final Function(int)? totalConsumed;

  @override
  _CalorieDismissibleState createState() => _CalorieDismissibleState();
}

class _CalorieDismissibleState extends State<CalorieDismissible> {
  late int index;
  int pageIndex = 0;
  late int consumed;
  late List<IntakeHistoryModel> lastDays;
  late String imgAsset;

  @override
  void initState() {
    super.initState();
    final box = Hive.box<IntakeHistoryModel>('records');
    if (box.length > 5) {
      lastDays = box.values.skip(box.length - 5).toList();
    } else {
      lastDays = box.values.toList();
    }
    index = lastDays.length - 1;
  }

  @override
  Widget build(BuildContext context) {
    var time = TimeOfDay.fromDateTime(widget.days!.intakes![widget.i!].time!);
    var one = TimeOfDay(hour: 13, minute: 0);
    var two = TimeOfDay(hour: 2, minute: 0);
    var seven = TimeOfDay(hour: 19, minute: 0);
    var oneDay = one.hour * 60 + one.minute;
    var twoNight = two.hour * 60 + two.minute;
    var sevenNight = seven.hour * 60 + seven.minute;
    var current = time.hour * 60 + time.minute;
    if (current < oneDay && current > twoNight) {
      imgAsset = 'assets/images/breakfast.png';
    } else if (current > oneDay && current < sevenNight) {
      imgAsset = 'assets/images/lunchTime.png';
    } else if (current < twoNight && current > sevenNight) {
      imgAsset = 'assets/images/meal.png';
    }
    return Container(
      margin: EdgeInsets.only(bottom: 20, left: 10, right: 10),
      decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
                color: Theme.of(context).shadowColor,
                blurRadius: 10,
                offset: Offset(0, 5))
          ]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Image(
              width: 40,
              height: 40,
              image: AssetImage(imgAsset),
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: RichText(
                      text: TextSpan(children: [
                    TextSpan(
                        text: 'Consumed ',
                        style: TextStyle(
                            color: Theme.of(context).textTheme.headline1!.color,
                            fontWeight: FontWeight.bold)),
                    TextSpan(
                        text: widget.days!.intakes![widget.i!].calories
                            .toString(),
                        style: TextStyle(
                            color: Colors.green, fontWeight: FontWeight.bold)),
                    TextSpan(
                        text: ' calories',
                        style: TextStyle(
                            color:
                                Theme.of(context).textTheme.headline1!.color!,
                            fontWeight: FontWeight.bold)),
                  ])),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    TimeOfDay.fromDateTime(
                            widget.days!.intakes![widget.i!].time!)
                        .format(context),
                    style: TextStyle(color: Colors.green),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    widget.days!.intakes![widget.i!].description!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Theme.of(context).textTheme.headline1!.color!),
                  ),
                ),
              ],
            ),
          ),
          DropdownButton(
              underline: Text(""),
              icon: Icon(Icons.more_vert),
              borderRadius: BorderRadius.circular(15),
              items: [
                DropdownMenuItem(
                  value: 0,
                  child: TextButton.icon(
                    label: Text("Delete"),
                    onPressed: () {
                      Navigator.pop(context);
                      showDialog(
                          context: context,
                          builder: (context) => CupertinoAlertDialog(
                                title: Text('Are you sure?'),
                                actions: [
                                  TextButton(
                                      onPressed: () async {
                                        lastDays[index]
                                            .intakes!
                                            .removeAt(widget.i!);
                                        await lastDays[index].save();
                                        consumed = widget.totalConsumed!(index);
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('Yes')),
                                  TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('No')),
                                ],
                              ));
                    },
                    icon: Icon(
                      CupertinoIcons.delete,
                      color: Colors.red,
                    ),
                  ),
                ),
                DropdownMenuItem(
                  value: 1,
                  child: TextButton.icon(
                    label: Text('Edit'),
                    onPressed: () async {
                      var res = await CustomNavigator.navigateTo(
                          context,
                          AddIntakeSheet(
                            intake: lastDays[index].intakes![widget.i!],
                          ));
                      Navigator.pop(context);
                      if (res != null) {
                        lastDays[index].intakes![widget.i!] = res;
                        await lastDays[index].save();

                        consumed = widget.totalConsumed!(index);
                      }
                      return Future.value(false);
                    },
                    icon: Icon(
                      CupertinoIcons.pencil,
                      color: Colors.green,
                    ),
                  ),
                )
              ],
              onChanged: (val) {}),
          // Padding(
          //   padding: const EdgeInsets.all(10),
          //   child: IconButton(
          //     onPressed: () => showDialog(
          //         context: context,
          //         builder: (context) => CupertinoAlertDialog(
          //               title: Text('Are you sure?'),
          //               actions: [
          //                 TextButton(
          //                     onPressed: () async {
          //                       lastDays[index].intakes!.removeAt(widget.i!);
          //                       await lastDays[index].save();
          //                       consumed = widget.totalConsumed!(index);
          //                       Navigator.of(context).pop();
          //                     },
          //                     child: Text('Yes')),
          //                 TextButton(
          //                     onPressed: () {
          //                       Navigator.of(context).pop();
          //                     },
          //                     child: Text('No')),
          //               ],
          //             )),
          //     icon: Icon(
          //       CupertinoIcons.delete,
          //       color: Colors.red,
          //     ),
          //   ),
          // ),
          // Padding(
          //   padding: const EdgeInsets.all(10),
          //   child: IconButton(
          //     onPressed: () async {
          //       var res = await CustomNavigator.navigateTo(
          //           context,
          //           AddIntakeSheet(
          //             intake: lastDays[index].intakes![widget.i!],
          //           ));

          //       if (res != null) {
          //         lastDays[index].intakes![widget.i!] = res;
          //         await lastDays[index].save();

          //         consumed = widget.totalConsumed!(index);
          //       }
          //       return Future.value(false);
          //     },
          //     icon: Icon(
          //       CupertinoIcons.pencil,
          //       color: Colors.green,
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
