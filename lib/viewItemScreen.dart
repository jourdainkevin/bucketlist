import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:dio/dio.dart';

class ViewItemScreen extends StatefulWidget {
  String title;
  String image;
  int index;
  bool completed;
  ViewItemScreen({super.key,required this.index ,required this.title, required this.image, required this.completed});

  @override
  State<ViewItemScreen> createState() => _ViewItemScreenState();
}

class _ViewItemScreenState extends State<ViewItemScreen> {

  Future<void> deleteData() async{
    Navigator.pop(context);
    try{
      Response response = await Dio().delete("https://bucketlist-572b7-default-rtdb.europe-west1.firebasedatabase.app/bucketlist/${widget.index}.json");
      Navigator.pop(context, "refresh");
    }catch(e){
      print('Error: $e');
    }
  }

  Future<void> markAsCompleted() async{
    try{
      Map<String, dynamic> dataTrue = {
        "completed": true
      };
      Response response = await Dio().patch("https://bucketlist-572b7-default-rtdb.europe-west1.firebasedatabase.app/bucketlist/${widget.index}.json", data: dataTrue);
      Navigator.pop(context, "refresh");
    }catch(e){
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          PopupMenuButton(
              onSelected: (value){
                if(value==1){
                  showDialog(
                      context: context,
                      builder: (context){
                        return AlertDialog(
                          title: Text('Are you sure you want to delete this item?'),
                          actions:[
                            InkWell(
                              onTap: (){
                                Navigator.pop(context);
                              },
                              child: Text('Cancel')
                            ),
                            InkWell(
                                onTap: () async{
                                  await deleteData();
                                },
                                child: Text('Confirm'))
                          ],
                        );
                      },
                  );
                }
                else if(value==2){
                  markAsCompleted();
                }
              },
              itemBuilder: (context){
                return [
                  PopupMenuItem(
                      value:1,
                      child: Text('Delete')),
                  PopupMenuItem(
                      value:2,
                      child: Text('Mark as completed')),
                ];
              })
        ],
        title: Text("${widget.title}"),
      ),
      body: Column(
        children: [
          widget.completed ? Icon(Icons.check_circle, color: Colors.green, size: 50,) : Container(),
          Container(
            child: Image.network(widget.image),
          ),
        ],
      ),
    );
  }
}
