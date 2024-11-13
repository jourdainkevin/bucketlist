import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:dio/dio.dart';

class AddBucketListScreen extends StatefulWidget {
  int index;
  AddBucketListScreen({super.key, required this.index});

  @override
  State<AddBucketListScreen> createState() => _AddBucketListScreenState();
}

class _AddBucketListScreenState extends State<AddBucketListScreen> {

  TextEditingController itemText = TextEditingController();
  TextEditingController costText = TextEditingController();
  TextEditingController imageUrlText = TextEditingController();

  Future<void> addData() async{
    try{
      Map<String, dynamic> dataTrue = {
        "item": itemText.text,
        "cost": costText.text,
        "image": imageUrlText.text,
        "completed": false
      };
      Response response = await Dio().patch("https://bucketlist-572b7-default-rtdb.europe-west1.firebasedatabase.app/bucketlist/${widget.index}.json", data: dataTrue);
      Navigator.pop(context, 'refresh');
    }catch(e){
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    var addFormKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(
        title: Text("Add Bucket List"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Form(
            key: addFormKey,
            child: Column(
              children: [
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value){
                    if(value == null || value.isEmpty){
                      return 'Please enter an item';
                    }
                    return null;
                  },
                  controller: itemText,
                  decoration: InputDecoration(
                      labelText: 'Item',
                      border: OutlineInputBorder()
                  ),
                ),
                SizedBox(height: 30),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value){
                    if(double.tryParse(value!) == null || value.isEmpty){
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                  controller: costText,
                  decoration: InputDecoration(
                      labelText: 'Cost',
                      border: OutlineInputBorder()
                  ),
                ),
                SizedBox(height: 30),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value){
                    if(value == null || value.isEmpty){
                      return 'Please enter an image url';
                    }
                    return null;
                  },
                  controller: imageUrlText,
                  decoration: InputDecoration(
                      labelText: 'Image Url',
                      border: OutlineInputBorder()
                  ),
                ),
                SizedBox(height: 30),
                ElevatedButton(onPressed: (){
                  if(addFormKey.currentState!.validate()){
                    print('Add');
                    addData();
                  }else{
                    print('Error');
                  }
                }, child: Text('Add'))
              ],
            ),
          ),
        ),
      ),
    );
  }
}