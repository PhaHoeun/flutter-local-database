import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/album_controller.dart';

class AlbumScreen extends StatefulWidget {
  const AlbumScreen({super.key});

  @override
  State<AlbumScreen> createState() => _AlbumScreenState();
}

class _AlbumScreenState extends State<AlbumScreen> {
  var con = Get.put(AlbumController());

  @override
  void initState() {
    con.getAlbum();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(120),
          child: AppBar(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: const Text('Album'),
            flexibleSpace: Padding(
              padding: const EdgeInsets.only(top: 75, left: 15, right: 15),
              child: TextFormField(
                keyboardType: TextInputType.numberWithOptions(),
                decoration: InputDecoration(
                  labelText: 'Search album by title',
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                ),
                onChanged: (value) {
                  con.getAlbumByTitle(value);
                },
              ),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  con.onGetAlbumList().then((_) {
                    con.apiAlbumList.map((e) {
                      con.insertAlbum(e);
                    }).toList();
                    con.getAlbum();
                  });
                },
                icon: Icon(Icons.sync),
              ),
            ],
          ),
        ),
        body:
            con.albumList.isEmpty
                ? Center(child: Text('No Album'))
                : SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      ...con.albumList.map((e) {
                        return ListTile(
                          title: Text(e.title.toString()),
                          subtitle: Text('User ID: ${e.userId}'),
                          leading: CircleAvatar(child: Text(e.id.toString())),
                        );
                      }),
                    ],
                  ),
                ),
      ),
    );
  }
}
