import 'dart:math' as math;
import 'dart:math';
import 'dart:ui';


import 'package:book/bookmark.dart';
import 'package:book/cons.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:book/detailscreen.dart';
import 'package:book/model.dart';
import 'package:book/staticdetails.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show SystemNavigator, rootBundle;
import 'package:get/get.dart';
import 'package:share/share.dart';
import 'dart:convert';
import 'package:email_launcher/email_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:book/controller.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Controller c = Get.put(Controller());
  @override
  Widget build(BuildContext context) {
    return Obx(() => GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        // ignore: unrelated_type_equality_checks
        theme: ThemeData(brightness: (c.isdarkmode==true)?Brightness.dark:Brightness.light),
        home: AnimatedSplashScreen(
            duration: 3000,
            splash: const Text(
              'ইসলাম ও মুসলমানদের পরিচয়',
              style: TextStyle(
                  fontFamily: 'title', color: Colors.white, fontSize: 22),
            ),
            nextScreen: MyHomePage(),
            splashTransition: SplashTransition.slideTransition,
            backgroundColor: maincolor)));
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final Controller c = Get.put(Controller());
  //Future launchEmail({})
  var scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
    //changetheme();

    LoadData();
    loaddark();
    loadfontsize();
  }
  

 loaddark()async{
   SharedPreferences pref = await SharedPreferences.getInstance();
  c.isdarkmode(pref.getBool('darkmodestatus')) ;
  print(c.isdarkmode);
 }
 loadfontsize()async{
   SharedPreferences pref = await SharedPreferences.getInstance();
  c.fontsize(pref.getDouble('fontsize')) ;
 }


  searchdata(str) {
    var strExist = str.length > 0 ? true : false;
    if (strExist) {
      var filterdata = <Data>[];
      for (var i = 0; i < undatalist.length; i++) {
        if (undatalist[i].content.contains(str)) {
          filterdata.add(undatalist[i]);
         print(undatalist[i]);
        }
      }
      var filterexist = filterdata == null ? false : true;
      if (filterexist) {
        datalist.value = filterdata;
      }
    } else {
     datalist.value= this.undatalist ;
    }
  }

  changetheme() async {
    Get.changeTheme(ThemeData.dark());
  }

  var datalist = <Data>[].obs;
  var undatalist = <Data>[].obs;
  var isloading = true.obs;
  Future<dynamic> LoadData() async {
    var jsontext = '';
    jsontext = await rootBundle.loadString('assets/data.json');
    var Datalist = dataFromJson(jsontext);
    if (Datalist != null) {
      datalist.value = Datalist;
      undatalist.value = Datalist;
    }
    isloading(false);
  }

  var search = false.obs;
  

  @override
  Widget build(BuildContext context) {
    return Obx(() { 
      return Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          title: (search == true)
              ? CupertinoSearchTextField(
                  backgroundColor: Colors.white,
                  onChanged: (str) {

                    searchdata(str);
                  },
                )
              : const Text(
                  'ইসলাম ও মুসলমানদের পরিচয়',
                  style: TextStyle(fontFamily: 'title'),
                ),
          backgroundColor: maincolor,
          actions: [
           if(search == false)
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                if (search == true) {
                  search(false);
                } else {
                  search(true);
                }
              },
            )
          ],
          leading: IconButton(
              onPressed: () {
                if (search == true) {
                  search(false);
                } else {
                  scaffoldKey.currentState!.openDrawer();
                }
              },
              icon: (search == true) ? Icon(Icons.close) : Icon(Icons.menu)),
        ),
        drawer: Drawer(
          child: SingleChildScrollView(
            child: SafeArea(
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    color: maincolor,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 10, left: 10, right: 10, bottom: 10),
                      child: Column(
                        children: const [
                          Text(
                            'ইসলাম ও মুসলমানের পরিচয়',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'title',
                                fontSize: 20),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            'এটি মূলত উর্দুভাষায় লিখিত , বহু ভাষায় অনূদিত এবং সর্বমহলে সমাদৃত একটি সরল গ্রন্থনা , শুধু উর্দুভাষাতেই যার লক্ষ লক্ষ কপি মুদ্রণ ও বিতরণ হয়েছে এবং বিভিন্ন শিক্ষা প্রতিষ্ঠানে পাঠ্যপুস্তকরূপে গৃহীত হয়েছে । বর্তমান বঙ্গানুবাদ সেই ধারার একটি অংশ ।',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'subtitle',
                                fontSize: 15),
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                      onTap: () {},
                      child: const ListTile(
                        leading: Icon(Icons.format_align_left),
                        title: Text(
                          'অধ্যায় সমূহ',
                          style: TextStyle(
                            fontFamily: 'title',
                            fontSize: 18,
                          ),
                        ),
                      )),
                  GestureDetector(
                      onTap: () async {
                        SharedPreferences pref =
                            await SharedPreferences.getInstance();
                        var lastRead = pref.get('lastread') ?? 0;
                        Navigator.of(context).pop();

                        Get.to(details(), arguments: [datalist, lastRead]);
                      },
                      child: const ListTile(
                        leading: Icon(Icons.history),
                        title: Text(
                          'সর্বশেষ পঠিত',
                          style: TextStyle(
                            fontFamily: 'title',
                            fontSize: 18,
                          ),
                        ),
                      )),
                  GestureDetector(
                      onTap: () {
                        Get.to(() =>Bookmark(), arguments: datalist);
                      },
                      child: const ListTile(
                        leading: Icon(Icons.book_outlined),
                        title: Text(
                          'বুকমার্ক ',
                          style: TextStyle(
                            fontFamily: 'title',
                            fontSize: 18,
                          ),
                        ),
                      )),
                  GestureDetector(
                      onTap: () {Get.to(const Staticdetail(),arguments: ['বই পরিচিতি',boiporichiti]);},
                      child: const ListTile(
                        leading: Icon(Icons.menu_book_outlined),
                        title: Text(
                          'বই পরিচিতি',
                          style: TextStyle(
                            fontFamily: 'title',
                            fontSize: 18,
                          ),
                        ),
                      )),
                  GestureDetector(
                      onTap: () {

                       Get.defaultDialog(title: 'সেটিংস',titleStyle: const TextStyle(fontFamily: 'title'),
                      content: Obx(() => Column(
                          children: [
                            Row(
                             // mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                 const Text('ফন্ট সাইজ',style: TextStyle(fontFamily: 'subtite'),),
                                Slider(min: 10,max: 100,value: c.fontsize.value,label: c.fontsize.toInt().toString(), onChanged: (value){c.fontsize(value);
                                setfontsize()async{
                               SharedPreferences prefs = await SharedPreferences.getInstance();
                               prefs.setDouble('fontsize', value);
                              }
                              setfontsize();
                                }),
                              ],
                              
                            ),
                            Center(child: Text('আল্লাহু আকবার',style: TextStyle(fontFamily: 'subtitle',fontSize: c.fontsize.value),),),
                            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                              const Text('ডার্ক মোড',style: TextStyle(fontFamily: 'subtite'),),
                              Switch(activeColor: Colors.blueAccent,value: (c.isdarkmode==true)?true:false, onChanged: (value){c.isdarkmode(value);
                               setmode()async{
                               SharedPreferences prefs = await SharedPreferences.getInstance();
                               prefs.setBool('darkmodestatus', value);
                              }
                              setmode();}
                            )
                            ],),
                            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                              const Text('স্ক্রীন অন রাখুন',style: TextStyle(fontFamily: 'subtite'),),
                              Switch(activeColor: Colors.blueAccent,value: (c.isscreenon==true)?true:false, onChanged: (value){
                                c.isscreenon(value);
                                
                              }
                            )
                            ],)
                          ],
              ),)
                       );
                      },
                      child: const ListTile(
                        leading: Icon(Icons.settings),
                        title: Text(
                          'সেটিংস',
                          style: TextStyle(
                            fontFamily: 'title',
                            fontSize: 18,
                          ),
                        ),
                      )),
                  GestureDetector(
                      onTap: () {
                        Get.defaultDialog(
                          
                          title: 'আপনার রেটিং আমাদের কাছে অনেক কিছু!',titleStyle: TextStyle(fontFamily: 'title'),
                         
                          content: Column(
                            children: [Text('রাসুল (সা.) বলেছেন যে ব্যক্তি মানুষের কৃতজ্ঞতা প্রকাশ করে না সে আল্লাহর প্রতি ও কৃতজ্ঞতা প্রকাশ করে না।(সুনান আবু দাঊদ ৪৮১১)',style: TextStyle(fontFamily: 'subtitle'),),
                            Text('একটু কষ্ট করে ৫ষ্টার রেটিং দিয়ে এবং সুন্দর একটি রিভিউ লিখে আমাদের আরও কাজ করার অনুপ্রেরিত করুন।',style: TextStyle(fontFamily: 'subtitle'),),
                            SizedBox(height: 10,),
                            
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(onTap: (){Get.back();},child: Text('পরে দিব ইনশাআল্লাহ',style: TextStyle(fontFamily: 'subtitle'),)),
                                GestureDetector(onTap: (){
                                _launchURL(String url) async {
                              if (await canLaunch(url)) {
                              await launch(url);
                              } 
                            else {
                             throw 'Could not launch $url';
                          }
                          }
       _launchURL("https://play.google.com/store/apps/details?id=" + package);
                                },child: Text('রেটিং দিব',style: TextStyle(fontFamily: 'subtitle',color: Colors.green),))
                              ],
                            ),
                            
                            ],
                            
                          ),
                          

                        );
                      },
                      child: const ListTile(
                        leading: Icon(Icons.thumb_up_outlined),
                        title: Text(
                          'রেটিং দিন',
                          style: TextStyle(
                            fontFamily: 'title',
                            fontSize: 18,
                          ),
                        ),
                      )),
                  GestureDetector(
                       onTap: ()async{

                         String email=contactmail;
                         String subject='মতামত';
                         String body='আপনার মতামত লিখুন';

                         String? encodeQueryParameters(Map<String, String> params) {
                         return params.entries
                         .map((e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
                              .join('&');
                         }
                        final Uri emailLaunchUri = Uri(
                 scheme: 'mailto',
                  path: email,
                      query: encodeQueryParameters(<String, String>{
                 'subject': subject,'body':body}),
                   );
                if(await canLaunch(emailLaunchUri.toString())){
               launch(emailLaunchUri.toString());
               }else{
               print('error');
               }
                       },
                      child: const ListTile(
                    leading: Icon(Icons.comment_bank_outlined),
                    title: Text(
                      'মতামত জানান',
                      style: TextStyle(
                        fontFamily: 'title',
                        fontSize: 18,
                      ),
                    ),
                  )),
                  GestureDetector(
                      onTap: () {
                        Get.to(Staticdetail(),arguments: ['আমাদের সর্ম্পকে',amadersomporke]);
                      },
                      child: const ListTile(
                        leading: Icon(Icons.people_outline),
                        title: Text(
                          'আমাদের সর্ম্পকে',
                          style: TextStyle(
                            fontFamily: 'title',
                            fontSize: 18,
                          ),
                        ),
                      )),
                  GestureDetector(
                      onTap: () {
                        Share.share(sharetext, subject: sharesub);
                      },
                      child: const ListTile(
                        leading: Icon(Icons.share_outlined),
                        title: Text(
                          'শেয়ার করুন',
                          style: TextStyle(
                            fontFamily: 'title',
                            fontSize: 18,
                          ),
                        ),
                      )),
                  GestureDetector(
                      onTap: () {
                        SystemNavigator.pop();
                      },
                      child: const ListTile(
                        leading: Icon(Icons.logout),
                        title: Text(
                          'বাহির',
                          style: TextStyle(
                            fontFamily: 'title',
                            fontSize: 18,
                          ),
                        ),
                      )),
                ],
              ),
            ),
          ),
        ),
        backgroundColor: (c.isdarkmode==true)?Color(0xff303020):Color(0xffDCF7FE),
        body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: (isloading == true)
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : GridView.builder(
                    itemCount: datalist.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 5.0,
                      mainAxisSpacing: 5.0,
                    ),
                    itemBuilder: (context, index) {
                      List colors = [Colors.red, Colors.green, Colors.blue,Colors.grey,Colors.blueAccent,Colors.redAccent];
                      math.Random random = new Random();

                     int colorindex = 0;

                      colorindex = random.nextInt(3);
                     
                      return GestureDetector(
                        onTap: () {
                          Get.to((()=>details()), arguments: [datalist, index]);
                        },
                        child: Card(
                          color: (c.isdarkmode==true)?Color(0xff303030): Color(0xffE2F9FF),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              CircleAvatar(
                                radius: 40,
                                backgroundColor: colors[colorindex].withOpacity(0.20),
                                child: Center(
                                  child: Text(
                                    datalist[index].circleText.toString(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: colors[colorindex].withOpacity(1.0),fontFamily: 'subtitle',fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Text(
                                datalist[index].title.toString(),
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 16,fontFamily: 'subtitle'),
                              )
                            ],
                          ),
                        ),
                      );
                    })),
      );
    });
  }
}
