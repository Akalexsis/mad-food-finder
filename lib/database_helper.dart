import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/food_model.dart';
import '../models/review_model.dart';
import '../models/meal_model.dart';
import '../data/food_data.dart'; // seed data

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

    return await openDatabase(
      path,
      version: 2,
      onCreate: _createDB,
      onUpgrade: _onUpgrade,
    );
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS meals(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT NOT NULL,
          cost REAL NOT NULL,
          desc TEXT NOT NULL,
          date TEXT NOT NULL
        )
      ''');

      await db.execute('''
        CREATE TABLE IF NOT EXISTS budget(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          monthly_budget REAL NOT NULL,
          updated_at TEXT NOT NULL
        )
      ''');
    }
  }

  Future _createDB(Database db, int version) async {
    // FOOD SPOT table
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

    // MEAL table
    await db.execute('''
      CREATE TABLE meals(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        cost REAL NOT NULL,
        desc TEXT NOT NULL,
        date TEXT NOT NULL
      )
    ''');

    // BUDGET table
    await db.execute('''
      CREATE TABLE budget(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        monthly_budget REAL NOT NULL,
        updated_at TEXT NOT NULL
      )
    ''');

    // Seed food spots from food_data.dart
    for (final spot in sampleSpots) {
      await db.insert('food_spots', spot.toMap());
    }
  }

  // FOOD SPOT OPERATIONS
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

  // REVIEW OPERATIONS
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

  // MEAL LOG OPERATIONS
  Future<int> insertMeal(MealModel meal) async {
    final db = await instance.database;
    return await db.insert('meals', meal.toMap());
  }

  Future<int> updateMeal(MealModel meal) async {
    final db = await instance.database;
    return await db.update(
      'meals',
      meal.toMap(),
      where: 'id = ?',
      whereArgs: [meal.id],
    );
  }

  Future<int> deleteMeal(int id) async {
    final db = await instance.database;
    return await db.delete(
      'meals',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<MealModel>> getAllMeals() async {
    final db = await instance.database;
    final result = await db.query('meals');
    final all = result.map((map) => MealModel.fromMap(map)).toList();
    all.sort((a, b) {
      final da = _parseDateString(a.date);
      final db2 = _parseDateString(b.date);
      if (da == null || db2 == null) return 0;
      return db2.compareTo(da);
    });
    return all;
  }

  Future<List<MealModel>> getMealsThisMonth() async {
    final db = await instance.database;
    final result = await db.query('meals');
    final all = result.map((map) => MealModel.fromMap(map)).toList();

    final now = DateTime.now();
    final filtered = all.where((meal) {
      final parsed = _parseDateString(meal.date);
      if (parsed == null) return false;
      return parsed.month == now.month && parsed.year == now.year;
    }).toList();

    filtered.sort((a, b) {
      final da = _parseDateString(a.date);
      final db2 = _parseDateString(b.date);
      if (da == null || db2 == null) return 0;
      return db2.compareTo(da);
    });

    return filtered;
  }

  Future<List<MealModel>> getMealsThisWeek() async {
    final db = await instance.database;
    final result = await db.query('meals');
    final all = result.map((map) => MealModel.fromMap(map)).toList();

    final now = DateTime.now();
    final sevenDaysAgo = now.subtract(const Duration(days: 7));

    final filtered = all.where((meal) {
      final parsed = _parseDateString(meal.date);
      if (parsed == null) return false;
      return parsed.isAfter(sevenDaysAgo) &&
          parsed.isBefore(now.add(const Duration(days: 1)));
    }).toList();

    filtered.sort((a, b) {
      final da = _parseDateString(a.date);
      final db2 = _parseDateString(b.date);
      if (da == null || db2 == null) return 0;
      return db2.compareTo(da);
    });

    return filtered;
  }

  Future<double> getMonthlySpending() async {
    final meals = await getMealsThisMonth();
    return meals.fold<double>(0.0, (sum, meal) => sum + meal.cost);
  }

  DateTime? _parseDateString(String date) {
    try {
      const months = {
        'Jan': 1, 'Feb': 2, 'Mar': 3, 'Apr': 4,
        'May': 5, 'Jun': 6, 'Jul': 7, 'Aug': 8,
        'Sep': 9, 'Oct': 10, 'Nov': 11, 'Dec': 12
      };
      final parts = date.replaceAll(',', '').split(' ');
      final month = months[parts[0]];
      final day = int.parse(parts[1]);
      final year = int.parse(parts[2]);
      if (month == null) return null;
      return DateTime(year, month, day);
    } catch (e) {
      return null;
    }
  }

  // BUDGET OPERATIONS
  Future<int> setMonthlyBudget(double budget) async {
    final db = await instance.database;
    final now = DateTime.now().toIso8601String();

    final existing = await db.query('budget', limit: 1);

    if (existing.isEmpty) {
      return await db.insert('budget', {
        'monthly_budget': budget,
        'updated_at': now,
      });
    } else {
      return await db.update(
        'budget',
        {'monthly_budget': budget, 'updated_at': now},
        where: 'id = ?',
        whereArgs: [existing.first['id']],
      );
    }
  }

  Future<double?> getMonthlyBudget() async {
    final db = await instance.database;
    final result = await db.query('budget', limit: 1);
    if (result.isEmpty) return null;
    return (result.first['monthly_budget'] as num?)?.toDouble();
  }

  Future<double> getRemainingBudget() async {
    final budget = await getMonthlyBudget();
    if (budget == null) return 0.0;
    final spent = await getMonthlySpending();
    return budget - spent;
  }

  Future<Map<String, double>> getBudgetSummary() async {
    final budget = await getMonthlyBudget() ?? 0.0;
    final spent = await getMonthlySpending();
    final remaining = budget - spent;
    final percentage = budget > 0 ? (spent / budget) * 100 : 0.0;

    return {
      'budget': budget,
      'spent': spent,
      'remaining': remaining,
      'percentage': percentage,
    };
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}