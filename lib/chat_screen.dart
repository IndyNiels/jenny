import 'dart:math';

import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';

import 'chatmessage.dart';
import 'threedots.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<ChatMessage> messages = [];
  final List<String> chatMessages = [];

  // a function to add {user: $role, content : $content} to the chatMessages list

  bool _isTyping = false;

  final List<Map<String, dynamic>> requestMessages = [
    {
      "role": "system",
      "content": """Act as a Cognitive Behavioural Therapist. 
            Help me reassess my cognitive distortions and suggest some coping strategies. 
            Ask me questions so that I arrive at my own answers. But be short and to the point."""
    },
  ];

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

  void insertAssistantMessage(String response, {bool isImage = false}) {
    ChatMessage assistanttMessage = ChatMessage(
      text: response,
      sender: "assistant",
      isImage: isImage,
    );

    setState(() {
      _isTyping = false;
      messages.insert(0, assistanttMessage);
      requestMessages.add({'role': 'assistant', 'content': response});
    });
  }

  void _sendMessage() async {
    if (_controller.text.isEmpty) return;
    ChatMessage userMessage = ChatMessage(
      text: _controller.text,
      sender: "User",
      isImage: false,
    );

    final messageToPush = Map.of({'role': 'user', 'content': _controller.text});

    setState(() {
      //Adding message to paint
      messages.insert(0, userMessage);
      _isTyping = true;
      //Addint message for request
      requestMessages.add(messageToPush);
    });

    print('requestmesages is $requestMessages');

    final request = ChatCompleteText(
        messages: requestMessages,
        maxToken: 400,
        model: Gpt4ChatModel(),
        user: 'indy');

    //clenaing the controller text.
    _controller.clear();

    print('The request is ->$request');

    final response = await chat.onChatCompletion(request: request);

    for (var element in response!.choices) {
      insertAssistantMessage(element.message?.content ?? "");
    }
  }

  Widget buildTextComposer() {
    return Row(
      children: [
        const SizedBox(
          width: 20,
        ),
        Expanded(
          child: TextField(
            keyboardType: TextInputType.multiline,
            maxLines: null,
            controller: _controller,
            onSubmitted: (value) => _sendMessage(),
            decoration: const InputDecoration.collapsed(
                hintText: "What's on your mind?"),
          ),
        ),
        ButtonBar(
          children: [
            IconButton(
              icon: const Icon(Icons.send_rounded),
              onPressed: () {
                _sendMessage();
              },
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
          appBar: AppBar(
              title: const Text('Coach GPT'),
              shape: const Border(
                  bottom: BorderSide(color: Colors.black, width: 1.0)),
              actions: [
                Title(color: Colors.blue, child: const Text('My Profile')),
                IconButton(
                  icon: const Icon(Icons.person),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute<ProfileScreen>(
                          builder: (context) => ProfileScreen(
                            appBar:
                                // Go back to chat screen
                                AppBar(
                              title: const Text('My Profile'),
                              actions: const [],
                            ),
                          ),
                        ));
                  },
                ),
              ]),
          body: SafeArea(
            child: Column(
              children: [
                Flexible(
                    child: ListView.builder(
                  reverse: true,
                  padding: const EdgeInsets.all(8.0),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    return messages[index];
                  },
                )),
                if (_isTyping) const ThreeDots(),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Container(
                    width: screenWidth * 0.95,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(28),
                      color: const Color.fromRGBO(246, 246, 246, 1),
                    ),
                    child: buildTextComposer(),
                  ),
                )
              ],
            ),
          )),
    );
  }
}
