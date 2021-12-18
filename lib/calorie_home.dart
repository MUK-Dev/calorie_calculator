import 'package:flutter/material.dart';
import 'package:gregdoucette/model/intake-history_model.dart';
import 'package:gregdoucette/widgets/calorie_dismissible.dart';
import 'package:gregdoucette/widgets/consumed_widget.dart';
import 'package:gregdoucette/widgets/daily_goal_widget.dart';
import 'package:gregdoucette/widgets/overtook.dart';
import 'package:gregdoucette/widgets/remaining.dart';

class CalorieHome extends StatefulWidget {
  const CalorieHome(
      {Key? key,
      required this.totalConsumed,
      required this.lastDays,
      required this.index,
      required this.consumed,
      required this.controller})
      : super(key: key);
  final Function(int) totalConsumed;
  final List<IntakeHistoryModel> lastDays;
  final int index;
  final int consumed;
  final TabController controller;

  @override
  _CalorieHomeState createState() => _CalorieHomeState();
}

class _CalorieHomeState extends State<CalorieHome>
    with SingleTickerProviderStateMixin {
  _buildViews() {
    return widget.lastDays.map((days) {
      return CustomScrollView(slivers: [
        SliverPadding(
            padding: EdgeInsets.only(left: 8, right: 8, top: 10, bottom: 20),
            sliver: SliverToBoxAdapter(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DailyGoalWidget(
                    label: 'Daily Calories',
                    value: widget.lastDays[widget.index].dailyGoal.toString()),
                ConsumedWidget(
                    label: 'Consumed ', value: widget.consumed.toString()),
                widget.consumed <= widget.lastDays[widget.index].dailyGoal!
                    ? Remaining(
                        value: (widget.lastDays[widget.index].dailyGoal! -
                                widget.consumed)
                            .toString())
                    : Overtook(
                        value: (widget.consumed -
                                widget.lastDays[widget.index].dailyGoal!)
                            .toString())
              ],
            ))),
        SliverList(
            delegate: SliverChildBuilderDelegate((context, i) {
          return CalorieDismissible(
            i: i,
            days: days,
            totalConsumed: widget.totalConsumed,
          );
        }, childCount: days.intakes!.length))
      ]);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return TabBarView(
        physics: NeverScrollableScrollPhysics(),
        controller: widget.controller,
        children: _buildViews());
  }
}
