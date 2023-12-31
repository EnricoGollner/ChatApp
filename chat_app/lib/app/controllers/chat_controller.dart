import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatController extends ChangeNotifier {
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerStateKey;

  ChatController({required this.scaffoldMessengerStateKey, this.currentUser});

  User? currentUser;
  // Se for null, vamos fazer o login:
  GoogleSignInAccount? googleSignInAccount;

  final ValueNotifier<bool> isLoadingImage = ValueNotifier<bool>(false);

  void controlIsLoadingImage(bool value) {
    isLoadingImage.value = value;
    notifyListeners();
  }

  bool verifySender(String uidSenderToVerify) {
    if (currentUser?.uid == uidSenderToVerify) {
      return true;
    }

    return false;
  }

  void showSnackBar({required String message, required Color color}) {
    scaffoldMessengerStateKey.currentState?.showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
      ),
    );
  }

  Future<User?> getUser() async {
    // verificando se está logado
    if (currentUser != null) return currentUser;

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

      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      // através desse user, conseguimos validar o acesso dele em cada uma das partes do banco de dados
      final User? user = userCredential.user;
      return user;
    } catch (e) {
      return null; // aí se o usuário atual for null, vai para o login
    }
  }

  void sendMessage({String? text, File? imgFile}) async {
    final User? user = await getUser();

    if (user == null) {
      scaffoldMessengerStateKey.currentState?.showSnackBar(
        const SnackBar(
          content: Text(
            "Erro",
            style: TextStyle(backgroundColor: Colors.red),
          ),
        ),
      );
      return;
    }

    Map<String, dynamic> messageData = {
      "uid": user.uid,
      "senderName": user.displayName,
      "senderPhotoUrl": user.photoURL,
      "time": Timestamp.now(), // do firebase
    };

    const Uuid uuid = Uuid();
    if (imgFile != null) {
      UploadTask task =
          FirebaseStorage.instance.ref().child(uuid.v1()).putFile(imgFile);

      controlIsLoadingImage(true);

      TaskSnapshot taskSnapshot =
          await task; // traz várias infos da task que foi concluída acima, uma delas é a url de download da img enviada, que é gerada quando foi para o FirebaseStorage

      final String imgUrl = await taskSnapshot.ref.getDownloadURL();

      messageData['imgUrl'] = imgUrl;
      controlIsLoadingImage(false);
    }

    if (text != null) messageData["text"] = text;

    FirebaseFirestore.instance
        .collection("messages")
        .doc(uuid.v1())
        .set(messageData);
  }
}
