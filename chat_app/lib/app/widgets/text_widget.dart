import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class TextWidget extends StatefulWidget {
  const TextWidget({super.key, required this.sendMessage});

  final Function({String? text, File? imgFile}) sendMessage;

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
            onPressed: () async {
              final ImagePicker picker = ImagePicker();

              final XFile? imgXFile =
                  await picker.pickImage(source: ImageSource.camera);
              if (imgXFile == null) return;

              final File imgFile = File(imgXFile.path);

              widget.sendMessage(imgFile: imgFile);
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
                    widget.sendMessage(text: _msgController.text);
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
