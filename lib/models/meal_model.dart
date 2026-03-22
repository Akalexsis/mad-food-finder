/*
  Author - Kayla Thornton
  Purpose - Store and save meal logs to and from database
 */

class MealModel {
  final int? id;
  final String name; // Keep this for custom entries
  final double cost;
  final String desc;
  final String date;
  final int? foodSpotId; //  Links to food_spots table

  const MealModel({
    this.id,
    required this.name,
    required this.cost,
    required this.desc,
    required this.date,
    this.foodSpotId, // Can be null for custom entries
  });

  // map object fields to columns for database use
  Map<String, dynamic> toMap(){
    return {
      'id': id,
      'name': name,
      'cost': cost,
      'desc': desc,
      'date': date,
      'foodSpotId': foodSpotId, // Add to database
    };
  }

  // map database records to dart object for code use
  factory MealModel.fromMap(Map map){
    return MealModel(
      id : map['id'],
      name : map['name'],
      cost: map['cost'],
      desc : map['desc'],
      date : map['date'],
      foodSpotId: map['foodSpotId'], // Read from database
    );
  }

  // update meal objects
  MealModel copyWith({
    int? id,
    String? name,
    double? cost,
    String? desc,
    String? date,
    int? foodSpotId,
  }) {
    return MealModel(
      id : id ?? this.id,
      name : name ?? this.name,
      cost: cost ?? this.cost,
      desc : desc ?? this.desc,
      date : date ?? this.date,
      foodSpotId: foodSpotId ?? this.foodSpotId,
    );
  }
}