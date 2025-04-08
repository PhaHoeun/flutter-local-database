import 'package:get/get.dart';
import 'package:local_database/model/dog_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class HomeController extends GetxController {
  var id = 0.obs;
  var name = ''.obs;
  var age = 0.obs;
  var dogsList = <DogModel>[].obs;
  var ascID = true.obs;
  var ascAge = false.obs;

  //  --------------------------------------------------------------
  //  TASK: this function is used to open database
  //  Responsible By: Hoeun Pha
  //  --------------------------------------------------------------
  Future<Database> myDogDB() async {
    final database = openDatabase(
      join(await getDatabasesPath(), 'my_database.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE dogs(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, age INTEGER)',
        );
      },
      version: 1,
    );
    return database;
  }

  //  --------------------------------------------------------------
  //  TASK: this function is used to insert dog into database
  //  Responsible By: Hoeun Pha
  //  --------------------------------------------------------------

  Future<void> insertDog(DogModel dog) async {
    // Get a reference to the database.
    final db = await myDogDB();
    await db
        .insert(
          'dogs',
          dog.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        )
        .then((_) {
          getDogs();
        });
  }

  //  --------------------------------------------------------------
  //  TASK: This function is used to get all dogs from database
  //  Responsible By: Hoeun Pha
  //  --------------------------------------------------------------

  Future<List<DogModel>> getDogs() async {
    // Get a reference to the database.
    dogsList.value = [];
    final db = await myDogDB();

    // Query the table for all the dogs.
    final List<Map<String, Object?>> dogMaps = await db.query('dogs');

    // Convert the list of each dog's fields into a list of `Dog` objects.

    return dogsList.value = [
      for (final {'id': id as int, 'name': name as String, 'age': age as int}
          in dogMaps)
        DogModel(id: id, name: name, age: age),
    ];
  }

  //  --------------------------------------------------------------
  //  TASK: This function is used to search dog by name from database
  //  Responsible By: Hoeun Pha
  //  --------------------------------------------------------------

  Future<List<DogModel>> searchDog(String name) async {
    // Get a reference to the database.
    dogsList.value = [];
    final db = await myDogDB();

    // Query the table for all the dogs.
    final List<Map<String, Object?>> dogMaps = await db.query(
      'dogs',
      where: 'name LIKE ?',
      whereArgs: ['%$name%'],
      // orderBy: 'age ASC',
    );

    // Convert the list of each dog's fields into a list of `Dog` objects.

    return dogsList.value = [
      for (final {'id': id as int, 'name': name as String, 'age': age as int}
          in dogMaps)
        DogModel(id: id, name: name, age: age),
    ];
  }

  //  --------------------------------------------------------------
  //  TASK: This function is used to filter dog by id from database
  //  Responsible By: Hoeun Pha
  //  --------------------------------------------------------------

  Future<List<DogModel>> filterID(bool asc) async {
    // Get a reference to the database.
    dogsList.value = [];
    final db = await myDogDB();

    // Query the table for all the dogs.
    final List<Map<String, Object?>> dogMaps = await db.query(
      'dogs',
      orderBy: 'id ${asc ? 'ASC' : 'DESC'}',
    );
    return dogsList.value = [
      for (final {'id': id as int, 'name': name as String, 'age': age as int}
          in dogMaps)
        DogModel(id: id, name: name, age: age),
    ];
  }

  //  --------------------------------------------------------------
  //  TASK: This function is used to filter dog by id from database
  //  Responsible By: Hoeun Pha
  //  --------------------------------------------------------------

  Future<List<DogModel>> filterAge(bool asc) async {
    // Get a reference to the database.
    dogsList.value = [];
    final db = await myDogDB();

    // Query the table for all the dogs.
    final List<Map<String, Object?>> dogMaps = await db.query(
      'dogs',
      orderBy: 'age ${asc ? 'ASC' : 'DESC'}',
    );

    // Convert the list of each dog's fields into a list of `Dog` objects.

    return dogsList.value = [
      for (final {'id': id as int, 'name': name as String, 'age': age as int}
          in dogMaps)
        DogModel(id: id, name: name, age: age),
    ];
  }

  //  --------------------------------------------------------------
  //  TASK: This function is used to update dog by id from database
  //  Responsible By: Hoeun Pha
  //  --------------------------------------------------------------

  Future<void> updateDog(DogModel dog) async {
    // Get a reference to the database.

    final db = await myDogDB();

    // Update the given Dog.
    await db
        .update(
          'dogs',
          dog.toMap(),
          // Ensure that the Dog has a matching id.
          where: 'id = ?',
          // Pass the Dog's id as a whereArg to prevent SQL injection.
          whereArgs: [dog.id],
        )
        .then((_) {
          getDogs();
        });
  }

  //  --------------------------------------------------------------
  //  TASK: This function is used to delete dog by id from database
  //  Responsible By: Hoeun Pha
  //  --------------------------------------------------------------

  Future<void> deleteDog(int id) async {
    // Get a reference to the database.
    final db = await myDogDB();

    // Remove the Dog from the database.
    await db
        .delete(
          'dogs',
          // Use a `where` clause to delete a specific dog.
          where: 'id = ?',
          // Pass the Dog's id as a whereArg to prevent SQL injection.
          whereArgs: [id],
        )
        .then((_) {
          getDogs();
        });
  }
}
