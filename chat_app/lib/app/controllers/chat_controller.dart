import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatController {
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final GlobalKey<ScaffoldMessengerState> scaffoldKey;

  ChatController({required this.scaffoldKey});

  Future<User?> getUser({User? user}) async {
    // verificando se está logado
    if (user != null) return user;

    // Se for null, vamos fazer o login:

    try {
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();

      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount!
              .authentication; // tem um idToken e um token de acesso, necessários para a conexão com o Firebase

      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken,
      );

      final UserCredential authResult =
          await FirebaseAuth.instance.signInWithCredential(credential);

      final User? user = authResult
          .user; // através desse user, conseguimos validar o acesso dele em cada uma das partes do banco de dados

      return user;
    } catch (e) {
      print(e);
      return null; // aí se o usuário atual for null, vai para o login
    }
  }

  void sendMessage({
    String? text,
    File? imgFile,
  }) async {
    final User? user = await getUser();

    if (user == null) {
      scaffoldKey.currentState!.showSnackBar(
        const SnackBar(
          content: Text("Não foi possível fazer o login. Tente novamente!"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    Map<String, dynamic> messageData = {
      "uid": user.uid,
      "senderName": user.displayName,
      "senderPhotoUrl": user.photoURL,
    };

    const Uuid uuid = Uuid();
    if (imgFile != null) {
      UploadTask task =
          FirebaseStorage.instance.ref().child(uuid.v1()).putFile(imgFile);

      TaskSnapshot taskSnapshot =
          await task; // traz várias infos da task que foi concluída acima, uma delas é a url de download da img enviada, que é gerada quando foi para o FirebaseStorage

      final String imgUrl = await taskSnapshot.ref.getDownloadURL();

      messageData['imgUrl'] = imgUrl;
    }

    if (text != null) messageData["text"] = text;

    FirebaseFirestore.instance
        .collection("messages")
        .doc(uuid.v1())
        .set(messageData);
  }
}


/*
    Map<String, dynamic> dataMap = {};

    if (imgFile != null) {
      const uuid = Uuid();

      final UploadTask task = FirebaseStorage.instance
          .ref()
          .child(uuid.v1())
          .putFile(imgFile); // armazenando o arquivo no FirebaseStorage

      TaskSnapshot taskSnapshot =
          await task; // acessando o Snapshot da task com várias infos da mesma após ela ser concluída.
      String url = await taskSnapshot.ref
          .getDownloadURL(); // acessando a url de donwload da imagem contida no snapshot da task concluída.

      dataMap['imgUrl'] = url;
    }

    if (text != null) {
      dataMap['text'] = text;
    }

    FirebaseFirestore.instance.collection("messages").add(dataMap);
*/