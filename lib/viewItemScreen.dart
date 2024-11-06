import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

class ViewItemScreen extends StatefulWidget {
  String title;
  String image;
  ViewItemScreen({super.key, required this.title, required this.image});

  @override
  State<ViewItemScreen> createState() => _ViewItemScreenState();
}

class _ViewItemScreenState extends State<ViewItemScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.title}"),
      ),
      body: Container(
        child: Image.network(widget.image),
      ),
    );
  }
}
