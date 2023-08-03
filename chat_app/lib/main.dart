import 'package:chat_app/firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'app/main_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // FirebaseFirestore.instance.collection("chat").doc().set({
  //   "text": "How are you?",
  //   "from": "Enrico",
  //   "read": false,
  // });

  // QuerySnapshot snapshot =
  //     await FirebaseFirestore.instance.collection("chat").get();
  // snapshot.docs; // todos os documentos da collection são acessíveis aqui dentro
  // snapshot.docs.forEach(
  //   (doc) {
  //     print(doc
  //         .data()); // quando acessamos o .data de um doc de um snapshot.docs, estamos acessando os dados de dentro do doc
  //   },
  // );

  // DocumentSnapshot snapshot = await FirebaseFirestore.instance
  //     .collection("chat")
  //     .doc("pZwc1dSG3jHMIXu0YfXE")
  //     .get();
  // print(snapshot.data());

// // pegar o ID do document:
//   QuerySnapshot snapshot =
//       await FirebaseFirestore.instance.collection("chat").get();

//   snapshot.docs.forEach(
//     (doc) {
//       print(doc.id);
//     },
//   );

// pegando reference e atualizando o doc:
//   QuerySnapshot snapshot =
//       await FirebaseFirestore.instance.collection("chat").get();

//   snapshot.docs.forEach(
//     (doc) {
//       doc.reference.update({"read": true});
//     },
//   );

// Lendo todas as coleções quando um document for alterado:
  // FirebaseFirestore.instance
  //     .collection("chat")
  //     .snapshots()
  //     .listen((dataSnapShots) {
  //   dataSnapShots.docs.forEach((doc) {
  //     print(doc.data());
  //   });
  // });

// Obtendo atualizações de um document específico
//   FirebaseFirestore.instance
//       .collection("chat")
//       .doc("pZwc1dSG3jHMIXu0YfXE")
//       .snapshots()
//       .listen(
//     (docSnapshot) {
//       print(docSnapshot.data());
//     },
//   );

  runApp(const MainApp());
}
