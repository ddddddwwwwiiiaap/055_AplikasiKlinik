import 'package:aplikasiklinik/controller/poli_controller.dart';
import 'package:aplikasiklinik/model/poli_model.dart';
import 'package:aplikasiklinik/view/admin/poli.dart';
import 'package:flutter/material.dart';

class AddPoli extends StatefulWidget {
  const AddPoli({super.key});

  @override
  State<AddPoli> createState() => _AddPoliState();
}

class _AddPoliState extends State<AddPoli> {
  var poliController = PoliController();
  final formKey = GlobalKey<FormState>();
  String? namaPoli;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, // untuk menghindari bottom overflowed
      appBar: AppBar(
        title: const Text('Add Contact'),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.purple.shade100, Colors.pink.shade300],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Form(
              key: formKey,
              child: Column(
                //mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 10,
                    shadowColor: Colors.black,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          const CircleAvatar(
                            radius: 25,
                            child: Icon(
                              Icons.person,
                              size: 25,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Poli',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your name';
                              }
                              return null;
                            },
                            onChanged: (value) => namaPoli = value,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          ElevatedButton(
                            child: const Text('Add Contact'),
                            onPressed: () async {
                              if (formKey.currentState!.validate()) {
                                PoliModel cm = PoliModel(
                                  namaPoli: namaPoli!,
                                );
                                poliController.addPoli(cm).then((value) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const Poli(),
                                    ),
                                  );
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Contact Added'),
                                    duration: Duration(seconds: 1),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
