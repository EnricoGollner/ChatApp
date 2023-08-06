import 'package:flutter/material.dart';

class ChatMessage extends StatelessWidget {
  const ChatMessage(
      {super.key, required this.messageData, required this.isMine});

  final Map<String, dynamic> messageData;
  final bool isMine;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      child: Row(
        children: [
          !isMine
              ? Container(
                  padding: const EdgeInsets.only(right: 15),
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(
                      messageData["senderPhotoUrl"],
                    ),
                  ),
                )
              : Container(),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  isMine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                messageData["imgUrl"] != null
                    ? Image.network(
                        messageData["imgUrl"],
                        width: 200,
                      )
                    : Text(
                        messageData["text"],
                        textAlign: isMine ? TextAlign.end : TextAlign.right,
                        style: const TextStyle(fontSize: 17),
                      ),
                Text(
                  messageData["senderName"],
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                )
              ],
            ),
          ),
          isMine
              ? Container(
                  padding: const EdgeInsets.only(left: 15),
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(
                      messageData["senderPhotoUrl"],
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
