/* 
  Author - Kayla Thornton
  Purpose - Render details about meal logs
*/
import 'package:flutter/material.dart';
import '../../models/meal_model.dart';

class MealDetailScreen extends StatefulWidget {
  // accept and save food log
  final MealModel log;
  const MealDetailScreen({super.key, required this.log});

  @override
  _MealDetailScreenState createState() => _MealDetailScreenState();
}


// TO-DO - refactor code to accept database objects
class _MealDetailScreenState extends State<MealDetailScreen> {
  // store info of corresponding food log with related reviews
  late final MealModel log;

  // initialize food log data
  @override
  void initState() {
    super.initState();
    log = widget.log;
  }

  // render all log information including log name, date, description, and cost
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Details Screen'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(log.name, style: TextStyle( fontSize: 24, fontWeight: FontWeight.w500)),
          SizedBox( height: 30 ),

          Row(
            children: [ 
              Text('\$${log.cost}', style: TextStyle( fontSize: 18, color: Colors.blueGrey)),
              SizedBox( width: 30 ),
              Text(log.date, style: TextStyle( fontSize: 18, color: Colors.blueGrey)),
            ],
          ),
          SizedBox( height: 30 ),

          Text(log.desc, textAlign: TextAlign.start,)
        ],
      )
    );
  }
}
