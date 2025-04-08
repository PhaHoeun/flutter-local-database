import 'package:flutter/material.dart';
import 'package:local_database/model/carts_model/product_model.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key, this.products});
  final List<ProductModel>? products;

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Product Screen')),
      body:
          widget.products == null || widget.products!.isEmpty
              ? Center(child: Text('No Cart'))
              : SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    ...widget.products!.map((e) {
                      return ListTile(
                        title: Text('Title: ${e.title}'),
                        subtitle: Text(e.total.toString()),
                        leading: CircleAvatar(child: Text(e.id.toString())),
                      );
                    }),
                  ],
                ),
              ),
    );
  }
}
