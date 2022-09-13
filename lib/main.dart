import 'dart:async';
import 'dart:html';

import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

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
      home: MyHomePage(
        myChild: MyCenterWidget(),
      ),
    );
  }
}

class MyCenterWidget extends StatelessWidget {
  MyCenterWidget({Key? key}) : super(key: key);
  bool started = false;

  @override
  Widget build(BuildContext context) {
    final defaultseconds = MyInheritedWidget.of(context)!.myData.defaultseconds;
    final defaultminutes = MyInheritedWidget.of(context)!.myData.defaultMinutes;
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 100.0,
          ),
          Center(
            child: Text(
              // "$defaultHours:
              '$defaultseconds : $defaultminutes',
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
    );
  }
}

class TimeData extends Equatable {
  final int second;
  final int minute;
  final String defaultseconds;
  final String defaultMinutes;

  TimeData(this.second, this.minute, this.defaultMinutes, this.defaultseconds);

  @override
  List<Object> get props => [second, minute, defaultseconds, defaultMinutes];

  TimeData copyWith({
    int? second,
    int? minute,
    String? defaultseconds,
    String? defaultminutes,
  }) {
    return TimeData(
      second ?? this.second,
      minute ?? this.minute,
      defaultMinutes,
      defaultseconds!,
    );
  }
}

class MyInheritedWidget extends InheritedWidget {
  MyInheritedWidget({
    required Widget child,
    required this.myData,
  }) : super(child: child);

  final TimeData myData;

  @override
  bool updateShouldNotify(MyInheritedWidget oldWidget) {
    return myData != oldWidget.myData;
  }

  static MyInheritedWidget? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<MyInheritedWidget>();
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({required this.myChild});
  // const MyHomePage({Key? key}) : super(key: key);
  final Widget myChild;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // int seconds = 0, minutes = 0, hours = 0;
  TimeData data = TimeData(0, 0, '00', '00');
  // String defaultSeconds = "00", defaultMinutes = "00", defaultHours = "00";
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
      int runSeconds = data.second + 1;
      int runMinutes = data.minute;
      // int runHours = hours;

      if (runSeconds > 59) {
        // if (runMinutes > 59) {
        //   runHours++;
        //   runMinutes = 0;
        // } else
        {
          runMinutes++;
          runSeconds = 0;
        }
      }
      setState(() {
        data = data.copyWith(
          second: runSeconds,
          minute: runMinutes,
        );
        // data.defaultseconds = (data.second >= 10) ? '$data.second' :;
        // seconds = runSeconds;
        // minutes = runMinutes;
        // hours = runHours;
        // defaultSeconds = (seconds >= 10) ? "$seconds" : "0$seconds";
        // defaultMinutes = (minutes >= 10) ? "$minutes" : "0$minutes";
        // defaultHours = (hours >= 10) ? "$hours" : "0$hours";
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Center(child: Text("Chronograph App")),
        ),
        body: MyInheritedWidget(
          child: widget.myChild,
          // myData: (seconds,minutes,hours),
          myData: data,
        ));
  }
}
