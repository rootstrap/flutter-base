import 'package:firebase_vertexai/firebase_vertexai.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:uuid/uuid.dart';

class GeminiChatPage extends StatefulWidget {
  const GeminiChatPage({super.key});

  @override
  State<GeminiChatPage> createState() => _GeminiChatState();
}

class _GeminiChatState extends State<GeminiChatPage> {
  bool _loading = false;
  List<types.Message> _messages = [];
  var model;
  final _agent = const types.User(id: "testidAgent", firstName: "Chatty");
  final _user = const types.User(id: "testidUser", firstName: "");

  @override
  void initState() {
    super.initState();

    model = FirebaseVertexAI.instance.generativeModel(
        model: 'gemini-1.5-pro',
        generationConfig:
            GenerationConfig(temperature: 0, responseMimeType: 'text/plain'));
  }

  void _addMessage(types.Message message) {
    setState(() {
      _messages.insert(0, message);
    });
  }

  void _handleSendPressed(types.PartialText text) {
    final textMessage = types.TextMessage(
      author: _user,
      text: text.text,
      id: const Uuid().v4(),
    );

    _addMessage(textMessage);

    _sendVertexMessage(text);
  }

  Future<void> _sendVertexMessage(types.PartialText meesageToSend) async {
    _loading = true;

    final messageContent = Content.multi(
      [
        TextPart(meesageToSend.text),
      ],
    );

    var response = await model.generateContent([messageContent]);
    var text = response.text;

    print("RESPONSE FROM API");
    print(text);

    if (text != null) {
      final textMessage = types.TextMessage(
        author: _agent,
        text: text,
        id: const Uuid().v4(),
      );

      _addMessage(textMessage);
    }

    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Chat(
            showUserAvatars: true,
            showUserNames: true,
            typingIndicatorOptions:
                TypingIndicatorOptions(typingUsers: _loading ? [_agent] : []),
            messages: _messages,
            onSendPressed: _handleSendPressed,
            user: _user),
      );
}
