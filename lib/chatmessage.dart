import 'package:flutter/material.dart';

class ChatMessage extends StatelessWidget {
  const ChatMessage(
      {super.key,
      required this.text,
      required this.sender,
      this.isImage = false});

  final String text;
  final String sender;
  final bool isImage;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment:
          sender == 'assistant' ? MainAxisAlignment.start : MainAxisAlignment.end,
      children:  [
        if (sender == "assistant") 
        const CircleAvatar(radius: 32,
        backgroundImage: AssetImage('assets/assistant.png'),), 
        const SizedBox(width: 10), 
        BubleChat(sender: sender, text: text),
        if (sender == "assistant") ...[
          const SizedBox(width: 64.0),
        ],
      ],
    );
  }
}

class BubleChat extends StatelessWidget {
  const BubleChat({
    super.key,
    required this.sender,
    required this.text,
  });

  final String sender;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Padding(
        padding : const EdgeInsets.symmetric(vertical: 5), 
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: sender == "assistant"
                ? const Color.fromRGBO(233, 233, 233, 1)
                : const Color.fromRGBO(208, 236, 232, 1),
            borderRadius: sender == "assistant" ? 
            const BorderRadius.only(topLeft: Radius.circular(27),topRight: Radius.circular(27), bottomLeft: Radius.circular(0), bottomRight:Radius.circular(27) )
            : const BorderRadius.only(topLeft: Radius.circular(27),topRight: Radius.circular(27), bottomLeft: Radius.circular(27), bottomRight:Radius.circular(0) ),
          ),
          child: Text(
            text,
            style: TextStyle(
              fontSize: 16.0,
              color: sender == "assistant" ?const Color.fromARGB(156, 0, 0, 0) :   const Color.fromRGBO(0, 118, 101, 100) 
            ),
          ),
        ),
      ),
    );
  }
}

class speakerName extends StatelessWidget {
  const speakerName({
    super.key,
    required this.sender,
  });

  final String sender;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: sender == "Me" ? const Color(0x00000000) : const Color(0x00000064) ,
      child: Text(sender)
    );
  }
}
