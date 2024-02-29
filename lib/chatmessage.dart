import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

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
          sender == 'Alice' ? MainAxisAlignment.start : MainAxisAlignment.end,
      children: [
        BubleChat(sender: sender, text: text),
        if (sender == "Alice") ...[
          const SizedBox(width: 64.0),
        ],
      ],
    ).py8();
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
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: sender == "Alice"
              ? const Color.fromRGBO(254, 221, 216, 1)
              : const Color.fromARGB(255, 234, 231, 226),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 16.0,
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
      color: sender == "Me" ? Vx.red200 : Vx.green200,
      child: Text(sender)
          .text
          .make()
          .box
          .color(sender == "Me" ? Vx.red200 : Vx.green200)
          .p16
          .rounded
          .alignCenter
          .makeCentered(),
    );
  }
}
