import 'dart:io';

import 'package:chat_app/app/widgets/text_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _HomePageState();
}

class _HomePageState extends State<ChatPage> {
  void _sendMessage({String? text, File? imgFile}) async {
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chat - Nome do user"),
        // elevation: 0,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.exit_to_app),
          ),
        ],
      ),
      body: TextWidget(
        sendMessage: _sendMessage,
      ),
    );
  }
}
