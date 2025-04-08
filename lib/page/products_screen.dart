import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
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
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Product Screen'),
      ),
      body:
          widget.products == null || widget.products!.isEmpty
              ? Center(child: Text('No Cart'))
              : SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    ...widget.products!.map((e) {
                      return ListTile(
                        title: Text('${e.title}'),
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
                        leading: CircleAvatar(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: CachedNetworkImage(
                              imageUrl: e.thumbnail.toString(),
                              imageBuilder:
                                  (context, imageProvider) => Container(
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.cover,
                                        colorFilter: ColorFilter.mode(
                                          Colors.transparent,
                                          BlendMode.colorBurn,
                                        ),
                                      ),
                                    ),
                                  ),
                              placeholder:
                                  (context, url) => CircularProgressIndicator(),
                              errorWidget:
                                  (context, url, error) => Icon(Icons.error),
                            ),
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
    );
  }
}
