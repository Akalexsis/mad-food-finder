/* 
  Author - Kayla Thornton
  Purpose - Define structure for reviews database
 */
class Review {
  final int? id;
  final String name;
  final String desc;
  final String date;
  final int? foodId; 

  Review({ 
    this.id, 
    required this.name,
    required this.desc, 
    required this.date,
    this.foodId, 
  });

  // map to match database columns for database use 'column' : obj_name
  Map toMap() {
    return {
      'id' : id,
      'name': name,
      'desc': desc,
      'date': date,
      'foodId': foodId
    };
  }

  // convert databse record to object model obj_name : map['column']
  factory Review.fromMap(Map map) {
    return Review(
      id: map['id'],
      name: map['name'], 
      desc: map['desc'], 
      date: map['date'],
      foodId: map['foodId']
    ); 
  }
  
  // update object when record has been updated
  Review copyWith( { 
    int? id,
    String? name,
    String? desc, 
    String? date,
    int? foodId} ) {
      return Review(
        id: id ?? this.id,
        name: name ?? this.name, // only update value if there is a new value
        desc: desc ?? this.desc, 
        date: date ?? this.date,
        foodId: foodId ?? this.foodId
      );
  }
}