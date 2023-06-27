import 'package:aplikasiklinik/model/users_model.dart';
import 'package:aplikasiklinik/themes/custom_colors.dart';
import 'package:aplikasiklinik/utils/constants.dart';
import 'package:aplikasiklinik/view/admin/home_pages_a.dart';
import 'package:aplikasiklinik/view/pasien/home_pages.dart';
import 'package:aplikasiklinik/view/role_pages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthController {
  String? uid;
  String? nama;
  String? email;
  String? role;
  String? nomorHp;
  String? jekel;
  String? tglLahir;
  String? alamat;
  final bool isEdit;
  AuthController(
      {Key? key,
      this.uid,
      this.nama,
      this.email,
      this.role,
      this.nomorHp,
      this.jekel,
      this.tglLahir,
      this.alamat,
      required this.isEdit})
      : super();

  final formkey = GlobalKey<FormState>();
  // String? email;
  String? password;

  final FirebaseAuth auth = FirebaseAuth.instance;
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  bool get succes => false;

  Future<UsersModel?> registerWithEmailAndPassword(
      String email, String password, String nama, String role) async {
    try {
      final UserCredential userCredential =
          await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final User? user = userCredential.user;

      if (user != null) {
        final UsersModel currentUser = UsersModel(
          uId: user.uid,
          nama: nama,
          email: user.email ?? '',
          role: role,
          alamat: '',
          jekel: '',
          nomorhp: '',
          tglLahir: '',
          noAntrian: 0,
          poli: '',
        );

        await userCollection.doc(user.uid).set(currentUser.toMap());

        return currentUser;
      }
    } catch (e) {
      print('Error signin in: $e');
    }
    return null;
  }

  void showAlertUserNotFound(BuildContext context) {
    AlertDialog alert = AlertDialog(
      title: const Text(titleError),
      content: const Text("Maaf, User Tidak Ditemukan!"),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(
            "OK",
            style: TextStyle(color: colorPinkText),
          ),
        ),
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

  void showAlertUserWrongPassword(BuildContext context) {
    AlertDialog alert = AlertDialog(
      title: const Text(titleError),
      content: const Text("Maaf, Password Salah!"),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(
            "OK",
            style: TextStyle(color: colorPinkText),
          ),
        ),
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

  void showAlertDialogLoading(BuildContext context) {
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

  // Fungsi login
  Future<UsersModel?> login(
      String email, String password, BuildContext context) async {
    showAlertDialogLoading(context);
    try {
      final UserCredential userCredential =
          await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final User? user = userCredential.user;

      // ignore: use_build_context_synchronously
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const RolesPages()),
        (route) => false,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        showAlertUserNotFound(context);
      } else if (e.code == 'wrong-password') {
        showAlertUserWrongPassword(context);
      }
    }
  }

  Future<UsersModel?> getUser() async {
    final User? user = auth.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .where('uId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get()
          .then((result) {
        if (result.docs.isNotEmpty) {
          final UsersModel currentUser = UsersModel(
            uId: user.uid,
            nama: result.docs[0].data()['nama'],
            email: user.email ?? '',
            role: result.docs[0].data()['role'],
            nomorhp: result.docs[0].data()['nomorhp'],
            jekel: result.docs[0].data()['jekel'],
            tglLahir: result.docs[0].data()['tglLahir'],
            alamat: result.docs[0].data()['alamat'],
            noAntrian: result.docs[0].data()['noAntrian'],
            poli: result.docs[0].data()['poli'],
          );
        }
      });
    }
  }

  Future<UsersModel?> updateData(
      String nama,
      String email,
      String nomorHp,
      String jekel,
      String tglLahir,
      String alamat,
      BuildContext context) async {
    if (isEdit) {
      DocumentReference documentReference = FirebaseFirestore.instance
          .collection('users')
          .doc(auth.currentUser!.uid);

      FirebaseFirestore.instance.runTransaction((transaction) async {
        DocumentSnapshot snapshot = await transaction.get(documentReference);

        if (snapshot.exists) {
          await transaction.update(documentReference, {
            'nama': nama,
            'email': email,
            'nomorhp': nomorHp,
            'jekel': jekel,
            'tglLahir': tglLahir,
            'alamat': alamat,
          });
        }
      });

      infoUpdate(context);
    }
  }

  void infoUpdate(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text(titleSuccess),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Data Pribadi Anda Berhasil di Perbarui",
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HomePages()),
              ),
              child: const Text(
                "OK",
                style: TextStyle(color: colorPinkText),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<UsersModel?> updateDataadmin(
      String nama,
      String email,
      String nomorHp,
      String jekel,
      String tglLahir,
      String alamat,
      BuildContext context) async {
    if (isEdit) {
      DocumentReference documentReference = FirebaseFirestore.instance
          .collection('users')
          .doc(auth.currentUser!.uid);

      FirebaseFirestore.instance.runTransaction((transaction) async {
        DocumentSnapshot snapshot = await transaction.get(documentReference);

        if (snapshot.exists) {
          await transaction.update(documentReference, {
            'nama': nama,
            'email': email,
            'nomorhp': nomorHp,
            'jekel': jekel,
            'tglLahir': tglLahir,
            'alamat': alamat,
          });
        }
      });

      infoUpdateadmin(context);
    }
  }

  void infoUpdateadmin(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text(titleSuccess),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Data Pribadi Anda Berhasil di Perbarui",
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HomePagesAdmin()),
              ),
              child: const Text(
                "OK",
                style: TextStyle(color: colorPinkText),
              ),
            ),
          ],
        );
      },
    );
  }
}
