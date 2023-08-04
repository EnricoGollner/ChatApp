import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class ChatController {
  void sendMessage({String? text, File? imgFile}) async {
    Map<String, dynamic> messageData = {};
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