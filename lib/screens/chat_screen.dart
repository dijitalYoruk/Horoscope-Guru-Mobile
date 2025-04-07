import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class ChatMessage {
  final String text;
  final bool isUser;
  final String time;
  final bool isAd;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.time,
    this.isAd = false,
  });
}

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
        mainAxisAlignment: message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!message.isUser)
            CircleAvatar(
              radius: 14,
              backgroundColor: Colors.deepPurple.shade500,
              backgroundImage: const AssetImage('assets/images/logo.png'),
            ),
          if (!message.isUser) const SizedBox(width: 8),
          Flexible(
            child: Column(
              crossAxisAlignment: message.isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: message.isUser ? userBubbleColor : aiBubbleColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(message.isUser ? 18 : 0),
                      topRight: Radius.circular(message.isUser ? 0 : 18),
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
                  child: Text(
                    message.text,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 15,
                      height: 1.4,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    message.time,
                    style: TextStyle(
                      color: Colors.grey.shade400,
                      fontSize: 10,
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

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final FocusNode _messageFocusNode = FocusNode();
  final List<ChatMessage> _messages = [
    ChatMessage(
      text: "Hello! I'm your Horoscope Guru. To create your birth chart, I'll need some details about when and where you were born.",
      isUser: false,
      time: "10:00 AM",
    ),
    ChatMessage(
      text: "First, what is your date of birth? (DD/MM/YYYY)",
      isUser: false,
      time: "10:00 AM",
    ),
  ];

  RewardedAd? _rewardedAd;
  bool _isRewardedAdLoaded = false;
  int _messageCount = 0;
  bool _showAd = false;
  bool _awaitingAd = false;

  final String _androidAdUnitId = 'ca-app-pub-3940256099942544/5224354917';
  final String _iosAdUnitId = 'ca-app-pub-3940256099942544/5224354917';

  String get _adUnitId => Platform.isIOS ? _iosAdUnitId : _androidAdUnitId;

  @override
  void initState() {
    super.initState();
    _initAdMob();
  }

  Future<void> _initAdMob() async {
    await MobileAds.instance.initialize();
    _loadRewardedAd();
  }

  void _loadRewardedAd() {
    RewardedAd.load(
      adUnitId: _adUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          setState(() {
            _rewardedAd = ad;
            _isRewardedAdLoaded = true;
          });
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              _onAdDismissed();
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              ad.dispose();
              _onAdDismissed();
            },
          );
        },
        onAdFailedToLoad: (error) {
          setState(() => _isRewardedAdLoaded = false);
        },
      ),
    );
  }

  void _onAdDismissed() {
    setState(() {
      _awaitingAd = false;
    });
    _loadRewardedAd();
  }

  void _onAdWatched(RewardItem reward) {
    setState(() {
      _messageCount = 0;
      _awaitingAd = false;
    });
  }

  void _handleSubmitted(String text) {
    if (text.trim().isEmpty) return;

    if (_messageCount >= 4 && !_awaitingAd) {
      _showRewardedAdDialog();
      return;
    }

    _messageController.clear();
    _messageCount++;

    setState(() {
      _messages.insert(0, ChatMessage(
        text: text,
        isUser: true,
        time: _formatTime(DateTime.now()),
      ));

      Future.delayed(const Duration(milliseconds: 800), () {
        setState(() => _messages.insert(0, _getAIResponse(text)));
      });
    });
  }

  void _showRewardedAdDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.deepPurple.shade800,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.star_rounded, size: 36, color: Colors.amberAccent),
            const SizedBox(width: 10),
            const Text("Watch an Ad"),
          ],
        ),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        content: const Text(
          "Watch a short ad to unlock 4 more messages.",
        ),
        contentTextStyle: TextStyle(
          color: Colors.grey,
          fontSize: 15,
        ),
        actions: [
          TextButton(
            child: const Text("Cancel"),
            onPressed: () => Navigator.of(context).pop(),
            style: TextButton.styleFrom(
              foregroundColor: Colors.grey.shade300,
            ),
          ),
          TextButton(
            child: const Text("Watch Ad"),
            onPressed: () {
              Navigator.of(context).pop();
              _showRewardedAd();
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.orangeAccent,
            ),
          ),
        ],
      ),
    );
  }

  void _showRewardedAd() {
    if (_rewardedAd != null) {
      setState(() => _awaitingAd = true);
      _rewardedAd!.show(
        onUserEarnedReward: (ad, reward) => _onAdWatched(reward),
      );
    } else {
      _loadRewardedAd();
    }
  }

  ChatMessage _getAIResponse(String userMessage) {
    if (_messages.any((msg) => msg.text.contains("date of birth"))) {
      return ChatMessage(
        text: "Thank you! Now, where were you born? (City, Country)",
        isUser: false,
        time: _formatTime(DateTime.now()),
      );
    } else if (_messages.any((msg) => msg.text.contains("where were you born"))) {
      return ChatMessage(
        text: "Perfect! I'm calculating your birth chart now...✨",
        isUser: false,
        time: _formatTime(DateTime.now()),
      );
    }
    return ChatMessage(
      text: "Interesting! What else would you like to know about your horoscope?",
      isUser: false,
      time: _formatTime(DateTime.now()),
    );
  }

  String _formatTime(DateTime time) {
    return "${time.hour}:${time.minute.toString().padLeft(2, '0')}";
  }

  Widget _buildInputArea(Color textColor, Color buttonColor) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      decoration: BoxDecoration(
        color: Colors.deepPurple.shade800,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.deepPurple.shade700,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      focusNode: _messageFocusNode,
                      style: TextStyle(color: textColor),
                      decoration: InputDecoration.collapsed(
                        hintText: "Type your message...",
                        hintStyle: TextStyle(
                          color: Colors.grey.shade400,
                          fontSize: 15,
                        ),
                      ),
                      onSubmitted: _handleSubmitted,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.emoji_emotions_outlined,
                        color: textColor.withOpacity(0.7)),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            decoration: BoxDecoration(
              color: buttonColor,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: Icon(Icons.send, color: textColor),
              onPressed: () => _handleSubmitted(_messageController.text),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = Colors.deepPurple.shade900;
    final chatBackground = const Color(0xFF0F0B21);
    final userBubbleColor = Colors.deepOrange.shade700;
    final aiBubbleColor = Colors.deepPurple.shade700;
    final textColor = Colors.white;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Hero(
              tag: 'guru-avatar',
              child: CircleAvatar(
                radius: 18,
                backgroundColor: Colors.deepPurple.shade500,
                backgroundImage: const AssetImage('assets/images/logo.png'),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'Horoscope Guru',
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert, color: textColor.withOpacity(0.8)),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: chatBackground,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
                child: ListView.builder(
                  reverse: true,
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    return ChatBubble(
                      message: _messages[index],
                      userBubbleColor: userBubbleColor,
                      aiBubbleColor: aiBubbleColor,
                      textColor: textColor,
                    );
                  },
                ),
              ),
            ),
          ),
          _buildInputArea(textColor, userBubbleColor),
        ],
      ),
    );
  }
}
