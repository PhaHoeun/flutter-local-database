import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:local_database/controller/home_controller.dart';
import 'package:local_database/page/album_screen.dart';
import 'package:local_database/page/carts_screen.dart';

import '../main.dart';
import '../model/dog_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    con.getDogs();
    super.initState();
  }

  var con = Get.put(HomeController());
  var nameController = TextEditingController();
  var ageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text('My Dogs'),
          actions: [
            PopupMenuButton<dynamic>(
              icon: Icon(Icons.more_vert),
              itemBuilder:
                  (BuildContext context) => <PopupMenuEntry<dynamic>>[
                    PopupMenuItem(
                      child: Text('Album'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AlbumScreen(),
                          ),
                        );
                      },
                    ),
                    PopupMenuItem(
                      child: Text('Carts'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CartsScreen(),
                          ),
                        );
                      },
                    ),
                  ],
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              Column(
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: 'My Dog\'s Name',
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
                      con.name.value = value;
                    },
                  ),
                  Gap(20),
                  TextFormField(
                    controller: ageController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Age',
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
                      if (value != '') {
                        con.age.value = int.parse(value);
                      }
                    },
                  ),
                  Gap(20),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            if (con.name.value != '' && con.age.value != 0) {
                              await con
                                  .insertDog(
                                    DogModel(
                                      name: con.name.value,
                                      age: con.age.value,
                                    ),
                                  )
                                  .then((_) {
                                    nameController.clear();
                                    ageController.clear();
                                    // ignore: use_build_context_synchronously
                                    unFocus(context);
                                  });
                            }
                          },
                          child: Text('Add'),
                        ),
                      ),
                    ],
                  ),
                  Gap(20),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Search dog...',
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
                      con.searchDog(value);
                    },
                  ),
                  Gap(10),
                ],
              ),
              Gap(15),
              Expanded(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              con.ascID.value = !con.ascID.value;

                              con.filterID(con.ascID.value);
                            },
                            child: Row(
                              children: [
                                Text(
                                  'ID',
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                                Icon(
                                  con.ascID.value
                                      ? Icons.arrow_upward
                                      : Icons.arrow_downward,
                                  size: 12,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            'Dog\'s Name',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              con.ascAge.value = !con.ascAge.value;
                              con.filterAge(con.ascAge.value);
                            },
                            child: Row(
                              children: [
                                Text(
                                  'Age',
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                                Icon(
                                  con.ascAge.value
                                      ? Icons.arrow_upward
                                      : Icons.arrow_downward,
                                  size: 12,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(child: Container()),
                      ],
                    ),
                    Divider(),

                    if (con.dogsList.isEmpty) Text('No Data'),
                    ...con.dogsList.map((e) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                e.id.toString(),
                                style: Theme.of(context).textTheme.labelMedium,
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text(
                                e.name,
                                style: Theme.of(context).textTheme.labelMedium,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                e.age.toString(),
                                style: Theme.of(context).textTheme.labelMedium,
                              ),
                            ),
                            Expanded(
                              child: Row(
                                children: [
                                  GestureDetector(
                                    onTap: () async {
                                      con.name.value = e.name;
                                      con.age.value = e.age;
                                      showDialog<String>(
                                        context: context,
                                        builder:
                                            (
                                              BuildContext context,
                                            ) => AlertDialog(
                                              title: const Text('Update Dog'),
                                              content: SizedBox(
                                                height: 175,
                                                child: Column(
                                                  children: [
                                                    Gap(20),

                                                    TextFormField(
                                                      initialValue:
                                                          con.name.value,
                                                      decoration: InputDecoration(
                                                        labelText:
                                                            'My Dog\'s Name',
                                                        enabledBorder:
                                                            OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                    10,
                                                                  ),
                                                              borderSide:
                                                                  BorderSide(
                                                                    color:
                                                                        Colors
                                                                            .black,
                                                                  ),
                                                            ),
                                                        focusedBorder:
                                                            OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                    10,
                                                                  ),
                                                              borderSide:
                                                                  BorderSide(
                                                                    color:
                                                                        Colors
                                                                            .blue,
                                                                  ),
                                                            ),
                                                      ),
                                                      onChanged: (value) {
                                                        con.name.value = value;
                                                      },
                                                    ),
                                                    Gap(20),
                                                    TextFormField(
                                                      initialValue:
                                                          con.age.value
                                                              .toString(),
                                                      keyboardType:
                                                          TextInputType.number,
                                                      decoration: InputDecoration(
                                                        labelText: 'Age',
                                                        enabledBorder:
                                                            OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                    10,
                                                                  ),
                                                              borderSide:
                                                                  BorderSide(
                                                                    color:
                                                                        Colors
                                                                            .black,
                                                                  ),
                                                            ),
                                                        focusedBorder:
                                                            OutlineInputBorder(
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                    10,
                                                                  ),
                                                              borderSide:
                                                                  BorderSide(
                                                                    color:
                                                                        Colors
                                                                            .blue,
                                                                  ),
                                                            ),
                                                      ),
                                                      onChanged: (value) {
                                                        if (value != '') {
                                                          con.age.value =
                                                              int.parse(value);
                                                        }
                                                      },
                                                    ),
                                                    Gap(20),
                                                  ],
                                                ),
                                              ),
                                              actions: <Widget>[
                                                TextButton(
                                                  onPressed:
                                                      () => Navigator.pop(
                                                        context,
                                                        'Cancel',
                                                      ),
                                                  child: const Text('Cancel'),
                                                ),
                                                TextButton(
                                                  onPressed: () async {
                                                    Navigator.pop(context);
                                                    await con
                                                        .updateDog(
                                                          DogModel(
                                                            id: e.id,
                                                            name:
                                                                con.name.value,
                                                            age: con.age.value,
                                                          ),
                                                        )
                                                        .then((_) {
                                                          con.name.value = '';
                                                          con.age.value = 0;
                                                        });
                                                  },
                                                  child: const Text('OK'),
                                                ),
                                              ],
                                            ),
                                      );

                                      AlertDialog();
                                    },
                                    child: Icon(Icons.edit, size: 16),
                                  ),
                                  Gap(16),
                                  GestureDetector(
                                    onTap: () async {
                                      await con.deleteDog(e.id!);
                                    },
                                    child: Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                      size: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
