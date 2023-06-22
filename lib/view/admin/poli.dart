import 'package:aplikasiklinik/view/admin/add_poli.dart';
import 'package:aplikasiklinik/view/admin/update_poli.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:aplikasiklinik/model/poli_model.dart';
import 'package:aplikasiklinik/controller/poli_controller.dart';
import 'package:flutter/material.dart';

class Poli extends StatefulWidget {
  const Poli({super.key});

  @override
  State<Poli> createState() => _PoliState();
}

class _PoliState extends State<Poli> {
  var pc = PoliController();

  @override
  void initState() {
    // TODO: implement initState
    pc.getPoli();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.purple.shade100, Colors.pink.shade300],
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                color: Colors.pink,
                height: 50,
                width: double.infinity,
                //buat teks ditengah dan gambar di kanan
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Image.network(
                      'https://assets.pokemon.com/assets/cms2/img/pokedex/full/087.png',
                      height: 100,
                      width: 100,
                    ),
                    const Text(
                      'Contact List',
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    Image.network(
                      'https://assets.pokemon.com/assets/cms2/img/pokedex/full/087.png',
                      height: 100,
                      width: 100,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: StreamBuilder<List<DocumentSnapshot>>(
                  stream: pc.stream,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    final List<DocumentSnapshot> data = snapshot.data!;
                    return ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: InkWell(
                            onLongPress: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => UpdatePoli(
                                    poliModel: PoliModel.fromMap(
                                        data[index].data()
                                            as Map<String, dynamic>),
                                    contact: data[index],
                                  ),
                                ),
                              );
                            },
                            child: Card(
                              elevation: 10,
                              shadowColor: Colors.cyan,
                              child: ListTile(
                                leading: CircleAvatar(
                                    backgroundColor: Colors.pink,
                                    child: Text(
                                        data[index]['namaPoli']
                                            .substring(0, 1)
                                            .toUpperCase(),
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold))),
                                title: Text(data[index]['namaPoli']),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete),
                                  color: Colors.red,
                                  onPressed: () {
                                    //buat dialog delete data
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: const Text('Delete Data!'),
                                          content: const Text(
                                              'Are you sure want to delete this data?'),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: const Text('Cancel'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                pc.poliCollection
                                                    .doc(data[index].id)
                                                    .delete();
                                                pc.getPoli();
                                                Navigator.pop(context);
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  const SnackBar(
                                                    content: Text(
                                                        'Data has been deleted'),
                                                    duration:
                                                        Duration(seconds: 1),
                                                    backgroundColor: Colors.red,
                                                  ),
                                                );
                                              },
                                              child: const Text('Delete'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddPoli(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
