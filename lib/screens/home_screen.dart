import 'package:flutter/material.dart';
import 'dart:math';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
  final List<Map<String, String>> _chatHistory = List.generate(20, (index) {
    final days = ['Today', 'Yesterday', 'Mar 12', 'Mar 11', 'Mar 10'];
    final times = ['3:42 PM', '11:15 AM', '2:30 PM', '9:45 AM', '5:20 PM'];
    final questions = [
      'Will I ever be rich?',
      'Does my cat hate me?',
      'Why is my plant dying?',
      'Is my ex thinking about me?',
      'Should I quit my job?',
      'Will I win the lottery?',
      'Why do I keep seeing 11:11?',
      'Is Mercury in retrograde?',
      'What does my dream mean?',
      'When will I find love?'
    ];

    return {
      'title': questions[index % questions.length],
      'date': '${days[index % days.length]} ${times[index % times.length]}'
    };
  });

  @override
  void initState() {
    super.initState();
    _funnyAstroQuote = _astroQuotes[Random().nextInt(_astroQuotes.length)];
  }

  Widget _buildDailyLaughterCard() {
    final accentColor = Colors.deepOrange;
    final cardColor = Color(0xFF1E1E1E);
    final textColor = Colors.white;
    final secondaryTextColor = Colors.grey[400];

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      padding: EdgeInsets.only( top: 20, bottom: 10, right: 16, left: 16),
      decoration: BoxDecoration(
        color: Colors.deepPurple.shade500,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'TODAY\'S COSMIC COMEDY',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
          SizedBox(height: 15),
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
              Text(
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
                    _funnyAstroQuote = _astroQuotes[Random().nextInt(_astroQuotes.length)];
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
    final primaryColor = Colors.deepPurple.shade800;
    final cardColor = Color(0xFF1E1E1E);
    final textColor = Colors.white;
    final secondaryTextColor = Colors.grey[400];
    final accentColor = Colors.deepOrange;

    return Expanded(
      child: Container(
        margin: EdgeInsets.fromLTRB(20, 0, 20, 0), // Removed bottom margin
        decoration: BoxDecoration(
          color: Colors.deepPurple.shade500,
          borderRadius: BorderRadius.vertical(
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
                  Text(
                    'Your Cosmic Questions',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(
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
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.deepPurple.shade800,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 4,
                      ),
                      title: Text(
                        chat['title']!,
                        style: TextStyle(
                          color: textColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      trailing: Text(
                        chat['date']!,
                        style: TextStyle(
                          color: secondaryTextColor,
                          fontSize: 12,
                        ),
                      ),
                      onTap: () {},
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
          ],
        ),

      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Colors.deepPurple.shade800;
    final backgroundColor = Colors.deepPurple.shade800;
    final iconBgColor = Colors.deepPurple.shade500;
    final textColor = Colors.white;

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
                  SizedBox(width: 15),
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
                  Navigator.pushNamed(context, '/chat');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrange.shade900,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 1,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.chat, size: 24, color: Colors.white),
                    SizedBox(width: 12),
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
            SizedBox(height: 20)

            /* Premium Button (Commented for future use)
            Container(
              margin: EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  backgroundColor: primaryColor,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  side: BorderSide(color: primaryColor, width: 1.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.workspace_premium, size: 22),
                    SizedBox(width: 12),
                    Text(
                      'Unlock Cosmic Secrets',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
            */
          ],
        ),
      ),
    );
  }
}