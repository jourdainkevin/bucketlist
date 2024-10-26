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

  Future<void> getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      Response response = await Dio().get('https://bucketlist-572b7-default-rtdb.europe-west1.firebasedatabase.app/bucketlist.json');
      setState(() {
        bucketListData = response.data;
        isLoading = false;
      });
    }
    catch (e) {
      setState(() {
        isLoading = false;
      });
      showDialog(context: context, builder: (context){
        return AlertDialog(
          title: Text('Cannot connect to server !'),
        );
      });
      }
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context){
            return AddBucketListScreen();
          }));
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
        child: isLoading ? Center(child: CircularProgressIndicator()) : ListView.builder(
            itemCount: bucketListData.length,
            itemBuilder: (BuildContext context, int index){
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              leading: CircleAvatar(
                radius: 25,
                backgroundImage: NetworkImage(bucketListData[index]['image'] ?? ""),
              ),
              title: Text(bucketListData[index]['item'] ?? ""),
              trailing: Text(bucketListData[index]['cost'].toString() + "€" ?? ""),
            ),
          );
        }),
      )
    );
  }
}
