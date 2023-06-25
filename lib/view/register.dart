import 'package:aplikasiklinik/controller/auth_controller.dart';
import 'package:aplikasiklinik/model/users_model.dart';
import 'package:aplikasiklinik/themes/custom_colors.dart';
import 'package:aplikasiklinik/themes/material_colors.dart';
import 'package:aplikasiklinik/utils/constants.dart';
import 'package:aplikasiklinik/view/login.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  const Register({Key? key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final formkey = GlobalKey<FormState>();
  final authCtr = AuthController(isEdit: false);
  String? nama;
  String? email;
  String? password;
  String? role = 'pasien';

  bool _showPassword = true;

  void togglePasswordVisibility() {
    setState(() {
      _showPassword = !_showPassword;
    });
  }

  showAlertDialogLoading(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: Row(
        children: [
          const CircularProgressIndicator(),
          Container(
            margin: const EdgeInsets.only(left: 15),
            child: const Text(
              "Loading...",
              style: TextStyle(fontSize: 12),
            ),
          ),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  signUpDialog() {
    return showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.check_circle,
                color: colorPinkText,
                size: 72,
              ),
              SizedBox(
                height: 16,
              ),
              Center(child: Text('Register Berhasil')),
            ],
          ),
          actions: [
            Center(
              child: TextButton(
                onPressed: () =>
                    Navigator.popAndPushNamed(context, '/loginPages'),
                child: const Text(
                  'OK',
                  style: TextStyle(color: colorPinkText),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: colorPrimary,
      body: SizedBox(
        width: size.width,
        height: size.height,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                buildHeader(),
                buildIcon(),
                buildFormRegister(),
                buildButtonRegister(),
                buildFooter(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const Row(
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: 16),
                child: Text(
                  titleRegister,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Image.asset(
                "assets/image/line.png",
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildIcon() {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      child: Image.asset("assets/image/double_doctor.png"),
    );
  }

  Widget buildFormRegister() {
    return Form(
      key: formkey,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 8, bottom: 16),
              padding: const EdgeInsets.only(left: 4, bottom: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
              ),
              child: TextFormField(
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.only(top: 16),
                  prefixIcon: Icon(
                    Icons.account_circle_rounded,
                  ),
                  border: InputBorder.none,
                  hintText: 'Nama',
                ),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama tidak boleh kosong';
                  }
                  return null;
                },
                onChanged: (value) {
                  nama = value;
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 8, bottom: 16),
              padding: const EdgeInsets.only(left: 4, bottom: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
              ),
              child: TextFormField(
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.only(top: 16),
                  prefixIcon: Icon(Icons.email),
                  border: InputBorder.none,
                  hintText: 'Email',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email tidak boleh kosong';
                  }
                  return null;
                },
                onChanged: (value) {
                  email = value;
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 8, bottom: 16),
              padding: const EdgeInsets.only(left: 4, bottom: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
              ),
              child: TextFormField(
                obscureText: _showPassword,
                textInputAction: TextInputAction.done,
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.only(top: 16),
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: GestureDetector(
                    onTap: togglePasswordVisibility,
                    child: _showPassword
                        ? Icon(
                            Icons.visibility_off,
                            color: colorPrimary,
                          )
                        : Icon(
                            Icons.visibility,
                            color: colorPrimary,
                          ),
                  ),
                  border: InputBorder.none,
                  hintText: 'Password',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password tidak boleh kosong';
                  }
                  return null;
                },
                onChanged: (value) {
                  password = value;
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildButtonRegister() {
    return Container(
      margin: const EdgeInsets.only(top: 24),
      child: ElevatedButton(
        onPressed: () async {
          if (formkey.currentState!.validate()) {
            showAlertDialogLoading(context);
            UsersModel? registeredUser =
                await authCtr.registerWithEmailAndPassword(
              email!,
              password!,
              nama!,
              role = 'pasien',
            );
            Navigator.pop(context); // Close the loading dialog
            if (registeredUser != null) {
              signUpDialog();
              // Navigator.pushReplacement(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => const Login(),
              //   ),
              // );
            } else {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text('Register Gagal'),
                  content: const Text('Email sudah terdaftar.'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('OK'),
                    ),
                  ],
                ),
              );
            }
          }
        },
        child: Container(
          width: 120,
          height: 40,
          child: Center(
            child: Text(
              "Register",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(colorButton),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildFooter() {
    return Container(
      //margin: const EdgeInsets.only(top: 24),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          const Padding(
            padding: EdgeInsets.only(right: 4),
            child: Text(
              textLogin,
              style: TextStyle(color: Colors.white),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.push(
                context, MaterialPageRoute(builder: (_) => const Login())),
            child: const Text(
              titleLogin,
              style: TextStyle(color: colorButton),
            ),
          )
        ],
      ),
    );
  }
}






















//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: [Colors.purple.shade100, Colors.pink.shade300],
//           ),
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(20.0),
//           child: Form(
//             key: formkey,
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 const Text(
//                   'Register',
//                   style: TextStyle(
//                     fontSize: 30,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(
//                   height: 80,
//                 ),
//                 TextFormField(
//                   decoration: InputDecoration(
//                     hintText: 'Nama',
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     filled: true,
//                     fillColor: Colors.purple.shade50,
//                     prefixIcon: const Icon(
//                       Icons.person,
//                       color: Colors.pink,
//                     ),
//                   ),
//                   onChanged: (value) {
//                     nama = value;
//                   },
//                   validator: (value) {
//                     if (value!.isEmpty) {
//                       return 'Please enter your name';
//                     }
//                     return null;
//                   },
//                 ),
//                 const SizedBox(
//                   height: 10,
//                 ),
//                 TextFormField(
//                   decoration: InputDecoration(
//                     hintText: 'Role',
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     filled: true,
//                     fillColor: Colors.purple.shade50,
//                     prefixIcon: const Icon(
//                       Icons.person,
//                       color: Colors.pink,
//                     ),
//                   ),
//                   onChanged: (value) {
//                     role = value;
//                   },
//                   validator: (value) {
//                     if (value!.isEmpty) {
//                       return 'Please enter your role';
//                     }
//                     return null;
//                   },
//                 ),
//                 const SizedBox(
//                   height: 10,
//                 ),
//                 TextFormField(
//                   decoration: InputDecoration(
//                     hintText: 'Email',
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     filled: true,
//                     fillColor: Colors.purple.shade50,
//                     prefixIcon: const Icon(
//                       Icons.email,
//                       color: Colors.pink,
//                     ),
//                   ),
//                   onChanged: (value) {
//                     email = value;
//                   },
//                   validator: (value) {
//                     if (value!.isEmpty) {
//                       return 'Please enter your email';
//                     } else if (!value.contains('@')) {
//                       return 'Please enter a valid email address';
//                     }
//                     return null;
//                   },
//                 ),
//                 const SizedBox(
//                   height: 10,
//                 ),
//                 TextFormField(
//                   obscureText: _isObsure,
//                   decoration: InputDecoration(
//                     hintText: 'Password',
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     filled: true,
//                     fillColor: Colors.purple.shade50,
//                     prefixIcon: const Icon(
//                       Icons.lock,
//                       color: Colors.pink,
//                     ),
//                     suffixIcon: IconButton(
//                       onPressed: () {
//                         setState(
//                           () {
//                             _isObsure = !_isObsure;
//                           },
//                         );
//                       },
//                       icon: Icon(
//                           _isObsure ? Icons.visibility_off : Icons.visibility),
//                     ),
//                   ),
//                   onChanged: (value) {
//                     password = value;
//                   },
//                   validator: (value) {
//                     if (value!.isEmpty) {
//                       return 'Please enter your password';
//                     } else if (value.length < 6) {
//                       return 'Password must be at least 6 characters';
//                     }
//                     return null;
//                   },
//                 ),
//                 const SizedBox(
//                   height: 20,
//                 ),
//                 ElevatedButton(
//                   child: const Text('Register'),
//                   onPressed: () async {
//                     if (formkey.currentState!.validate()) {
//                       UsersModel? registeredUser =
//                           await authCtr.registerWithEmailAndPassword(
//                         email!,
//                         password!,
//                         nama!,
//                         role!,
//                       );
//                       if (registeredUser != null) {
//                         // Registration successful
//                         // ignore: use_build_context_synchronously
//                         showDialog(
//                           context: context,
//                           builder: (BuildContext context) {
//                             return AlertDialog(
//                               title: const Text('Registration Successful!'),
//                               content: const Text(
//                                   'You have been successfully registered.'),
//                               actions: <Widget>[
//                                 TextButton(
//                                   onPressed: () {
//                                     Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                         builder: (context) {
//                                           return const Login();
//                                         },
//                                       ),
//                                     );
//                                     //print(registeredUser.name);
//                                     // Navigate to the next screen or perform any desired action
//                                     ScaffoldMessenger.of(context).showSnackBar(
//                                       SnackBar(
//                                         content: Text(
//                                           'Welcome ${registeredUser.nama}!',
//                                         ),
//                                         backgroundColor: Colors.pink,
//                                         duration: const Duration(seconds: 1),
//                                       ),
//                                     );
//                                   },
//                                   child: const Text('OK'),
//                                 ),
//                               ],
//                             );
//                           },
//                         );
//                       } else {
//                         // Registration failed
//                         // ignore: use_build_context_synchronously
//                         showDialog(
//                           context: context,
//                           builder: (BuildContext context) {
//                             return AlertDialog(
//                               title: const Text('Registration Failed'),
//                               content: const Text(
//                                   'An error occurred during registration.'),
//                               actions: <Widget>[
//                                 TextButton(
//                                   onPressed: () {
//                                     Navigator.pop(context);
//                                   },
//                                   child: const Text('OK'),
//                                 ),
//                               ],
//                             );
//                           },
//                         );
//                       }
//                     }
//                   },
//                 ),
//                 const SizedBox(
//                   height: 10,
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(20),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       const Text(
//                         "Already have an account? ",
//                         style: TextStyle(
//                           color: Colors.black,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       InkWell(
//                         child: const Text(
//                           "Login",
//                           style: TextStyle(
//                             color: Colors.pink,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         onTap: () {
//                           Navigator.of(context).push(
//                             MaterialPageRoute(
//                               builder: (_) => const Login(),
//                             ),
//                           );
//                         },
//                       )
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }