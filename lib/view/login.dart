import 'package:aplikasiklinik/controller/auth_controller.dart';
import 'package:aplikasiklinik/model/users_model.dart';
import 'package:aplikasiklinik/themes/custom_colors.dart';
import 'package:aplikasiklinik/themes/material_colors.dart';
import 'package:aplikasiklinik/utils/constants.dart';
import 'package:aplikasiklinik/view/home_pages.dart';
import 'package:aplikasiklinik/view/register.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final formkey = GlobalKey<FormState>();
  final authCtr = AuthController();
  String? email;
  String? password;

  late bool _showPassword = true;

  void togglePasswordVisibility() {
    setState(() {
      _showPassword = !_showPassword;
    });
  }

  showAlertUserNotFound() {
    AlertDialog alert = AlertDialog(
      title: const Text(titleError),
      content: const Text("Maaf, User Tidak Ditemukan!"),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              "OK",
              style: TextStyle(color: colorPinkText),
            ))
      ],
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showAlertUserWrongPassword() {
    AlertDialog alert = AlertDialog(
      title: const Text(titleError),
      content: const Text("Maaf, Password Salah!"),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              "OK",
              style: TextStyle(color: colorPinkText),
            ))
      ],
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
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
              )),
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

  displaySnackBar(text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
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
                buildFormLogin(),
                buildButtonLogin(),
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
                  titleLogin,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Image.asset("assets/image/line.png"),
            ],
          )
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

  Widget buildFormLogin() {
    return Form(
      key: formkey,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 24),
              padding: const EdgeInsets.only(left: 4, bottom: 4),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12), color: Colors.white),
              child: TextFormField(
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.only(top: 16),
                  prefixIcon: Icon(Icons.email),
                  border: InputBorder.none,
                  hintText: textEmail,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
                onChanged: (value) {
                  email = value;
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 40),
              padding: const EdgeInsets.only(left: 4, bottom: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
              ),
              child: TextFormField(
                obscureText: _showPassword,
                textInputAction: TextInputAction.done,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
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
                    return 'Please enter your password';
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

  Widget buildButtonLogin() {
    return ElevatedButton(
      onPressed: () async {
        if (formkey.currentState!.validate()) {
          UsersModel? loginUser = await authCtr.signInWithEmailAndPassword(
            email!,
            password!,
          );
          if (loginUser != null) {
            // Login successful
            // ignore: use_build_context_synchronously
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Login Successful!'),
                  content: const Text('You have been successfully logged in.'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return const HomePages();
                            },
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
            // Login unsuccessful
            // ignore: use_build_context_synchronously
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Login Unsuccessful!'),
                  content: const Text(
                      'Please check your email and password and try again.'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
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
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(colorButton),
        shape: MaterialStateProperty.all(RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        )),
      ),
      child: Container(
        width: 120,
        height: 40,
        child: const Center(
          child: Text(
            titleLogin,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 16,
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
              textDaftarRegister,
              style: TextStyle(color: Colors.white),
            ),
          ),
          TextButton(
              onPressed: () => Navigator.push(
                  context, MaterialPageRoute(builder: (_) => const Register())),
              child: const Text(
                titleRegister,
                style: TextStyle(color: colorButton),
              ))
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
//         child: SafeArea(
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 20),
//             child: Form(
//               key: formkey,
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   const Text(
//                     'Login',
//                     style: TextStyle(
//                       fontSize: 35,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const SizedBox(
//                     height: 80,
//                   ),
//                   TextFormField(
//                     decoration: InputDecoration(
//                       hintText: 'Email',
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       filled: true,
//                       fillColor: Colors.purple.shade50,
//                       prefixIcon: const Icon(
//                         Icons.email,
//                         color: Colors.pink,
//                       ),
//                     ),
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Please enter your email';
//                       } else if (!value.contains('@')) {
//                         return 'Please enter a valid email address';
//                       }
//                       return null;
//                     },
//                     onChanged: (value) {
//                       email = value;
//                     },
//                   ),
//                   const SizedBox(
//                     height: 10,
//                   ),
//                   TextFormField(
//                     obscureText: _isObsure,
//                     decoration: InputDecoration(
//                       hintText: 'Password',
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       filled: true,
//                       fillColor: Colors.purple.shade50,
//                       prefixIcon: const Icon(
//                         Icons.lock,
//                         color: Colors.pink,
//                       ),
//                       suffixIcon: IconButton(
//                         onPressed: () {
//                           setState(() {
//                             _isObsure = !_isObsure;
//                           });
//                         },
//                         icon: Icon(_isObsure
//                             ? Icons.visibility_off
//                             : Icons.visibility),
//                       ),
//                       //border: OutlineInputBorder(),
//                     ),
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Please enter your password';
//                       }
//                       return null;
//                     },
//                     onChanged: (value) {
//                       password = value;
//                     },
//                   ),
//                   const SizedBox(
//                     height: 20,
//                   ),
//                   ElevatedButton(
//                     child: const Text('Login'),
//                     onPressed: () async {
//                       if (formkey.currentState!.validate()) {
//                         UsersModel? loginUser =
//                             await authCtr.signInWithEmailAndPassword(
//                           email!,
//                           password!,
//                         );
//                         if (loginUser != null) {
//                           // Login successful
//                           // ignore: use_build_context_synchronously
//                           showDialog(
//                             context: context,
//                             builder: (BuildContext context) {
//                               return AlertDialog(
//                                 title: const Text('Login Successful!'),
//                                 content: const Text(
//                                     'You have been successfully logged in.'),
//                                 actions: <Widget>[
//                                   TextButton(
//                                     onPressed: () {
//                                       Navigator.push(
//                                         context,
//                                         MaterialPageRoute(
//                                           builder: (context) {
//                                             return const HomePages();
//                                           },
//                                         ),
//                                       );
//                                       //print(registeredUser.name);
//                                       // Navigate to the next screen or perform any desired action
//                                       ScaffoldMessenger.of(context)
//                                           .showSnackBar(
//                                         SnackBar(
//                                           content: Text(
//                                             'Welcome ${loginUser.nama}!',
//                                           ),
//                                           backgroundColor: Colors.pink,
//                                           duration: const Duration(seconds: 1),
//                                         ),
//                                       );
//                                     },
//                                     child: const Text('OK'),
//                                   ),
//                                 ],
//                               );
//                             },
//                           );
//                         } else {
//                           // Login failed
//                           // ignore: use_build_context_synchronously
//                           showDialog(
//                             context: context,
//                             builder: (BuildContext context) {
//                               return AlertDialog(
//                                 title: const Text('Login Failed'),
//                                 content: const Text(
//                                     'An error occurred during logged in.'),
//                                 actions: <Widget>[
//                                   TextButton(
//                                     onPressed: () {
//                                       Navigator.pop(context);
//                                     },
//                                     child: const Text('OK'),
//                                   ),
//                                 ],
//                               );
//                             },
//                           );
//                         }
//                       }
//                     },
//                   ),
//                   const SizedBox(
//                     height: 10,
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.all(20),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         const Text(
//                           "Don't have an account? ",
//                           style: TextStyle(
//                             color: Colors.black,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         InkWell(
//                           child: const Text(
//                             "Register",
//                             style: TextStyle(
//                               color: Colors.pink,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           onTap: () {
//                             Navigator.of(context).push(
//                               MaterialPageRoute(
//                                 builder: (_) => const Register(),
//                               ),
//                             );
//                           },
//                         )
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }