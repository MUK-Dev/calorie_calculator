import 'package:flutter/material.dart';
import 'package:gregdoucette/model/intake-history_model.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ChartRecords extends StatefulWidget {
  const ChartRecords({Key? key}) : super(key: key);

  @override
  _ChartRecordsState createState() => _ChartRecordsState();
}

class _ChartRecordsState extends State<ChartRecords> {
  late List<IntakeHistoryModel> lastDays;
  late int index;

  @override
  void initState() {
    super.initState();
    final box = Hive.box<IntakeHistoryModel>('records');
    if (box.length > 5) {
      lastDays = box.values.skip(box.length - 5).toList();
    } else {
      lastDays = box.values.toList();
    }
  }

  _dayOfWeekday(int i) {
    return ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'][i - 1];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Theme.of(context).secondaryHeaderColor,
        elevation: 0,
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.arrow_back_ios,
            )),
        title: Text(
          "Stats",
        ),
      ),
      body: SfCartesianChart(
        primaryXAxis: CategoryAxis(title: AxisTitle(text: 'Date')),
        primaryYAxis: NumericAxis(
            title: AxisTitle(text: 'Consumed Calories'),
            edgeLabelPlacement: EdgeLabelPlacement.shift),
        series: [
          BarSeries(
              color: Colors.greenAccent,
              dataSource: lastDays,
              yValueMapper: (IntakeHistoryModel calorie, index) {
                var sum = 0;
                if (calorie.intakes!.length > 0) {
                  calorie.intakes!.forEach((element) {
                    sum += element.calories!;
                  });
                }
                return sum;
              },
              xValueMapper: (IntakeHistoryModel calorie, _) {
                return _dayOfWeekday(calorie.createdAt!.weekday);
              })
        ],
      ),
    );
  }
}
