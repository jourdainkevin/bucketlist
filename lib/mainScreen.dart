import 'package:bucketlist/viewItemScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:dio/dio.dart';

import 'addBucketList.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>{
  List<dynamic> bucketListData = [];
  bool isLoading = false;
  bool isError = false;

  Future<void> getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      Response response = await Dio().get('https://bucketlist-572b7-default-rtdb.europe-west1.firebasedatabase.app/bucketlist.json');
      if(response.data is List){
        bucketListData = response.data;
      }
      else{
        bucketListData = [];
      }
      isLoading = false;
      isError = false;
      setState(() {});
    }
    catch (e) {
      setState(() {
        isLoading = false;
        isError = true;
      });
      }
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  Widget errorWidget({required String errorText}){
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.warning),
          Text(errorText),
          ElevatedButton(onPressed: getData, child: Text('Retry'))
        ],
      ),
    );
  }

  Widget ListDataWidget(){
    List<dynamic> filteredList = bucketListData
        .where((element) => element is Map && !(element["completed"] ?? false)).toList();

    return filteredList.length < 1 ?
    Center(child: Text("No item on the bucket list")) :
    ListView.builder(
        itemCount: bucketListData.length,
        itemBuilder: (BuildContext context, int index){
          return (bucketListData[index] is Map && !(bucketListData[index]?["completed"]?? false)) ?
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context){
                  return ViewItemScreen(
                      index: index,
                      completed: bucketListData[index]?['completed'] ?? false,
                      title: bucketListData[index]?['item'] ?? "",
                      image: bucketListData[index]?['image'] ?? "");
                })).then((value){
                  if(value == "refresh"){
                    getData();
                  }
                });
              },
              leading: CircleAvatar(
                radius: 25,
                backgroundImage: NetworkImage(bucketListData[index]?['image'] ?? ""),
              ),
              title: Text(bucketListData[index]?['item'] ?? ""),
              trailing: Text(bucketListData[index]?['cost'].toString() ?? ""),
            ),
          ) : SizedBox();
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context){
            return AddBucketListScreen(index: bucketListData.length);
          })).then((value){
            if(value == "refresh"){
              getData();
            }
          });
        },
        shape: CircleBorder(),
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        title: Text('Bucket List'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
                onPressed: (){
                  getData();
                },
                icon: Icon(Icons.refresh)),
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async{
          getData();
        },
        child: isLoading ?
            Center(child: CircularProgressIndicator())
            : isError
              ? errorWidget(errorText: "Error fetching data...")
              : ListDataWidget(),
      )
    );
  }
}
