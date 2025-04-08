import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:http/http.dart' as http;

import '../model/album_model.dart';

class AlbumController extends GetxController {
  //  --------------------------------------------------------------
  //  TASK: this function is used to get album from api
  //  Responsible By: Hoeun Pha
  //  --------------------------------------------------------------

  var apiAlbumList = <AlbumModel>[].obs;
  Future<List<AlbumModel>> onGetAlbumList() async {
    apiAlbumList.value = [];
    http.Response response = await http.get(
      Uri.parse('https://jsonplaceholder.typicode.com/albums'),
    );
    if (response.statusCode == 200) {
      var res = jsonDecode(response.body) as List;
      res.map((e) {
        apiAlbumList.add(AlbumModel.fromJson(e));
      }).toList();
      debugPrint('API Album List: ${apiAlbumList.length}');
      return albumList;
    } else {
      throw Exception('Failed to load album');
    }
  }

  //  --------------------------------------------------------------
  //  TASK: this function is used to open database
  //  Responsible By: Hoeun Pha
  //  --------------------------------------------------------------
  Future<Database> albumDB() async {
    final database = openDatabase(
      join(await getDatabasesPath(), 'album_database.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE albums(id INTEGER PRIMARY KEY, userId INTEGER, title TEXT)',
        );
      },
      version: 1,
    );
    return database;
  }

  //  --------------------------------------------------------------
  //  TASK: this function is used to insert album into database
  //  Responsible By: Hoeun Pha
  //  --------------------------------------------------------------
  Future<void> insertAlbum(AlbumModel album) async {
    // Get a reference to the database.
    final db = await albumDB();
    await db.insert(
      'albums',
      album.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    // .then((_) {
    //   getAlbum();
    // });
  }

  //  --------------------------------------------------------------
  //  TASK: This function is used to get all dogs from database
  //  Responsible By: Hoeun Pha
  //  --------------------------------------------------------------
  var albumList = <AlbumModel>[].obs;
  Future<List<AlbumModel>> getAlbum() async {
    // Get a reference to the database.
    albumList.value = [];
    final db = await albumDB();

    // Query the table for all the dogs.
    final List<Map<String, Object?>> dogMaps = await db.query('albums');

    // Convert the list of each dog's fields into a list of `Album` objects.
    dogMaps.map((e) {
      albumList.add(AlbumModel.fromJson(e));
    }).toList();

    return albumList;
  }
  //  --------------------------------------------------------------
  //  TASK: This function is used to get all dogs from database
  //  Responsible By: Hoeun Pha
  //  --------------------------------------------------------------

  Future<List<AlbumModel>> getAlbumByTitle(String title) async {
    // Get a reference to the database.
    albumList.value = [];
    final db = await albumDB();

    // Query the table for all the dogs.
    final List<Map<String, Object?>> dogMaps = await db.query(
      'albums',
      where: 'title LIKE ?',
      whereArgs: ['%$title%'],
    );

    // Convert the list of each dog's fields into a list of `Album` objects.
    dogMaps.map((e) {
      albumList.add(AlbumModel.fromJson(e));
    }).toList();
    return albumList;
  }
}
