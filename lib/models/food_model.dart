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
  final List<String> potentialAllergens;  // ← potential allergens for sharedPreferences integration
  final String? menuUrl;                   // new menu URL for menu button in DetailScreen

  FoodSpot({ 
    this.id, 
    required this.name,
    required this.imageUrl, 
    required this.hours, 
    required this.cost,
    required this.cuisine,
    this.isFavorite = false,
    this.potentialAllergens = const [],  // default empty list
    this.menuUrl,                          //optional
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
      'favorite': isFavorite ? 1 : 0,
      'potential_allergens': potentialAllergens.join(','),  // store as comma-separated string
      'menu_url': menuUrl,                                   
    };
  }

  // convert database record to object model obj_name : map['column']
  factory FoodSpot.fromMap(Map<String, dynamic> map) {
    return FoodSpot(
      id: map['id'],
      name: map['name'], 
      imageUrl: map['image'],  //  Fixed: was 'imageUrl' but database has 'image'
      hours: map['hours'], 
      cost: map['cost'], 
      cuisine: map['cuisine'],
      isFavorite: map['favorite'] == 1,
      potentialAllergens: map['potential_allergens'] != null   
          ? (map['potential_allergens'] as String).split(',').where((s) => s.isNotEmpty).toList()
          : [],
      menuUrl: map['menu_url'],  //
    ); 
  }
  
  // update object when record has been updated
  FoodSpot copyWith({ 
    int? id,
    String? name,
    String? imageUrl, 
    String? hours,
    int? cost,
    String? cuisine,
    bool? isFavorite,
    List<String>? potentialAllergens,  
    String? menuUrl,                    
  }) {
    return FoodSpot(
      id: id ?? this.id,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl, 
      hours: hours ?? this.hours, 
      cost: cost ?? this.cost, 
      cuisine: cuisine ?? this.cuisine,
      isFavorite: isFavorite ?? this.isFavorite,
      potentialAllergens: potentialAllergens ?? this.potentialAllergens,  
      menuUrl: menuUrl ?? this.menuUrl, 
    );
  }
}