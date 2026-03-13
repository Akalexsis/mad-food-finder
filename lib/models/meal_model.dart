/*
  Author - Kayla Thornton
  Purpose - Store and save meal logs to and from database
 */

class MealModel {
  final int? id;
  final String name;
  final String desc;
  final String date;

  const MealModel({
    this.id,
    required this.name,
    required this.desc,
    required this.date
  });

  // map object fields to columns for database use
  Map toMap(){
    return {
      'id': id,
      'name': name,
      'desc': desc,
      'date': date
    };
  }

  // map database records to dart object for code use
  factory MealModel.fromMap(Map map){
    return MealModel(
    id : map['id'],
    name : map['name'],
    desc : map['desc'],
    date : map['date']
    );
  }

  // update meal objects
  MealModel copyWith({
    int? id,
    String? name,
    String? desc,
    String? date
  }) {
    return MealModel(
      id : id ?? this.id,
      name : name ?? this.name,
      desc : desc ?? this.desc,
      date : date ?? this.date
    );
  }
}