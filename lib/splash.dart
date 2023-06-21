import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:todo_app_appwrite/VIEWS/login.dart';

class FirstScreen extends StatefulWidget {

  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> with TickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller =  AnimationController(vsync: this, duration: Duration(seconds: 2));
}

@override
  void dispose() {
    _controller.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset('assets/animations/notes.json',
          controller: _controller,
            onLoaded: (compos) {
              _controller
              ..duration = compos.duration
                ..forward().then((value) {
                  Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
                });
            }),
          Center(
            child: Text("Write", style: TextStyle(fontSize: 40, fontFamily: 'cabin'),
            ),
          ),
        ],
      ),
    );
  }
}
