import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:horoscopeguruapp/screens/chat_screen.dart';
import 'dart:math';
import 'package:intl/intl.dart';
import 'package:flutter/widgets.dart';

import 'package:horoscopeguruapp/api/api.dart';
import 'package:horoscopeguruapp/theme/colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with RouteAware {
  // Daily Laughter Card Component
  late String _funnyAstroQuote;
  final List<String> _astroQuotes = [
    "When Mercury is in retrograde, even your microwave questions life choices.",
    "Your horoscope says you'll meet someone tall, dark, and handsome... it's just your shadow at 5 PM.",
    "The stars say today is perfect for new beginnings... like that gym membership you won't use.",
    "Venus is in your house of snacks - expect mysterious disappearances of chips.",
    "Today's cosmic alignment suggests you'll argue with a Libra about where to eat... again.",
    "Your aura is purple today, which means either spiritual growth or you sat on a grape.",
    "Mars is in your WiFi zone - expect buffering during important video calls.",
    "The moon suggests you'll find what you're looking for... in the last place you left it.",
    "Jupiter's position indicates someone is thinking about you... probably wondering why you haven't texted back.",
    "Your spiritual animal today is a sloth. Interpret this as you will (but maybe take a nap).",
    "The universe says you're destined for greatness... right after this Netflix binge.",
    "Today's reading: You will walk into a room and forget why. Bonus points if you do it twice.",
    "Saturn's rings predict you'll say 'I'll do it tomorrow' exactly 4 times today.",
    "Cosmic forecast: Your phone will die at 15% battery. The universe finds this hilarious.",
    "The stars say you'll have a brilliant idea today... right after you forget it."
  ];

  // Expanded Chat History Data (20 items)
  List<Chat> _chatHistory = [];

  @override
  void initState() {
    super.initState();
    _funnyAstroQuote = _astroQuotes[Random().nextInt(_astroQuotes.length)];
    getUserChats();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute<dynamic>);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }


  @override
  void didPopNext() {
    // Refetch user chats when returning to this screen
    getUserChats();
  }

  Future<void> getUserChats() async {
    var api = Api();
    var response = await api.getAllUserChats(context);

    setState(() {
      _chatHistory = response.chats;
    });
  }

  Widget _buildDailyLaughterCard() {
    final primaryColor = AppColors.primary;
    final textColor = AppColors.textColor;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      padding: EdgeInsets.only(top: 20, bottom: 10, right: 16, left: 16),
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'TODAY\'S COSMIC COMEDY',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 15),
          Text(
            _funnyAstroQuote,
            style: TextStyle(
              color: textColor,
              fontSize: 16,
              height: 1.5,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Refresh for cosmic wisdom',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                ),
              ),
              IconButton(
                icon: Icon(Icons.refresh, color: Colors.white),
                onPressed: () {
                  setState(() {
                    _funnyAstroQuote =
                        _astroQuotes[Random().nextInt(_astroQuotes.length)];
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChatHistorySection() {
    final secondaryTextColor = Colors.grey[400];

    return Expanded(
      child: Container(
        margin: EdgeInsets.fromLTRB(20, 0, 20, 0), // Removed bottom margin
        decoration: const BoxDecoration(
          color: AppColors.primary,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(20),
            bottom: Radius.circular(20), // Added bottom rounded corners
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Your Cosmic Questions',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      'View All',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                physics: AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.only(bottom: 20),
                itemCount: _chatHistory.length,
                itemBuilder: (context, index) {
                  final chat = _chatHistory[index];
                  return Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primaryDark,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 4,
                      ),
                      title: Text(
                        chat.chatTitle!,
                        style: TextStyle(
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
                              Icon(Icons.calendar_today,
                                  size: 12, color: secondaryTextColor),
                              SizedBox(width: 4),
                              Text(
                                DateFormat('MMM d').format(chat.updatedAt),
                                style: TextStyle(
                                  color: secondaryTextColor,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 4),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.access_time,
                                  size: 12, color: secondaryTextColor),
                              SizedBox(width: 4),
                              Text(
                                DateFormat('HH:mm').format(chat.updatedAt),
                                style: TextStyle(
                                  color: secondaryTextColor,
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
                            ));
                      },
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = AppColors.primaryDark;
    final iconBgColor = AppColors.primary;
    final textColor = AppColors.textColor;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // App Header
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: iconBgColor,
                      shape: BoxShape.circle,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.asset(
                        'assets/images/logo.png',
                        width: 100.0,
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Text(
                    'Horoscope Guru',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      color: textColor,
                      letterSpacing: 1.1,
                    ),
                  ),
                ],
              ),
            ),

            // Daily Laughter Card
            _buildDailyLaughterCard(),

            // Start Chat Button
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/userProfile');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrange.shade900,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 1,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.chat, size: 24, color: Colors.white),
                    const SizedBox(width: 12),
                    Text(
                      'Ask the Stars',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: textColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Chat History Section
            _buildChatHistorySection(),
            const SizedBox(height: 20)
          ],
        ),
      ),
    );
  }
}

// Define a RouteObserver to be used in the app
final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();
