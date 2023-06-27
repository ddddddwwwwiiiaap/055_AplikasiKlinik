import 'package:aplikasiklinik/themes/custom_colors.dart';
import 'package:aplikasiklinik/themes/material_colors.dart';
import 'package:aplikasiklinik/utils/constants.dart';
import 'package:aplikasiklinik/view/login.dart';
import 'package:flutter/material.dart';


class NextPages extends StatefulWidget {
  const NextPages({super.key});

  @override
  State<NextPages> createState() => _NextPagesState();
}

class _NextPagesState extends State<NextPages> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: colorPrimary,
      body: SizedBox(
        width: size.width,
        height: size.height,
        child: SafeArea(
          child: Column(
          children: [
            buildHeader(size),
            buildLogoApp(),
            buildDescApp(),
            buildButtonNext()
          ],
        )),
      ),
    );
  }

  Widget buildHeader(Size size) {
    return SizedBox(
      width: size.width,
      height: size.height/4,
      child: Stack(
        children: [
          Positioned(
            top: -60,
            left: 240,
            right: 0,
            bottom: 0,
            child: Image.asset("assets/image/clock.png")),
          Positioned.fill(
            top: 60,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.only(left: 24),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 24),
                    child: Text(textWelcome, style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),),
                  ),
                  Text("Kami Siap Melayani\nAnda", style: TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),)
                ],
              ),
            ))
        ],
      ),
    );
  }

  Widget buildLogoApp() {
    return Container(
      margin: const EdgeInsets.only(bottom: 40),
      child: Image.asset("assets/image/logo.png"));
  }

  Widget buildDescApp() {
    return Container(
      margin: const EdgeInsets.only(bottom: 90),
      child: const Center(child: Text(descApp, style: TextStyle(color: Colors.white, fontSize: 16), textAlign: TextAlign.center,)));
  }

  Widget buildButtonNext() {
    return ElevatedButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => Login())), 
    style: ButtonStyle(
      backgroundColor: const MaterialStatePropertyAll(colorButton),
      shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)))
    ),
    child: Container(
      width: 120,
      height: 40,
      child: const Center(child: Text(textNext, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),))));
  }
}