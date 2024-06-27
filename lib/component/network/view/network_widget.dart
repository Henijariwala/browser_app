import 'package:flutter/material.dart';

class Network_Widget extends StatelessWidget {
  const Network_Widget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Icon(Icons.network_check_rounded,color: Colors.grey,),
        Text("No network connection",style: TextStyle(
          color: Colors.grey,fontSize: 15,
        ),),
      ],
    );
  }
}
