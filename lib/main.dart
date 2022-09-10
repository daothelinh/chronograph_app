import 'dart:async';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyInheritedWidget extends InheritedWidget {
  MyInheritedWidget({required Widget child, required this.myData})
      : super(child: child);

  final int myData;

  @override
  bool updateShouldNotify(MyInheritedWidget oldWidget) {
    return myData != oldWidget.myData;
  }

  static MyInheritedWidget? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<MyInheritedWidget>();
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int seconds = 0, minutes = 0, hours = 0;
  String defaultSeconds = "00", defaultMinutes = "00", defaultHours = "00";
  Timer? time;
  bool started = false;

  // xu li ham logic

  void stop() {
    time!.cancel();
    setState(() {
      started = false;
    });
  }

  void start() {
    started = true;
    time = Timer.periodic(const Duration(seconds: 1), (timer) {
      int runSeconds = seconds + 1;
      int runMinutes = minutes;
      int runHours = hours;

      if (runSeconds > 59) {
        if (runMinutes > 59) {
          runHours++;
          runMinutes = 0;
        } else {
          runMinutes++;
          runSeconds = 0;
        }
      }
      setState(() {
        seconds = runSeconds;
        minutes = runMinutes;
        hours = runHours;
        defaultSeconds = (seconds >= 10) ? "$seconds" : "0$seconds";
        defaultMinutes = (minutes >= 10) ? "$minutes" : "0$minutes";
        defaultHours = (hours >= 10) ? "$hours" : "0$hours";
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("Chronograph App")),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 100.0,
            ),
            Center(
              child: Text(
                "$defaultHours:$defaultMinutes:$defaultSeconds",
                style: const TextStyle(
                  fontSize: 60,
                ),
              ),
            ),
            const SizedBox(
              height: 50.0,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: RawMaterialButton(
                    fillColor: Colors.blue,
                    onPressed: () {
                      (!started) ? start() : stop();
                    },
                    child: Text((!started) ? "start" : "stop"),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
