import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:velocity_x/velocity_x.dart';

import 'chatmessage.dart';
import 'threedots.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<ChatMessage> _messages = [];

  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  final chat = OpenAI.instance.build(
      token: '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',
      baseOption: HttpSetup(receiveTimeout: const Duration(seconds: 15)),
      enableLog: true);

  void _sendMessage() async {
    if (_controller.text.isEmpty) return;
    ChatMessage userMessage = ChatMessage(
      text: _controller.text,
      sender: "Me",
      isImage: false,
    );

    setState(() {
      _messages.insert(0, userMessage);
      _isTyping = true;
    });

    final request = ChatCompleteText(messages: [
      {
        "role": "system",
        "content":
            """Act as a Cognitive Behavioural Therapist. Help me rephrase and reassess negative thoughts that I have. Ask me questions so that I arrive at my own answers."""
      },
      Map.of({"role": "user", "content": _controller.text})
    ], maxToken: 400, model: Gpt4ChatModel(), user: 'indy');

    _controller.clear();
    print('request -> $request');

    final response = await chat.onChatCompletion(request: request);

    for (var element in response!.choices) {
      print("data -> ${element.message?.content}");
      insertNewData(element.message?.content ?? "");
    }
  }

  void insertNewData(String response, {bool isImage = false}) {
    ChatMessage botMessage = ChatMessage(
      text: response,
      sender: "Alice",
      isImage: isImage,
    );

    setState(() {
      _isTyping = false;
      _messages.insert(0, botMessage);
    });
  }

  Widget buildTextComposer() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _controller,
            onSubmitted: (value) => _sendMessage(),
            decoration: const InputDecoration.collapsed(
                hintText: "Question/description"),
          ),
        ),
        ButtonBar(
          children: [
            IconButton(
              icon: const Icon(Icons.send),
              onPressed: () {
                _sendMessage();
              },
            ),
          ],
        ),
      ],
    ).px16();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Alice, CBT Agent")),
        body: SafeArea(
          child: Column(
            children: [
              Flexible(
                  child: ListView.builder(
                reverse: true,
                padding: Vx.m8,
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  return _messages[index];
                },
              )),
              if (_isTyping) const ThreeDots(),
              const Divider(
                height: 1.0,
              ),
              Container(
                decoration: BoxDecoration(
                  color: context.cardColor,
                ),
                child: buildTextComposer(),
              )
            ],
          ),
        ));
  }
}
