import 'package:chat_app/app/controllers/chat_controller.dart';
import 'package:chat_app/app/widgets/text_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _HomePageState();
}

class _HomePageState extends State<ChatPage> {
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  User? _currentUser;

  @override
  void initState() {
    super.initState();

    FirebaseAuth.instance.authStateChanges().listen((user) {
      _currentUser = user;
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = ChatController(scaffoldKey: scaffoldMessengerKey);

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
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream:
                  FirebaseFirestore.instance.collection("messages").snapshots(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return const Center(
                      child: CircularProgressIndicator(),
                    );

                  default:
                    List<DocumentSnapshot> documents =
                        snapshot.data!.docs.reversed.toList();

                    return ListView.builder(
                      itemCount: documents.length,
                      reverse: true, // mais recente primeiro
                      itemBuilder: (context, index) {
                        final currentDoc =
                            documents[index].data() as Map<String, dynamic>;
                        final currentText = currentDoc["text"];

                        return ListTile(
                          title: Text(currentText),
                        );
                      },
                    );
                }
              },
            ),
          ),
          TextWidget(
            sendMessage: controller.sendMessage,
          ),
        ],
      ),
    );
  }
}
