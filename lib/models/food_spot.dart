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

  FoodSpot({ 
    required this.id, 
    required this.name,
    required this.imageUrl, 
    required this.hours, 
    required this.cost,
    required this.cuisine
  });
}