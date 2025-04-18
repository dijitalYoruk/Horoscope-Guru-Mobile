import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:horoscopeguruapp/api/api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/rendering.dart';
import 'package:timeago/timeago.dart' as timeago;

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
        mainAxisAlignment:
            message.role == ChatMessageRole.user ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (message.role == ChatMessageRole.assistant)
            CircleAvatar(
              radius: 24,
              backgroundColor: Colors.deepPurple.shade500,
              backgroundImage: const AssetImage('assets/images/logo.png'),
            ),
          if (message.role == ChatMessageRole.assistant) const SizedBox(width: 8),
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
                    color: message.role == ChatMessageRole.user ? userBubbleColor : aiBubbleColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(message.role == ChatMessageRole.user ? 18 : 0),
                      topRight: Radius.circular(message.role == ChatMessageRole.user ? 0 : 18),
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
                    message.content,
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

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  static const bool enableAds = true;
  static const int maxMessages = 4;
  static const String messageCountKey = 'message_count';

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final FocusNode _messageFocusNode = FocusNode();


  final List<ChatMessage> _messages = [];

  RewardedAd? _rewardedAd;
  int _messageCount = 0;
  bool _awaitingAd = false;
  bool _isEmojiPickerVisible = false;

  final String _androidAdUnitId = 'ca-app-pub-3940256099942544/5224354917';
  final String _iosAdUnitId = 'ca-app-pub-3940256099942544/5224354917';

  String get _adUnitId => Platform.isIOS ? _iosAdUnitId : _androidAdUnitId;

  @override
  void initState() {
    super.initState();
    _loadMessageCount();
    if (ChatScreen.enableAds) {
      _initAdMob();
    }
    _messageController.addListener(() {
      // Remove the auto-close behavior when text changes
    });

    _startNewChat();
  }

  Future<void> _loadMessageCount() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _messageCount = prefs.getInt(ChatScreen.messageCountKey) ?? 0;
    });
  }

  Future<void> _saveMessageCount(int count) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(ChatScreen.messageCountKey, count);
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
        onAdFailedToLoad: (error) {},
      ),
    );
  }

  void _onAdDismissed() {
    setState(() {
      _awaitingAd = false;
    });
    _loadRewardedAd();
  }

  void _onAdWatched(RewardItem reward) async {
    await _saveMessageCount(0);
    setState(() {
      _messageCount = 0;
      _awaitingAd = false;
    });
  }

  void _handleSubmitted(String text) async {
    if (text.trim().isEmpty) return;

    if (ChatScreen.enableAds &&
        _messageCount >= ChatScreen.maxMessages &&
        !_awaitingAd) {
      _showRewardedAdDialog();
      return;
    }

    _messageController.clear();
    _messageCount++;
    await _saveMessageCount(_messageCount);

    setState(() {
      _messages.insert(
          0,
          ChatMessage(
            content: text,
            role: ChatMessageRole.user,
            updatedAt: DateTime.now()
          ));
    });

    _sendMessage();
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

  String _formatTime(DateTime time) {
    return "${time.hour}:${time.minute.toString().padLeft(2, '0')}";
  }

  Widget _buildInputArea(Color textColor, Color buttonColor) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          decoration: BoxDecoration(
            color: Colors.deepPurple.shade800,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(0),
              bottomRight: Radius.circular(0),
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
                    borderRadius: BorderRadius.circular(0),
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
                          onChanged: (text) {
                            if (_isEmojiPickerVisible && text.isNotEmpty) {
                              setState(() {
                                _isEmojiPickerVisible = false;
                              });
                            }
                          },
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.emoji_emotions_outlined,
                            color: textColor.withOpacity(0.7)),
                        onPressed: () {
                          setState(() {
                            _isEmojiPickerVisible = !_isEmojiPickerVisible;
                          });
                        },
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
        ),
        if (_isEmojiPickerVisible)
          Container(
            decoration: BoxDecoration(
              color: Colors.deepPurple.shade800,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(0),
                bottomRight: Radius.circular(0),
              ),
            ),
            child: SizedBox(
              height: 250,
              child: EmojiPicker(
                onBackspacePressed: () {
                  setState(() {
                    _isEmojiPickerVisible = false;
                  });
                },
                onEmojiSelected: (category, emoji) {
                  final currentText = _messageController.text;
                  final newText = currentText + emoji.emoji;
                  _messageController.value = TextEditingValue(
                    text: newText,
                    selection: TextSelection.collapsed(offset: newText.length),
                  );
                },
                config: Config(
                  height: 250,
                  viewOrderConfig: ViewOrderConfig(),
                  checkPlatformCompatibility: true,
                  emojiSet: null,
                  emojiTextStyle: TextStyle(fontSize: 32, color: Colors.white),
                  customSearchIcon:
                      const Icon(Icons.search, color: Colors.white),
                  customBackspaceIcon: const Icon(Icons.close, color: Colors.white),
                  emojiViewConfig: EmojiViewConfig(
                    columns: 7,
                    emojiSizeMax: 32.0,
                    backgroundColor: const Color(0xFF2C2C54),
                    verticalSpacing: 0,
                    horizontalSpacing: 0,
                    gridPadding: EdgeInsets.zero,
                    recentsLimit: 28,
                    replaceEmojiOnLimitExceed: false,
                    noRecents: Text(
                      'No Recents',
                      style:
                          TextStyle(fontSize: 20, color: Colors.grey.shade400),
                      textAlign: TextAlign.center,
                    ),
                    loadingIndicator: SizedBox.shrink(),
                    buttonMode: ButtonMode.MATERIAL,
                  ),
                  skinToneConfig: SkinToneConfig(
                    dialogBackgroundColor: const Color(0xFF2C2C54),
                    indicatorColor: Colors.deepPurple.shade500,
                  ),
                  categoryViewConfig: CategoryViewConfig(
                    backgroundColor: Colors.deepPurple.shade800,
                    iconColor: Colors.grey.shade400,
                    iconColorSelected: Colors.deepPurple.shade300,
                    indicatorColor: Colors.deepPurple.shade300,
                  ),
                  bottomActionBarConfig: BottomActionBarConfig(
                    backgroundColor: Colors.deepPurple.shade800,
                    buttonColor: Colors.deepPurple.shade800,
                    buttonIconColor: Colors.white,
                  ),
                  searchViewConfig: SearchViewConfig(
                    backgroundColor: Colors.deepPurple.shade800,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  String? _chatId = "";
  var _isLoading = false;

  Future<void> _startNewChat() async {
    try {
      setState(() {
        _isLoading = true;
      });


      final prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('access_token');

      if (accessToken == null) {
        return;
      }

      final dio = Dio(BaseOptions(
        baseUrl: 'http://10.0.2.2:8080',
      ));

      final api = Api();
      final response = await api.startChat(accessToken);

      setState(() {
        _messages.add(response.message);
        _isLoading = false;
      });

    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error starting chat: $e');
    }
  }

  Future<void> _sendMessage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('access_token');

      if (accessToken == null) {
        return;
      }

      final dio = Dio(BaseOptions(
        baseUrl: 'http://10.0.2.2:8080',
      ));

      final api = Api();

      final request = PostChatRequest(
          chatId: _chatId,
          message: _messages.first.content,
          initialMessage: _messages.last,
      );

      final response = await api.sendMessageToChat(accessToken, request);

        setState(() {
          _messages.insert(0, ChatMessage(
            content: response.message.content,
            role: response.message.role,
            updatedAt: response.message.updatedAt,
          ));
          _chatId = response.chatId;
          _isLoading = false;
          _messageCount++;
          _saveMessageCount(_messageCount);
        });

    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error sending message: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = Colors.deepPurple.shade900;
    final chatBackground = const Color(0xFF2C2C54);
    final userBubbleColor = Colors.deepOrange.shade700;
    final aiBubbleColor = Colors.deepPurple.shade500;
    final textColor = Colors.white;

    return Scaffold(
      backgroundColor: backgroundColor,
      extendBody: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: textColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Hero(
              tag: 'guru-avatar',
              child: CircleAvatar(
                radius: 24,
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
      body: SafeArea(
        child: Column(
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
      ),
    );
  }
}
