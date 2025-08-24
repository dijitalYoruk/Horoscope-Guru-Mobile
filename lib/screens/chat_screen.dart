import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:horoscopeguruapp/api/api.dart';
import 'package:horoscopeguruapp/screens/chat_bubble.dart';
import 'package:horoscopeguruapp/screens/chat_emoji_picker.dart';
import 'package:horoscopeguruapp/utils/environment_keys.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/rendering.dart';
import 'package:horoscopeguruapp/theme/colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:horoscopeguruapp/models/relationship_data.dart';

class ChatScreen extends StatefulWidget {
  final String? chatId;
  final RelationshipData? relationshipData;
  static const bool enableAds = true;
  static const int maxMessages = 4;
  static const int maxUserMessages = 25;
  static const String messageCountKey = 'message_count';

  const ChatScreen({super.key, this.chatId, this.relationshipData});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final FocusNode _messageFocusNode = FocusNode();
  final List<ChatMessage> _messages = [];
  late IO.Socket socket;

  RewardedAd? _rewardedAd;
  int _messageCount = 0;
  bool _awaitingAd = false;
  bool _isEmojiPickerVisible = false;
  bool _isProcessingMessage = false;
  bool _isInputAreaVisible = false;

  String get _adUnitId => Platform.isIOS
      ? EnvironmentKeys.IosAdMobIdAndroid
      : EnvironmentKeys.GoogleAdMobIdAndroid;
  String? _chatId;
  RelationshipData? _relationshipData;
  var _isPageLoading = true;

  @override
  void initState() {
    super.initState();

    setState(() {
      _isPageLoading = true;
    });

    _chatId = widget.chatId;
    _relationshipData = widget.relationshipData;

    _loadMessageCount();
    if (ChatScreen.enableAds) {
      _initAdMob();
    }
    _messageController.addListener(() {
      // Remove the auto-close behavior when text changes
    });

    socket = IO.io(
      EnvironmentKeys.SocketUrl,
      IO.OptionBuilder().setTransports(['websocket']) // zorunlu
          .build(),
    );

    socket.onConnect((_) {
      print('Socket connected: ${socket.id}');
    });

    socket.on('message_token', (data) {
      if (_messages.isEmpty || _messages[0].role == ChatMessageRole.user) {
        setState(() {
          _isPageLoading = false;
          _isProcessingMessage = true;

          _messages.insert(
              0,
              ChatMessage(
                content: data['content'],
                role: ChatMessageRole.assistant,
                updatedAt: HttpDate.parse(data['updatedAt']),
              ));
        });
      } else {
        setState(() {
          var a = _messages[0].content;
          _messages[0].content = a + data['content'];
          _messages[0].updatedAt = HttpDate.parse(data['updatedAt']);
        });
      }
    });

    socket.on('message_finished', (_) {
      setState(() {
        _isProcessingMessage = false;
      });
    });

    socket.on('chat_error', (data) {
      Fluttertoast.showToast(
        msg: data['message'],
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: AppColors.accent,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    });

    socket.connect();

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

  @override
  void dispose() {
    socket.off('chat_token');
    socket.dispose();
    super.dispose();
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

    // Check if user message limit is reached
    int userMessageCount =
        _messages.where((msg) => msg.role == ChatMessageRole.user).length;
    if (userMessageCount >= ChatScreen.maxUserMessages) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: const Row(
              children: [
                Icon(Icons.info_outline, color: AppColors.accent),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Chat limit reached',
                        style: TextStyle(
                          color: AppColors.accent,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Please start a new chat to continue',
                        style: TextStyle(
                          color: AppColors.textColor,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          backgroundColor: AppColors.primaryDarkE,
          duration: const Duration(seconds: 4),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).size.height - 100,
            right: 20,
            left: 20,
          ),
        ),
      );
      return;
    }

    setState(() {
      _isProcessingMessage = true;
      _isEmojiPickerVisible = false;
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
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        content: Text(
          AppLocalizations.of(context)!.watchAdToUnlockMessages,
        ),
        contentTextStyle: const TextStyle(
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

  Widget _buildInputArea(Color textColor, Color buttonColor,
      bool isMessageProcessing, bool isPageLoading) {
    // Check if user message limit is reached
    int userMessageCount =
        _messages.where((msg) => msg.role == ChatMessageRole.user).length;
    bool isLimitReached = userMessageCount >= ChatScreen.maxUserMessages;

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
          decoration: const BoxDecoration(
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
                    color: isLimitReached
                        ? AppColors.primaryDark.withOpacity(0.5)
                        : AppColors.primaryDark,
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextField(
                          maxLines: null,
                          // Allows unlimited lines
                          controller: _messageController,
                          focusNode: _messageFocusNode,
                          style: TextStyle(color: textColor),
                          enabled: !(isLimitReached ||
                              isMessageProcessing ||
                              isPageLoading),
                          decoration: InputDecoration.collapsed(
                            hintText: isLimitReached
                                ? 'Chat limit reached.'
                                : AppLocalizations.of(context)!.typeYourMessage,
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
                            color: isLimitReached
                                ? AppColors.accent.withOpacity(0.5)
                                : AppColors.accent),
                        onPressed: isLimitReached ||
                                isMessageProcessing ||
                                isPageLoading
                            ? null
                            : () {
                                setState(() {
                                  _isEmojiPickerVisible =
                                      !_isEmojiPickerVisible;
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
                  color: isLimitReached
                      ? AppColors.accent.withOpacity(0.5)
                      : AppColors.accent,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: Icon(Icons.send, color: textColor),
                  onPressed: isLimitReached
                      ? null
                      : () => _handleSubmitted(_messageController.text),
                ),
              ),
            ],
          ),
        ),
        if (_isEmojiPickerVisible && !isLimitReached)
          ChatEmojiPicker(onBackspacePressed: () {
            setState(() {
              _isEmojiPickerVisible = false;
            });
          }, onEmojiSelected: (category, emoji) {
            final currentText = _messageController.text;
            final newText = currentText + emoji.emoji;
            _messageController.value = TextEditingValue(
              text: newText,
              selection: TextSelection.collapsed(offset: newText.length),
            );
          })
      ],
    );
  }

  Future<void> _startNewChat() async {
    setState(() {
      _isPageLoading = true;
    });

    var prefs = await SharedPreferences.getInstance();
    var accessToken = prefs.getString('access_token');
    Map<String, dynamic> data = {'accessToken': accessToken};

    // Add relationship data if available
    if (_relationshipData != null) {
      data['relationship'] =_relationshipData?.toJson();
    }

    socket.emit('start_chat', data);
  }

  Future<void> _getChatById() async {
    setState(() {
      _isPageLoading = true;
    });

    try {
      final api = Api();
      final response = await api.getChatById(_chatId!, context);

      setState(() {
        _messages.addAll(response.chatMessages);
        _isPageLoading = false;
      });
    } catch (e) {
      setState(() {
        _isPageLoading = false;
      });
    }
  }

  Future<void> _sendMessage() async {
    var prefs = await SharedPreferences.getInstance();
    var accessToken = prefs.getString('access_token');

    Map<String, dynamic> messageData = {
      'accessToken': accessToken,
      'chatId': _chatId,
      'message': _messages.first.content,
      'initialMessage': _messages.last,
    };

    socket.emit("send_message", messageData);
    FocusScope.of(context).requestFocus(FocusNode());
  }

  Widget _buildRelationshipSummary() {
    if (_relationshipData == null) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.accent, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.favorite, color: AppColors.accent, size: 20),
              const SizedBox(width: 8),
              Text(
                'Relationship Analysis',
                style: TextStyle(
                  color: AppColors.accent,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            _relationshipData!.summary,
            style: TextStyle(
              color: AppColors.textColor,
              fontSize: 14,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
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
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(4),
                  decoration: const BoxDecoration(
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
            const SizedBox(
              height: 10,
            )
          ],
        ),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: AppColors.accent),
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
              PopupMenuItem<String>(
                value: 'delete',
                child: Text(AppLocalizations.of(context)!.deleteChat,
                    style: const TextStyle(
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
                child: _isPageLoading
                    ? const Expanded(
                        child: Center(
                          child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(AppColors.accent),
                          ),
                        ),
                      )
                    : ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(24),
                          topRight: Radius.circular(24),
                        ),
                        child: Column(
                          children: [
                            const SizedBox(height: 16),
                            _buildRelationshipSummary(),
                            Expanded(
                              child: ListView.builder(
                                reverse: true,
                                padding:
                                    const EdgeInsets.fromLTRB(16, 0, 16, 0),
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
            if (!_isPageLoading && _isProcessingMessage)
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
              _buildInputArea(textColor, AppColors.accent, _isProcessingMessage,
                  _isPageLoading),
          ],
        ),
      ),
    );
  }
}
