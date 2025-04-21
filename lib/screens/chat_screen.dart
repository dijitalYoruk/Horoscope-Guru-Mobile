import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:horoscopeguruapp/api/api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/rendering.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:horoscopeguruapp/theme/colors.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
                      p: TextStyle(color: textColor, fontSize: 15, height: 1.4),
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
  final String? chatId;

  const ChatScreen({super.key, this.chatId});

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
  bool _isProcessingMessage = false;
  bool _isInputAreaVisible = false;

  final String _androidAdUnitId = 'ca-app-pub-3940256099942544/5224354917';
  final String _iosAdUnitId = 'ca-app-pub-3940256099942544/5224354917';

  String get _adUnitId => Platform.isIOS ? _iosAdUnitId : _androidAdUnitId;

  String? _chatId;

  @override
  void initState() {
    super.initState();
    _chatId = widget.chatId;

    _loadMessageCount();
    if (ChatScreen.enableAds) {
      _initAdMob();
    }
    _messageController.addListener(() {
      // Remove the auto-close behavior when text changes
    });

    if (_chatId != null) {
      _getChatById().then((_) {
        // Set input area visible after loading
        setState(() {
          _isInputAreaVisible = true;
        });
      });
    } else {
      _startNewChat().then((_) {
        // Set input area visible after loading
        setState(() {
          _isInputAreaVisible = true;
        });
      });
    }
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
    if (text.trim().isEmpty || _isProcessingMessage) return;

    setState(() {
      _isProcessingMessage = true;
    });

    if (ChatScreen.enableAds &&
        _messageCount >= ChatScreen.maxMessages &&
        !_awaitingAd) {
      _showRewardedAdDialog();
      setState(() {
        _isProcessingMessage = false;
      });
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
            updatedAt: DateTime.now(),
          ));
    });

    await _sendMessage();

    setState(() {
      _isProcessingMessage = false;
    });
  }

  void _showRewardedAdDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.primaryDarkE,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.star_rounded, size: 36, color: Colors.amberAccent),
            const SizedBox(width: 10),
            Text(AppLocalizations.of(context)!.watchAnAd),
          ],
        ),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        content: Text(
          AppLocalizations.of(context)!.watchAdToUnlockMessages,
        ),
        contentTextStyle: TextStyle(
          color: Colors.grey,
          fontSize: 15,
        ),
        actions: [
          TextButton(
            child: Text(AppLocalizations.of(context)!.cancel),
            onPressed: () => Navigator.of(context).pop(),
            style: TextButton.styleFrom(
              foregroundColor: Colors.grey.shade300,
            ),
          ),
          TextButton(
            child: Text(AppLocalizations.of(context)!.watchAd),
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

  Widget _buildInputArea(Color textColor, Color buttonColor) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
          decoration: BoxDecoration(
            color: AppColors.primaryDarkE,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(0),
              bottomRight: Radius.circular(0),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.primaryDark,
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
                            hintText:
                                AppLocalizations.of(context)!.typeYourMessage,
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
                            color: AppColors.accent),
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
                decoration: const BoxDecoration(
                  color: AppColors.accent,
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
                  customBackspaceIcon:
                      const Icon(Icons.close, color: Colors.white),
                  emojiViewConfig: EmojiViewConfig(
                    columns: 7,
                    emojiSizeMax: 32.0,
                    backgroundColor: AppColors.primaryDark,
                    verticalSpacing: 0,
                    horizontalSpacing: 0,
                    gridPadding: EdgeInsets.zero,
                    recentsLimit: 28,
                    replaceEmojiOnLimitExceed: false,
                    noRecents: Text(
                      AppLocalizations.of(context)!.noRecents,
                      style:
                          TextStyle(fontSize: 20, color: Colors.grey.shade400),
                      textAlign: TextAlign.center,
                    ),
                    loadingIndicator: SizedBox.shrink(),
                    buttonMode: ButtonMode.MATERIAL,
                  ),
                  categoryViewConfig: const CategoryViewConfig(
                    backgroundColor: AppColors.primaryDarkE,
                    iconColor: AppColors.textColor,
                    iconColorSelected: AppColors.accent,
                    indicatorColor: AppColors.accent,
                  ),
                  bottomActionBarConfig: BottomActionBarConfig(
                    backgroundColor: AppColors.primaryDarkE,
                    buttonColor: AppColors.primaryDarkE,
                    buttonIconColor: Colors.white,
                  ),
                  searchViewConfig: SearchViewConfig(
                    backgroundColor: AppColors.primaryDarkE,
                    hintTextStyle: TextStyle(color: AppColors.textColor),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  var _isLoading = false;

  Future<void> _startNewChat() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final api = Api();
      final response = await api.startChat(context);

      setState(() {
        _messages.add(response.message);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _getChatById() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final api = Api();
      final response = await api.getChatById(_chatId!, context);

      setState(() {
        _messages.addAll(response.chatMessages);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _sendMessage() async {
    final api = Api();
    final request = PostChatRequest(
      chatId: _chatId,
      message: _messages.first.content,
      initialMessage: _messages.last,
    );

    try {
      final response = await api.sendMessageToChat(request, context);

      setState(() {
        _messages.insert(
            0,
            ChatMessage(
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
    }
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = AppColors.primaryDark;
    final textColor = AppColors.textColor;

    return Scaffold(
      backgroundColor: AppColors.primary,
      extendBody: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 84,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.accent),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                      color: AppColors.primaryDark,
                      borderRadius: BorderRadius.all(Radius.circular(64))),
                  child: Image.asset(
                    'assets/images/logo.png',
                    height: 64,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  AppLocalizations.of(context)!.horoscopeGuru,
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            )
          ],
        ),
        actions: [
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert, color: AppColors.accent),
            color: AppColors.primaryDark,
            onSelected: (String result) {
              if (_chatId == null) {
                Navigator.of(context).pop();
                return;
              }

              if (result == 'delete') {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      backgroundColor: AppColors.primaryDarkE,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      title: Text(
                        'Delete Chat',
                        style: TextStyle(
                          color: AppColors.accent,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      content: Text(
                        'Are you sure you want to delete this chat?',
                        style: TextStyle(
                          color: AppColors.textColor,
                          fontSize: 16,
                        ),
                      ),
                      actions: <Widget>[
                        TextButton(
                          child: Text('Cancel',
                              style: TextStyle(color: AppColors.accent)),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        TextButton(
                          child: Text('Delete',
                              style: TextStyle(color: AppColors.accent)),
                          onPressed: () async {
                            Api api = Api();
                            await api.deleteChat(_chatId!, context);
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'delete',
                child: Text('Delete Chat',
                    style: TextStyle(
                        color: AppColors.accent,
                        fontSize: 16,
                        fontWeight: FontWeight.w700)),
              ),
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            if (_isLoading)
              Expanded(
                child: Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.accent),
                  ),
                ),
              )
            else
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
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
                      child: Column(
                        children: [
                          const SizedBox(height: 16),
                          Expanded(
                            child: ListView.builder(
                              reverse: true,
                              padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                              itemCount: _messages.length,
                              itemBuilder: (context, index) {
                                return ChatBubble(
                                  message: _messages[index],
                                  userBubbleColor: AppColors.accent,
                                  aiBubbleColor: AppColors.primary,
                                  textColor: textColor,
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                      )),
                ),
              ),
            if (_isProcessingMessage)
              Container(
                width: double.infinity,
                color: AppColors.accent.withOpacity(0.1),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Transform.scale(
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(AppColors.accent),
                          strokeWidth: 6,
                        ),
                        scale: 0.5),
                    Text(
                      'The Guru is thinking... Please wait.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.accent,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            if (_isInputAreaVisible)
              _buildInputArea(textColor, AppColors.accent),
          ],
        ),
      ),
    );
  }
}
