import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:local_database/controller/carts_controller.dart';
import 'package:local_database/page/products_screen.dart';

class CartsScreen extends StatefulWidget {
  const CartsScreen({super.key});

  @override
  State<CartsScreen> createState() => _CartsScreenState();
}

class _CartsScreenState extends State<CartsScreen> {
  @override
  void initState() {
    con.getAllCarts();
    super.initState();
  }

  var con = Get.put(CartsController());
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text('Carts'),
          actions: [
            IconButton(
              onPressed: () {
                con.onGetCartsFromAPI().then((_) {
                  con.apiCartsList.map((e) {
                    con.insertCart(e);
                  }).toList();
                  con.getAllCarts();
                });
              },
              icon: Icon(Icons.sync),
            ),
          ],
        ),
        body:
            con.carts.isEmpty 
                ? Center(child: Text('No Cart'))
                : SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      ...con.carts.map((e) {
                        return ListTile(
                          title: Text(e.total.toString()),
                          subtitle: Text('User ID: ${e.userId}'),
                          leading: CircleAvatar(child: Text(e.id.toString())),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) =>
                                        ProductScreen(products: e.products),
                              ),
                            );
                          },
                        );
                      }),
                    ],
                  ),
                ),
      ),
    );
  }
}
