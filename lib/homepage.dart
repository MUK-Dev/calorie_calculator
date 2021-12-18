import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gregdoucette/calorie_home.dart';
import 'package:gregdoucette/change_calorie_count.dart';
import 'package:gregdoucette/chart_records.dart';
import 'package:gregdoucette/controlled_widget.dart';
import 'package:gregdoucette/model/intake-history_model.dart';
import 'package:gregdoucette/theme_handler.dart';
import 'package:gregdoucette/utilities/custom-navigator.dart';
import 'package:hive/hive.dart';
import 'widgets/add-intake-bottom_sheet.dart';

class HomePage extends ControlledWidget<ThemeHandler> {
  ThemeHandler? themeHandler;
  HomePage({this.themeHandler}) : super(controller: themeHandler!);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin, ControlledStateMixin {
  late TabController controller;
  late int index;
  int pageIndex = 0;
  late int consumed;
  late List<IntakeHistoryModel> lastDays;
  bool darkTheme = false;

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
    consumed = totalConsumed(index);
    controller = TabController(
        vsync: this, initialIndex: index, length: lastDays.length);
    controller.addListener(() {
      consumed = totalConsumed(index);
    });
  }

  _dayOfWeekday(int i) {
    return ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'][i - 1];
  }

  _buildTabs() {
    final list = <Widget>[];
    for (var i = 0; i < lastDays.length; i++) {
      list.add(Tab(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '${_dayOfWeekday(lastDays[i].createdAt!.weekday)}',
            style: TextStyle(fontSize: 15),
          ),
          Container(
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
                color: Theme.of(context).secondaryHeaderColor,
                borderRadius: BorderRadius.circular(50)),
            child: Text(
              '${lastDays[i].createdAt!.day}'.padLeft(2, '0'),
              style: TextStyle(
                color: Colors.green,
              ),
            ),
          ),
        ],
      )));
    }

    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.green,
          elevation: 0,
          child: Icon(
            CupertinoIcons.add,
            size: 30,
            semanticLabel: 'Add calorie intake',
          ),
          onPressed: () async {
            var res =
                await CustomNavigator.navigateTo(context, AddIntakeSheet());

            if (res != null) {
              lastDays[index].intakes!.add(res);
              await lastDays[index].save();
              consumed = totalConsumed(index);
            }
          },
        ),
        bottomNavigationBar: BottomAppBar(
          elevation: 5,
          shape: const CircularNotchedRectangle(),
          child: IconTheme(
            data: IconThemeData(color: Colors.grey),
            child: Row(
              children: <Widget>[
                IconButton(
                  tooltip: 'List of days',
                  icon: const Icon(Icons.list_alt),
                  onPressed: () {
                    setState(() {
                      pageIndex = 0;
                    });
                  },
                ),
                Spacer(),
                IconButton(
                  tooltip: 'Edit',
                  icon: const Icon(Icons.settings),
                  onPressed: () {
                    setState(() {
                      pageIndex = 1;
                    });
                  },
                ),
              ],
            ),
          ),
        ),
        drawer: ClipRRect(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(25), bottomRight: Radius.circular(25)),
          child: Drawer(
            child: SafeArea(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 25, horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        FlutterLogo(
                          size: 70,
                        ),
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              padding: EdgeInsets.all(13),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: Theme.of(context).primaryColor,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Theme.of(context).shadowColor,
                                      blurRadius: 20,
                                    )
                                  ]),
                              child: Icon(
                                Icons.arrow_back,
                                color: Theme.of(context)
                                    .textTheme
                                    .headline1!
                                    .color,
                              ),
                            )),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: Theme(
                      data: ThemeData(
                          splashColor: Colors.green,
                          highlightColor: Colors.greenAccent.withOpacity(0.4)),
                      child: ListTile(
                        leading: RotatedBox(
                          quarterTurns: 1,
                          child: Icon(
                            Icons.bar_chart,
                            size: 30,
                            color: Theme.of(context).textTheme.headline1!.color,
                          ),
                        ),
                        title: Text(
                          'My Stats',
                          style: TextStyle(
                              fontSize: 15,
                              color:
                                  Theme.of(context).textTheme.headline1!.color),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ChartRecords()));
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: Theme(
                      data: ThemeData(
                          splashColor: Colors.green,
                          highlightColor: Colors.greenAccent.withOpacity(0.4)),
                      child: ListTile(
                        trailing: Switch(
                            value: widget.controller.isEnabled()!,
                            onChanged: (val) => widget.controller.changeTheme(),
                            activeColor: Colors.green),
                        title: Text(
                          'Dark Theme',
                          style: TextStyle(
                              fontSize: 15,
                              color:
                                  Theme.of(context).textTheme.headline1!.color),
                        ),
                        onTap: () => widget.controller.changeTheme(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Theme.of(context).secondaryHeaderColor,
          elevation: 0,
          toolbarHeight: 100,
          leading: Builder(
              builder: (context) => IconButton(
                  icon: Icon(Icons.menu,
                      color: Theme.of(context).textTheme.headline1!.color),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                  tooltip:
                      MaterialLocalizations.of(context).openAppDrawerTooltip)),
          title: Text(
            "Calorie Calculator",
            style:
                TextStyle(color: Theme.of(context).textTheme.headline1!.color),
          ),
          bottom: TabBar(
            isScrollable: true,
            labelPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            unselectedLabelColor: Colors.grey,
            controller: controller,
            labelColor: Colors.white70,
            indicator: BoxDecoration(
                color: Colors.green, borderRadius: BorderRadius.circular(25)),
            onTap: (i) {
              index = i;
              consumed = totalConsumed(index);
            },
            tabs: _buildTabs(),
          ),
        ),
        body: [
          CalorieHome(
            totalConsumed: totalConsumed,
            consumed: consumed,
            controller: controller,
            index: index,
            lastDays: lastDays,
          ),
          ChangeCalorieCount(
            index: index,
            lastDays: lastDays,
          )
        ][pageIndex]);
  }

  totalConsumed(int index) {
    var sum = 0;
    lastDays[index].intakes!.forEach((element) {
      sum += element.calories!;
    });
    setState(() {});
    return sum;
  }
}
