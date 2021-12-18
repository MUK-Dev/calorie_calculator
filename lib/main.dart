import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gregdoucette/controlled_widget.dart';
import 'package:gregdoucette/homepage.dart';
import 'package:gregdoucette/model/intake-history_model.dart';
import 'package:gregdoucette/quick-start_page.dart';
import 'package:gregdoucette/theme_handler.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'model/intake_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Hive.registerAdapter(IntakeModelAdapter());
  Hive.registerAdapter(IntakeHistoryModelAdapter());
  await Hive.initFlutter();
  int? dailyCalorieIntake;

  /// TODO: Use SharedPreferences for storing single values.
  // Hive.openBox('dailyCalorieIntake').then((value) => value.clear());
  // Hive.box('records').clear();
  bool firstTime = (await Hive.openBox('dailyCalorieIntake')).isEmpty;
  if (!firstTime) {
    dailyCalorieIntake =
        (await Hive.openBox('dailyCalorieIntake')).get('dailyCalorieIntake');
  }
  final box = await Hive.openBox<IntakeHistoryModel>('records');
  _parse(DateTime now) => '${now.day}-${now.month}-${now.year}';
  final date = _parse(DateTime.now());

  if (!box.containsKey(date)) {
    final model = IntakeHistoryModel(
        createdAt: DateTime.now(), dailyGoal: dailyCalorieIntake,

        /// TODO: Change it.
        intakes: []);
    await box.put(date, model);
    await model.save();
  }

  runApp(MyApp(firstTime: firstTime));
}

class MyApp extends ControlledWidget<ThemeHandler> {
  final bool firstTime;
  MyApp({this.firstTime = true}) : super(controller: ThemeHandler());

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with ControlledStateMixin {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calorie Calculator',
      localizationsDelegates: [DefaultMaterialLocalizations.delegate],
      theme: widget.controller.getTheme(),
      home: widget.firstTime
          ? QuickStartPage(
              themeHandler: widget.controller,
            )
          : HomePage(
              themeHandler: widget.controller,
            ),
    );
  }
}
