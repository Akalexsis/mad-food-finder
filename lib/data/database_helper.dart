import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/food_model.dart';
import '../models/review_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('food_spots.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    //FOOD SPOT table
    await db.execute('''
      CREATE TABLE food_spots(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        image TEXT NOT NULL,
        hours TEXT NOT NULL,
        cost INTEGER NOT NULL,
        cuisine TEXT NOT NULL,
        favorite INTEGER NOT NULL DEFAULT 0     
      )
     ''');

    // REVIEW table
    await db.execute('''
      CREATE TABLE reviews(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        desc TEXT NOT NULL,
        date TEXT NOT NULL,
        foodId INTEGER,
        FOREIGN KEY (foodId) REFERENCES food_spots (id) ON DELETE CASCADE)
''');
  }

  //FOOD SPOT OPERATIONS
  Future<int> insertFoodSpot(FoodSpot foodSpot) async {
    final db = await instance.database;
    return await db.insert('food_spots', foodSpot.toMap());
  }

  Future<List<FoodSpot>> getAllFoodSpots() async {
    final db = await instance.database;
    final result = await db.query('food_spots');
    return result.map((map) => FoodSpot.fromMap(map)).toList();
  }

  Future<FoodSpot?> getFoodSpotsById(int id) async {
    final db = await instance.database;
    final result = await db.query(
      'food_spots',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (result.isNotEmpty) {
      return FoodSpot.fromMap(result.first);
    }
    return null;
  }

  Future<List<FoodSpot>> getFavorites() async {
    final db = await instance.database;
    final result = await db.query(
      'food_spots',
      where: 'favorite = ?',
      whereArgs: [1],
    );
    return result.map((map) => FoodSpot.fromMap(map)).toList();
  }

  Future<int> updateFoodSpot(FoodSpot foodSpot) async {
    final db = await instance.database;
    return await db.update(
      'food_spots',
      foodSpot.toMap(),
      where: 'id = ?',
      whereArgs: [foodSpot.id],
    );
  }

  Future<int> toggleFavorite(int id, bool isFavorite) async {
    final db = await instance.database;
    return await db.update(
      'food_spots',
      {'favorite': isFavorite ? 1 : 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteFoodSpot(int id) async {
    final db = await instance.database;
    return await db.delete(
      'food_spots',
      where: 'id = ?',
      whereArgs: [id],
    );
  }



  //REVIEW OPERATIONS
  Future<int> insertReview(Review review) async {
    final db = await instance.database;
    return await db.insert('reviews', review.toMap());
  }

  Future<List<Review>> getAllReviews() async {
    final db = await instance.database;
    final result = await db.query('reviews');
    return result.map((map) => Review.fromMap(map)).toList();
  }

  Future<List<Review>> getReviewsForFoodSpot(int foodId) async {
    final db = await instance.database;
    final result = await db.query(
      'reviews',
      where: 'foodId = ?',
      whereArgs: [foodId],
    );
    return result.map((map) => Review.fromMap(map)).toList();
  }

  Future<Review?> getReviewById(int id) async {
    final db = await instance.database;
    final result = await db.query(
      'reviews',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (result.isNotEmpty) {
      return Review.fromMap(result.first);
    }
    return null;
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}