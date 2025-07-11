import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/user_model.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  static Database? _db;

  Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'app.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE users(
            id TEXT PRIMARY KEY,
            email TEXT UNIQUE,
            name TEXT,
            password TEXT,
            photoUrl TEXT,
            phoneNumber TEXT,
            address TEXT,
            latitude REAL,
            longitude REAL,
            rating INTEGER,
            totalShares INTEGER,
            totalReceives INTEGER,
            createdAt TEXT,
            isVerified INTEGER
          )
        ''');
      },
    );
  }

  Future<int> registerUser(UserModel user) async {
    final dbClient = await db;
    try {
      return await dbClient.insert('users', {
        ...user.toMap(),
        'createdAt': user.createdAt.toIso8601String(),
        'isVerified': user.isVerified ? 1 : 0,
      });
    } catch (e) {
      // Nếu email đã tồn tại sẽ throw
      return -1;
    }
  }

  Future<UserModel?> loginUser(String email, String password) async {
    final dbClient = await db;
    final res = await dbClient.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );
    if (res.isNotEmpty) {
      final map = res.first;
      return UserModel(
        id: map['id'] as String,
        email: map['email'] as String,
        name: map['name'] as String,
        password: map['password'] as String,
        photoUrl: map['photoUrl'] as String?,
        phoneNumber: map['phoneNumber'] as String?,
        address: map['address'] as String?,
        latitude: map['latitude'] != null ? (map['latitude'] as num).toDouble() : null,
        longitude: map['longitude'] != null ? (map['longitude'] as num).toDouble() : null,
        rating: map['rating'] != null ? (map['rating'] as num).toInt() : 0,
        totalShares: map['totalShares'] != null ? (map['totalShares'] as num).toInt() : 0,
        totalReceives: map['totalReceives'] != null ? (map['totalReceives'] as num).toInt() : 0,
        createdAt: DateTime.parse(map['createdAt'] as String),
        isVerified: map['isVerified'] == 1,
      );
    }
    return null;
  }
} 