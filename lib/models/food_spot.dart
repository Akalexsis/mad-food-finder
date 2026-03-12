/* 
  Author - Kayla Thornton
  Purpose - Define structure for Food Spots database
 */
class FoodSpot {
  final int id;
  final String name;
  final String imageUrl;
  final String hours;
  final int cost;
  final String cuisine;
  final bool isFavorite;

  FoodSpot({ 
    required this.id, 
    required this.name,
    required this.imageUrl, 
    required this.hours, 
    required this.cost,
    required this.cuisine,
    required this.isFavorite,
  });

  // map to match database columns for database use
  Map toMap() {
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

  // convert databse entries to object model
}