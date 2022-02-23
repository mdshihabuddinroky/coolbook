import 'package:book/cons.dart';
import 'package:book/controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:book/main.dart';
import 'package:book/model.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_html/flutter_html.dart';

class details extends StatefulWidget {
  details({Key? key}) : super(key: key);

  @override
  State<details> createState() => _detailsState();
}

class _detailsState extends State<details> {
  final Controller c = Get.put(Controller());
  

  @override
  void initState() {
    storeindex();
    isbookmarkenablecheck();
    super.initState();
  }
  isbookmarkenablecheck()async{
SharedPreferences pref = await SharedPreferences.getInstance();
  List<String> mList = (pref.getStringList('favoriteList') ?? <String>[]);
  var containbookmark= mList.contains(_data[1].toString())?true:false;
if(containbookmark){
  isbookmark(true);
}else{
  isbookmark(false);
}
 print(containbookmark);
  }
  var isbookmark = false.obs;
  final _data = Get.arguments;

  storeindex() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setInt("lastread", _data[1]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff0B4956),
        title: Text(_data[0][_data[1]].title.toString(),
            style: const TextStyle(fontFamily: 'title')),
      ),
      // backgroundColor: const Color(0xffdcf7fe),

      body: GestureDetector(
        onTap: () {
          Get.bottomSheet(
              GestureDetector(
                child: GestureDetector(
                  onTap: () {
                    if (isbookmark == true) {
                      isbookmark(false);
                     removebookmark()async{ 
                        SharedPreferences prefs = await SharedPreferences.getInstance();
                        var favoriteList = prefs.getStringList('favoriteList')?? [];
                        favoriteList.removeWhere((item) => item == _data[1].toString());
                        prefs.setStringList('favoriteList', favoriteList);
                        }
                        removebookmark();
                     
                    } else {
                      isbookmark(true);
                      
                      addbookmark()async{ 
                        SharedPreferences prefs = await SharedPreferences.getInstance();
                        var favoriteList = prefs.getStringList('favoriteList')?? [];
                        favoriteList.add(_data[1].toString());
                        prefs.setStringList('favoriteList', favoriteList);
                        }
                        addbookmark();

                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Obx(() =>Container(
                      width: double.infinity,

                     // color: (c.isdarkmode==true)?Colors.black26:Colors.white,
                      child:  Row(
                        
                            children: [
                              (isbookmark == false)
                                  ? Icon(
                                      Icons.bookmark_border_outlined,
                                      color: (c.isdarkmode==true)?Colors.white:maincolor,
                                    )
                                  : Icon(
                                      Icons.bookmark,
                                      color: (c.isdarkmode==true)?Colors.white:maincolor,
                                    ),
                              const SizedBox(
                                width: 10,
                              ),
                               Text(
                                'বুকমার্কে যুক্ত করুন',
                                
                                style: TextStyle(fontFamily: 'subtite',color:(c.isdarkmode==true)?Colors.white:maincolor),
                              )
                            ],
                          ),
                    )),
                  ),
                ),
              ),
              backgroundColor: (c.isdarkmode==true)?Colors.grey:Colors.white,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10))));
        },
        child: Container(
          height: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Text(
                    _data[0][_data[1]].title.toString(),
                    style: const TextStyle(fontFamily: 'title', fontSize: 22),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Html(data: """${_data[0][_data[1]].content.toString()}""",style: {
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
      ),
    );
  }
}
