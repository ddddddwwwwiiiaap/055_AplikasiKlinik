import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileController {
  final StreamController<List<DocumentSnapshot>> streamController =
      StreamController<List<DocumentSnapshot>>.broadcast();

  Stream<List<DocumentSnapshot>> get stream => streamController.stream;
}
