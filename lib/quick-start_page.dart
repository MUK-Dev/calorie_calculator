import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gregdoucette/controlled_widget.dart';
import 'package:gregdoucette/homepage.dart';
import 'package:gregdoucette/theme_handler.dart';
import 'package:gregdoucette/utilities/custom-navigator.dart';
import 'package:gregdoucette/utilities/show-toast-msg.dart';
import 'package:hive/hive.dart';
import 'model/intake-history_model.dart';
import 'widgets/greg_text-field.dart';

class QuickStartPage extends ControlledWidget {
  ThemeHandler? themeHandler;
  QuickStartPage({this.themeHandler}) : super(controller: themeHandler!);
  @override
  _QuickStartPageState createState() => _QuickStartPageState();
}

class _QuickStartPageState extends State<QuickStartPage> {
  static int index = 0;
  // int selectedCalories = 800;
  TextEditingController selectedCalories =
      TextEditingController.fromValue(TextEditingValue(text: 800.toString()));
  FixedExtentScrollController controller =
      FixedExtentScrollController(initialItem: index);
  var key = GlobalKey<ScaffoldState>();

  setCalorieGoal(int value) async {
    var box = await Hive.openBox('dailyCalorieIntake');
    print(box.values);

    await box.put('dailyCalorieIntake', value);
    final reportBox = Hive.box<IntakeHistoryModel>('records');
    reportBox.values.last.dailyGoal = value;
    await reportBox.values.last.save();

    print(box.values);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: key,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                SizedBox(
                  height: 50,
                ),
                Text(
                    'Track your calories easier than last time with the calorie calculator!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Theme.of(context).textTheme.headline1!.color,
                        fontSize: 20)),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 8,
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "What is your daily caloric intake?",
                      style: TextStyle(
                        fontSize: 20,
                        color: Theme.of(context).textTheme.headline1!.color,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // Container(
                    //   child: ListTile(
                    //     title: Text("Daily intake"),
                    //     trailing: Text(selectedCalories.toString()),
                    //     onTap: (){
                    //       showDialog(
                    //         barrierDismissible: true,
                    //           context: context,
                    //         child: Theme(
                    //           data: ThemeData.light(),
                    //           child: CupertinoAlertDialog(
                    //             title: Text("Set Daily Caloric Intake"),
                    //             content: Container(
                    //               height: 200,
                    //               child: CupertinoPicker.builder(
                    //                 itemExtent: 20,
                    //                   childCount: 5200,
                    //                   scrollController: FixedExtentScrollController(initialItem: index),
                    //                   onSelectedItemChanged: (val){
                    //                 setState(() {
                    //                   selectedCalories = val+800;
                    //                   index = val;
                    //                 });
                    //               },
                    //                   itemBuilder: (context,index){
                    //                 return Text((index+800).toString(),style: TextStyle(
                    //                   color: Colors.black
                    //                 ),);
                    //               }),
                    //             ),
                    //           ),
                    //         )
                    //       );
                    //     },
                    //   ),
                    // ),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GregTextField(
                        controller: selectedCalories,
                        context: context,
                        onlyNumbers: true,
                        keyboardType: TextInputType.number,
                        prefix: FlatButton.icon(
                          padding: EdgeInsets.all(0),
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          shape: CircleBorder(),
                          icon: Icon(Icons.remove),
                          label: SizedBox(),
                          onPressed: () {
                            var val = int.parse(selectedCalories.text);
                            if (val > 800 && val <= 6000) {
                              setState(() {
                                selectedCalories.text = (val - 10).toString();
                              });
                            }
                          },
                        ),
                        suffix: FlatButton.icon(
                          padding: EdgeInsets.all(0),
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          shape: CircleBorder(),
                          label: SizedBox(),
                          icon: Icon(Icons.add),
                          onPressed: () {
                            var val = int.parse(selectedCalories.text);
                            if (val < 6000) {
                              setState(() {
                                selectedCalories.text = (val + 10).toString();
                              });
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                // Expanded(child: Container(),),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 30,
                ),
                Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: RaisedButton.icon(
                        color: Colors.green,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        padding: EdgeInsets.all(20),
                        textColor: Colors.white,
                        onPressed: () async {
                          int calories = int.parse(selectedCalories.text);
                          if (calories < 800) {
                            showToastMsg(
                                "Your daily caloric intake cannot be less than 800",
                                true);
                            return;
                          }
                          if (calories.isNegative) {
                            showToastMsg(
                                "Your daily caloric intake cannot be negative",
                                true);
                            return;
                          }
                          if (calories == 0) {
                            showToastMsg(
                                "Your daily caloric intake cannot be zero",
                                true);
                            return;
                          }
                          if (calories > 6000) {
                            showToastMsg(
                                "Your daily caloric intake cannot exceed 6000",
                                true);
                            return;
                          }
                          await setCalorieGoal(calories);
                          CustomNavigator.pushReplacement(
                              context,
                              HomePage(
                                themeHandler: widget.themeHandler,
                              ));
                        },
                        icon:
                            Text("Let's Start", style: TextStyle(fontSize: 15)),
                        label: Icon(CupertinoIcons.forward)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
