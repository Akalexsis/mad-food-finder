/* 
  Author - Kayla Thornton
  Purpose - Define structure for Food Spots database
 */
class FoodSpot {
  final int? id;
  final String name;
  final String imageUrl;
  final String hours;
  final int cost;
  final String cuisine;
  final bool isFavorite; 

  //final String? menuUrl; for food spot details page

  FoodSpot({ 
    this.id, 
    required this.name,
    required this.imageUrl, 
    required this.hours, 
    required this.cost,
    required this.cuisine,
    this.isFavorite = false, // default is false
  });

  // map to match database columns for database use 'column' : obj_name
  Map<String, dynamic> toMap() {
    return {
      'id' : id,
      'name': name,
      'image': imageUrl,
      'hours': hours,
      'cost': cost,
      'cuisine': cuisine,
      'favorite': isFavorite
    };
  }

  // convert databse record to object model obj_name : map['column']
  factory FoodSpot.fromMap(Map<String, dynamic> map) {
    return FoodSpot(
      id: map['id'],
      name: map['name'], 
      imageUrl: map['image'], 
      hours: map['hours'], 
      cost: map['cost'], 
      cuisine: map['cuisine'],
      isFavorite: map['favorite'] ==1
    ); 
  }
  
  // update object when record has been updated
  FoodSpot copyWith( { 
    int? id,
    String? name,
    String? imageUrl, 
    String? hours,
    int? cost,
    String? cuisine,
    bool? isFavorite} ) {
      return FoodSpot(
        id: id ?? this.id,
        name: name ?? this.name, // only update value if there is a new value
        imageUrl: imageUrl ?? this.imageUrl, 
        hours: hours ?? this.hours, 
        cost: cost ?? this.cost, 
        cuisine: cuisine ?? this.cuisine,
        isFavorite: isFavorite ?? this.isFavorite,
      );
  }
}