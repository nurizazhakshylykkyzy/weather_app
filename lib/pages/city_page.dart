import 'dart:developer';

import 'package:flutter/material.dart';

class CityPage extends StatelessWidget {
  CityPage({Key key}) : super(key: key);
  final TextEditingController textEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final Size mediaQuery = MediaQuery.of(context).size;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
      ),
      body: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/pogoda.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  controller: textEditingController,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(40.0),
                        borderSide:
                            const BorderSide(color: Colors.blue, width: 3.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(40.0),
                        borderSide:
                            const BorderSide(color: Colors.green, width: 3.0),
                      ),
                      hintText: 'Шаардын атын жаз ',
                      hintStyle: const TextStyle(
                        color: Colors.white,
                      )),
                ),
              ),
              SizedBox(
                height: mediaQuery.height * 0.05,
              ),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                    shape: const StadiumBorder(),
                    backgroundColor: const Color.fromARGB(255, 112, 110, 110),
                    primary: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 10)),
                onPressed: () {
                  FocusScope.of(context).unfocus();
                  Navigator.pop(context, textEditingController.text);
                  log('textEditingController ==> ${textEditingController.text}');
                  // ignore: avoid_print
                  print(
                      'textEditingController ==> ${textEditingController.text}');
                },
                child: const Text(
                  'Шаарды изде',
                  style: TextStyle(fontSize: 35),
                ),
              ),
            ],
          )),
    );
  }
}
