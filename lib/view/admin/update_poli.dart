import 'package:aplikasiklinik/controller/poli_controller.dart';
import 'package:aplikasiklinik/model/poli_model.dart';
import 'package:aplikasiklinik/view/admin/poli.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UpdatePoli extends StatefulWidget {
  PoliModel poliModel;
  UpdatePoli({
    Key? key,
    required DocumentSnapshot<Object?> contact,
    required this.poliModel,
  }) : super(key: key);

  @override
  State<UpdatePoli> createState() => _UpdatePoliState();
}

class _UpdatePoliState extends State<UpdatePoli> {
  var poliController = PoliController();
  final formKey = GlobalKey<FormState>();
  String? namaPoli;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Update Contact'),
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
                            controller: TextEditingController(
                              text: widget.poliModel.namaPoli,
                            ),
                            decoration: const InputDecoration(
                              labelText: 'Nama Poli',
                            ),
                            validator:(value) {
                              if (value!.isEmpty) {
                                return 'Please enter name';
                              }
                              return null;
                            },
                            onChanged: (value) => namaPoli = value,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          ElevatedButton(
                            child: const Text('Update Contact'),
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                PoliModel cm = PoliModel(
                                  uId: widget.poliModel.uId,
                                  namaPoli: namaPoli!,
                                );
                                poliController.updatePoli(cm);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Contact Updated'),
                                    duration: Duration(seconds: 1),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const Poli(),
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
