import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:local_database/model/carts_model/cart_model.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../model/carts_model/product_model.dart';

class CartsController extends GetxController {
  //  --------------------------------------------------------------
  //  TASK: this function is used to get cart from api
  //  Responsible By: Hoeun Pha
  //  --------------------------------------------------------------

  var apiCartsList = <CartModel>[].obs;
  Future<List<CartModel>> onGetCartsFromAPI() async {
    apiCartsList.value = [];
    http.Response response = await http.get(
      Uri.parse('https://dummyjson.com/carts'),
    );
    if (response.statusCode == 200) {
      var res = jsonDecode(response.body)['carts'] as List;
      res.map((e) {
        apiCartsList.add(CartModel.fromJson(e));
      }).toList();
      debugPrint('API Carts List: ${apiCartsList.length}');
      return apiCartsList;
    } else {
      throw Exception('Failed to load carts: ${response.statusCode}');
    }
  }

  //  --------------------------------------------------------------
  //  TASK: this function is used to open database
  //  Responsible By: Hoeun Pha
  //  --------------------------------------------------------------
  Future<Database> cartsDB() async {
    final database = openDatabase(
      join(await getDatabasesPath(), 'carts_database.db'),
      onCreate: (db, version) async {
        await db.execute('''
      CREATE TABLE carts (
        id INTEGER PRIMARY KEY,
        total REAL,
        discountedTotal REAL,
        userId INTEGER,
        totalProducts INTEGER,
        totalQuantity INTEGER
      )
    ''');

        await db.execute('''
      CREATE TABLE products (
        id INTEGER,
        title TEXT,
        price REAL,
        quantity INTEGER,
        total REAL,
        discountPercentage REAL,
        discountedTotal REAL,
        thumbnail TEXT,
        cartId INTEGER,
        FOREIGN KEY (cartId) REFERENCES carts (id)
      )
    ''');
      },
      version: 1,
    );
    return database;
  }

  Future<void> insertCart(CartModel cart) async {
    final db = await cartsDB();

    await db.insert(
      'carts',
      cart.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    for (var product in cart.products ?? []) {
      await db.insert(
        'products',
        product.toMap(cart.id!),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  var carts = <CartModel>[].obs;
  Future<List<CartModel>> getAllCarts() async {
    final db = await cartsDB();
    final cartMaps = await db.query('carts');
    carts.value = [];
    for (var cartMap in cartMaps) {
      final productsMap = await db.query(
        'products',
        where: 'cartId = ?',
        whereArgs: [cartMap['id']],
      );

      List<ProductModel> products =
          productsMap.map((p) => ProductModel.fromJson(p)).toList();

      carts.add(
        CartModel(
          id: cartMap['id'] as int,
          products: products,
          total: cartMap['total'] as double,
          discountedTotal: cartMap['discountedTotal'] as double,
          userId: cartMap['userId'] as int,
          totalProducts: cartMap['totalProducts'] as int,
          totalQuantity: cartMap['totalQuantity'] as int,
        ),
      );
    }

    return carts;
  }
}
