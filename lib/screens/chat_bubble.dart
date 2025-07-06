import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:horoscopeguruapp/api/api.dart';
import 'package:flutter/rendering.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:horoscopeguruapp/theme/colors.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class ChatBubble extends StatelessWidget {
  final ChatMessage message;
  final Color userBubbleColor;
  final Color aiBubbleColor;
  final Color textColor;

  const ChatBubble({
    required this.message,
    required this.userBubbleColor,
    required this.aiBubbleColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: message.role == ChatMessageRole.user
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          if (message.role == ChatMessageRole.assistant)
            CircleAvatar(
              radius: 28,
              backgroundColor: aiBubbleColor,
              backgroundImage: const AssetImage('assets/images/logo.png'),
            ),
          if (message.role == ChatMessageRole.assistant)
            const SizedBox(width: 8),
          Flexible(
            child: Column(
              crossAxisAlignment: message.role == ChatMessageRole.user
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: message.role == ChatMessageRole.user
                        ? userBubbleColor
                        : aiBubbleColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(
                          message.role == ChatMessageRole.user ? 18 : 0),
                      topRight: Radius.circular(
                          message.role == ChatMessageRole.user ? 0 : 18),
                      bottomLeft: const Radius.circular(18),
                      bottomRight: const Radius.circular(18),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: MarkdownBody(
                    data: message.content,
                    styleSheet: MarkdownStyleSheet(
                      p: TextStyle(
                          color: message.role == ChatMessageRole.user
                              ? AppColors.primaryDark
                              : AppColors.textColor,
                          fontSize: 15,
                          height: 1.4),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    timeago.format(message.updatedAt),
                    style: TextStyle(
                      color: Colors.grey.shade400,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}