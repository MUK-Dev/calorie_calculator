import 'package:flutter/material.dart';

class Overtook extends StatelessWidget {
  const Overtook({Key? key, this.value}) : super(key: key);
  final String? value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Center(
        child: Column(
          children: [
            Text(
              'You overtook by',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Theme.of(context).textTheme.headline1!.color,
                  fontSize: 17),
            ),
            RichText(
                textAlign: TextAlign.center,
                text: TextSpan(children: [
                  TextSpan(
                      text: value,
                      style: TextStyle(
                          color: Theme.of(context).textTheme.headline1!.color,
                          fontSize: 50,
                          fontWeight: FontWeight.bold)),
                  TextSpan(
                      text: ' kcal',
                      style: TextStyle(
                          color: Theme.of(context).textTheme.headline1!.color,
                          fontSize: 40))
                ]))
          ],
        ),
      ),
    );
  }
}
