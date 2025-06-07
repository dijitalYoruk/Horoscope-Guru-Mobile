import 'package:flutter/material.dart';
import 'package:horoscopeguruapp/api/api.dart';
import 'package:horoscopeguruapp/screens/chat_screen.dart';
import 'package:horoscopeguruapp/theme/colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

class AllChatsScreen extends StatefulWidget {
  const AllChatsScreen({Key? key}) : super(key: key);

  @override
  State<AllChatsScreen> createState() => _AllChatsScreenState();
}

class _AllChatsScreenState extends State<AllChatsScreen> with RouteAware {
  List<Chat> _chats = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchChats();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Optionally subscribe to route observer if you want to refresh on return
  }

  Future<void> _fetchChats() async {
    setState(() => _loading = true);
    var api = Api();
    var response = await api.getAllUserChats(context);
    setState(() {
      _chats = response.chats;
      _loading = false;
    });
  }

  Future<void> _deleteChat(int index) async {
    var api = Api();
    await api.deleteChat(_chats[index].chatId, context);
    setState(() {
      _chats.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final secondaryTextColor = Colors.grey[400];
    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.accent),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          localizations.yourCosmicQuestions,
          style: const TextStyle(
            color: AppColors.textColor,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: _loading
          ? Center(child: CircularProgressIndicator(color: AppColors.accent))
          : _chats.isEmpty
              ? Center(
                  child: Text(
                    localizations.noCosmicQuestionsReceivedYet,
                    style: TextStyle(
                      color: secondaryTextColor,
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  itemCount: _chats.length,
                  itemBuilder: (context, index) {
                    final chat = _chats[index];
                    return Dismissible(
                      key: Key(chat.chatId),
                      direction: DismissDirection.endToStart,
                      onDismissed: (direction) => _deleteChat(index),
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Icon(Icons.delete, color: Colors.white),
                      ),
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 4,
                          ),
                          title: Text(
                            chat.chatTitle ?? localizations.yourCosmicQuestions,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          trailing: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.calendar_today,
                                    size: 12,
                                    color: AppColors.accent,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    DateFormat('MMM d').format(chat.updatedAt),
                                    style: const TextStyle(
                                      color: AppColors.accent,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 4),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.access_time,
                                    size: 12,
                                    color: AppColors.accent,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    DateFormat('HH:mm').format(chat.updatedAt),
                                    style: const TextStyle(
                                      color: AppColors.accent,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ChatScreen(chatId: chat.chatId),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
