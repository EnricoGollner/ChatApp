import 'package:flutter/material.dart';

class TextWidget extends StatefulWidget {
  TextWidget({super.key, required this.sendMessage});

  Function(String) sendMessage;

  @override
  State<TextWidget> createState() => _TextWidgetState();
}

class _TextWidgetState extends State<TextWidget> {
  bool _isComposing = false;
  final _msgController = TextEditingController();

  void _resset() {
    _msgController.clear();
    setState(() {
      _isComposing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              // abrir câmera para foto
            },
            icon: const Icon(Icons.photo_camera),
          ),
          Expanded(
            child: TextField(
              controller: _msgController,
              decoration: const InputDecoration.collapsed(
                  hintText: "Enviar uma Mensagem"),
              onChanged: (text) {
                setState(() {
                  _isComposing = text.isNotEmpty;
                });
              },
            ),
          ),
          IconButton(
            onPressed: _isComposing
                ? () {
                    widget.sendMessage(_msgController.text);
                    _resset();
                  }
                : null,
            icon: const Icon(Icons.send),
          ),
        ],
      ),
    );
  }
}
