import 'package:chat_app/app/controllers/chat_controller.dart';
import 'package:chat_app/app/widgets/text_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

import '../widgets/chat_message_widget.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  User? currentUser;

  @override
  void initState() {
    super.initState();

    FirebaseAuth.instance.authStateChanges().listen((user) {
      setState(() {
        currentUser = user;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = ChatController(
        scaffoldMessengerStateKey: _scaffoldMessengerKey,
        currentUser: currentUser);
    return Scaffold(
      key: _scaffoldMessengerKey,
      appBar: AppBar(
        title: Text(controller.currentUser != null
            ? 'Chat de ${controller.currentUser!.displayName}'
            : 'Chat App'),
        elevation: 0,
        actions: [
          controller.currentUser != null
              ? IconButton(
                  onPressed: () {
                    FirebaseAuth.instance.signOut();
                    controller.googleSignIn.signOut();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(""),
                        backgroundColor: Colors.red,
                      ),
                    );
                  },
                  icon: const Icon(Icons.exit_to_app))
              : Container(),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("messages")
                    .orderBy('time')
                    .snapshots(),
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
                          final currentDocData =
                              documents[index].data() as Map<String, dynamic>;

                          return ChatMessage(
                            messageData: currentDocData,
                            isMine:
                                controller.verifySender(currentDocData["uid"]),
                          );
                        },
                      );
                  }
                },
              ),
            ),
            AnimatedBuilder(
              animation: controller.isLoadingImage,
              builder: (context, child) {
                if (controller.isLoadingImage.value == false) {
                  return Container();
                }

                return const LinearProgressIndicator();
              },
            ),
            TextWidget(
              sendMessage: controller.sendMessage,
            ),
          ],
        ),
      ),
    );
  }
}
