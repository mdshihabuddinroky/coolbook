import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';

class Staticdetail extends StatelessWidget {
  const Staticdetail({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _data = Get.arguments;
    return Scaffold(
appBar: AppBar(
        backgroundColor: const Color(0xff0B4956),
        title: Text(_data[0],
            style: const TextStyle(fontFamily: 'title')),
      ),
      body: Container(
          height: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Html(data: """${_data[1]}""",style: {
                 "body": Style(
                 fontSize: FontSize(18.0),
                       fontFamily: 'subtitle'
                    ),
                 },),
                )
              ],
            ),
          ),
        ),
    );
  }
}