import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
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
    // _startPolling();
    super.initState();
  }

  // // In your ProductListScreen state class
  // Timer? _pollingTimer;
  // void _startPolling() {
  //   _pollingTimer = Timer.periodic(Duration(seconds: 3), (timer) {
  //     setState(() {
  //       debugPrint('get data here--------------------------');
  //     });
  //   });
  // }

  // @override
  // void dispose() {
  //   _pollingTimer?.cancel();
  //   super.dispose();
  // }

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
                          title: Text('User ID: ${e.userId}'),
                          subtitle: Row(
                            children: [
                              Text(
                                NumberFormat.currency(
                                  locale: "en_US",
                                  symbol: "\$",
                                ).format(e.total).toString(),
                                style: TextStyle(
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                              Gap(15),
                              Text(
                                NumberFormat.currency(
                                  locale: "en_US",
                                  symbol: "\$",
                                ).format(e.discountedTotal).toString(),
                              ),
                            ],
                          ),
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
