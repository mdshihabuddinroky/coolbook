import 'package:book/detailscreen.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math' as math;
import 'dart:math';

class Bookmark extends StatefulWidget {
  Bookmark({Key? key}) : super(key: key);

  @override
  State<Bookmark> createState() => _BookmarkState();
}

class _BookmarkState extends State<Bookmark> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getbookmarklist();
  }

  var Bookmarklist = [].obs;
  getbookmarklist() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    List<String> mList = (pref.getStringList('favoriteList') ?? <String>[]);
    List<int> mOriginaList = mList.map((i)=> int.parse(i)).toList();


    Bookmarklist.value = mOriginaList;
    print(Bookmarklist.length);
  }
  removebookmark()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.remove('favoriteList');
    Bookmarklist.value=[];
  }

  final _data = Get.arguments;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [IconButton(onPressed: (){removebookmark();}, icon: Icon(Icons.delete_forever_outlined))],
          backgroundColor: const Color(0xff0B4956),
          title: Text('বুকমার্ক', style: const TextStyle(fontFamily: 'title',)),
        ),
        body: Obx(() => ListView.builder(
            itemCount: Bookmarklist.length,
            itemBuilder: (context, index) {
               List colors = [Colors.red, Colors.green, Colors.yellow];
  math.Random random = new Random();

  int index = 0;

 index = random.nextInt(3);
              // print(Bookmarklist.length);
              return GestureDetector(
                onTap: (){Get.to((()=>details()), arguments: [_data, Bookmarklist[index]]);},
                child: ListTile(
                  leading: Container(
                    height: 40,width: 40,
                    child: Center(child: Text(Bookmarklist[index].toString())),
                        //margin: const EdgeInsets.all(10.0),
                        decoration:  BoxDecoration(
                          color: Colors.transparent,
                          shape: BoxShape.circle,border: Border.all(color: colors[index])
                        ),),
                  title: Text('${_data[Bookmarklist[index]].title}',style: const TextStyle(fontFamily: 'subtitle',fontSize: 20),),
                ),
              );
            })));
  }
}
