import 'package:aplikasiklinik/model/users_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthController {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  bool get succes => false;

  Future<UsersModel?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      final UserCredential userCredential = await auth
          .signInWithEmailAndPassword(email: email, password: password);
      final User? user = userCredential.user;

      if (user != null) {
        final DocumentSnapshot snapshot =
            await userCollection.doc(user.uid).get();

        final UsersModel currentUser = UsersModel(
          uId: user.uid,
          nama: snapshot['name'] ?? '',
          email: user.email ?? '',
          role: snapshot['role'] ?? '',
          nomorhp: snapshot['nomorhp'] ?? '',
          jekel: snapshot['jekel'] ?? '',
          tglLahir: snapshot['tglLahir'] ?? '',
          alamat: snapshot['alamat'] ?? '',
        );

        return currentUser;
      }
    } catch (e) {
      //print('Error signIn user: $e');
    }

    return null;
  }

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
        );

        await userCollection.doc(user.uid).set(currentUser.toMap());

        return currentUser;
      }
    } catch (e) {
      print('Error signin in: $e');
    }
    return null;
  }

  UsersModel? getCurrentUser() {
    final User? user = auth.currentUser;
    if (user != null) {
      return UsersModel.fromFirebase(user);
    }
    return null;
  }

  Future<void> signOut() async {
    await auth.signOut();
  }
}
