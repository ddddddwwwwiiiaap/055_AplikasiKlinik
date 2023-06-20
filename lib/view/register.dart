import 'package:aplikasiklinik/controller/auth_controller.dart';
import 'package:aplikasiklinik/model/users_model.dart';
import 'package:aplikasiklinik/view/login.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final formkey = GlobalKey<FormState>();
  final authCtr = AuthController();
  bool _isObsure = true;
  String? nama, email, password, role;

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
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: formkey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Register',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 80,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Nama',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    fillColor: Colors.purple.shade50,
                    prefixIcon: const Icon(
                      Icons.person,
                      color: Colors.pink,
                    ),
                  ),
                  onChanged: (value) {
                    nama = value;
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Role',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    fillColor: Colors.purple.shade50,
                    prefixIcon: const Icon(
                      Icons.person,
                      color: Colors.pink,
                    ),
                  ),
                  onChanged: (value) {
                    role = value;
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your role';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    fillColor: Colors.purple.shade50,
                    prefixIcon: const Icon(
                      Icons.email,
                      color: Colors.pink,
                    ),
                  ),
                  onChanged: (value) {
                    email = value;
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your email';
                    } else if (!value.contains('@')) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  obscureText: _isObsure,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    fillColor: Colors.purple.shade50,
                    prefixIcon: const Icon(
                      Icons.lock,
                      color: Colors.pink,
                    ),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(
                          () {
                            _isObsure = !_isObsure;
                          },
                        );
                      },
                      icon: Icon(
                          _isObsure ? Icons.visibility_off : Icons.visibility),
                    ),
                  ),
                  onChanged: (value) {
                    password = value;
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your password';
                    } else if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  child: const Text('Register'),
                  onPressed: () async {
                    if (formkey.currentState!.validate()) {
                      UsersModel? registeredUser =
                          await authCtr.registerWithEmailAndPassword(
                        email!,
                        password!,
                        nama!,
                        role!,
                      );
                      if (registeredUser != null) {
                        // Registration successful
                        // ignore: use_build_context_synchronously
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Registration Successful!'),
                              content: const Text(
                                  'You have been successfully registered.'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return const Login();
                                        },
                                      ),
                                    );
                                    //print(registeredUser.name);
                                    // Navigate to the next screen or perform any desired action
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Welcome ${registeredUser.nama}!',
                                        ),
                                        backgroundColor: Colors.pink,
                                        duration: const Duration(seconds: 1),
                                      ),
                                    );
                                  },
                                  child: const Text('OK'),
                                ),
                              ],
                            );
                          },
                        );
                      } else {
                        // Registration failed
                        // ignore: use_build_context_synchronously
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Registration Failed'),
                              content: const Text(
                                  'An error occurred during registration.'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text('OK'),
                                ),
                              ],
                            );
                          },
                        );
                      }
                    }
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Already have an account? ",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      InkWell(
                        child: const Text(
                          "Login",
                          style: TextStyle(
                            color: Colors.pink,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const Login(),
                            ),
                          );
                        },
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
