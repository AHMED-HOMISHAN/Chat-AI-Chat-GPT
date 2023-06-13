// ignore_for_file: file_names, use_build_context_synchronously

import 'package:chatgpt_course/screens/chat_screen.dart';
import 'package:chatgpt_course/services/assets_manager.dart';
import 'package:flutter/material.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    setState(() {});
    super.initState();
    _navigatetohome();
  }

  _navigatetohome() async {
    await Future.delayed(const Duration(milliseconds: 2000), () {});
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const ChatScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Expanded(child: _getlogo()),
            const SizedBox(height: 20, width: 20),
            const SizedBox(height: 20, width: 20),
            const Text('By AHMED SAMEER',
                style: TextStyle(
                  color: Colors.white,
                )),
            const SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }
}

Widget _getlogo() {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Container(
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(15)),
          width: 150,
          height: 150,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(AssetsManager.botImage),
          )),
    ],
  );
}
