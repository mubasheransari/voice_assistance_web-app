import 'package:flutter/material.dart';
import 'package:voice_assistant_project/Screens/islamic_calender_screen.dart';
import 'package:voice_assistant_project/Screens/scan_points_screen.dart';
import 'package:voice_assistant_project/Screens/send_points_screen.dart';
import 'package:voice_assistant_project/Screens/voice_assistant_screen.dart';
import 'package:voice_assistant_project/Theme/theme.dart';
import '../main.dart';
import 'prayer_times_screen.dart';

class HomeScreen extends StatelessWidget {
  static const String routeName = '/home';

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSearch(),
              const SizedBox(height: 14),
              _buildPointsCard(),
              const SizedBox(height: 20),
              const Text(
                'What do you want to do?',
                style: TextStyle(
                  fontFamily: AppTheme.fontFamily,
                  fontSize: 16,
                  color: Color(0xFF3E1E69),
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),
              _buildActionsRow(context),
              const SizedBox(height: 24),
              _buildQuickTiles(context),
              const SizedBox(height: 24),
              _buildRecentActivity(),
            ],
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      titleSpacing: 16,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'Good to see you 👋',
            style: TextStyle(
              fontFamily: AppTheme.fontFamily,
              fontSize: 16,
              color: AppTheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 3),
          Row(
            children: [
              Icon(Icons.location_on_rounded,
                  size: 15, color: AppTheme.primary),
              SizedBox(width: 4),
              Text(
                'Karachi, Pakistan',
                style: TextStyle(
                  fontFamily: AppTheme.fontFamily,
                  fontSize: 12.5,
                  color: Color(0xFF75748A),
                ),
              ),
            ],
          ),
        ],
      ),
      // actions: const [
      //   Padding(
      //     padding: EdgeInsets.only(right: 16),
      //     child: CircleAvatar(
      //       radius: 18,
      //       backgroundImage: AssetImage('assets/avatar.png'),
      //     ),
      //   ),
      // ],
    );
  }

  Widget _buildSearch() {
    return Material(
      elevation: 0,
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      child: TextField(
        style: const TextStyle(fontFamily: AppTheme.fontFamily),
        decoration: InputDecoration(
          hintText: 'Search places or partners...',
          hintStyle: TextStyle(
            fontFamily: AppTheme.fontFamily,
            color: Colors.grey.shade500,
            fontSize: 13.5,
          ),
          border: InputBorder.none,
          prefixIcon: const Icon(Icons.search_rounded),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
        ),
      ),
    );
  }

  Widget _buildPointsCard() {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppTheme.primary, AppTheme.accent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.12),
            blurRadius: 18,
            offset: const Offset(0, 10),
          )
        ],
      ),
      padding: const EdgeInsets.all(18),
      child: Row(
        children: [
          Container(
            height: 44,
            width: 44,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(.18),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.stars_rounded, color: Colors.white),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: ValueListenableBuilder<int>(
              valueListenable: rewardPoints,
              builder: (context, value, _) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Rewards balance',
                      style: TextStyle(
                        fontFamily: AppTheme.fontFamily,
                        fontSize: 12.5,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$value pts',
                      style: const TextStyle(
                        fontFamily: AppTheme.fontFamily,
                        fontSize: 22,
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: const [
              Text(
                'Scan to earn more',
                style: TextStyle(
                  fontFamily: AppTheme.fontFamily,
                  fontSize: 11.5,
                  color: Colors.white70,
                ),
              ),
              SizedBox(height: 4),
              Icon(Icons.qr_code_scanner_rounded,
                  color: Colors.white, size: 24),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionsRow(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _ActionCard(
            title: 'Scan & earn',
            subtitle: 'Collect points instantly',
            icon: Icons.qr_code_scanner_rounded,
            color: AppTheme.primary,
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=> ScanPointsScreen()));
            },
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _ActionCard(
            title: 'Send points',
            subtitle: 'Share with friends',
            icon: Icons.send_rounded,
            color: AppTheme.green,
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=> SendPointsScreen()));
            },
          ),
        ),
      ],
    );
  }

  Widget _buildQuickTiles(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text(
              'Explore more',
              style: TextStyle(
                fontFamily: AppTheme.fontFamily,
                fontSize: 15.5,
                fontWeight: FontWeight.w700,
                color: Color(0xFF3E1E69),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _QuickTile(
                icon: Icons.mic_none_rounded,
                title: 'Survey',
                subtitle: 'Survey to earn bonus points',
                onTap: () {
               Navigator.push(context, MaterialPageRoute(builder: (context)=> VoiceAssistantChatScreen()));

                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _QuickTile(
                icon: Icons.wb_twighlight,
                title: 'Prayer times',
                subtitle: 'Stay on schedule',
                onTap: () {
                       Navigator.push(context, MaterialPageRoute(builder: (context)=> PrayerTimesScreen()));
                },
              ),
            ),
          ],
        ),
           const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _QuickTile(
                icon: Icons.calendar_month,
                title: 'Calendar',
                subtitle: 'Islamic Calendar',
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> IslamicCalendarScreen()));
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _QuickTile(
                icon: Icons.person,
                title: 'Profile',
                subtitle: 'View Profile Details',
                onTap: () {
                 // Navigator.push(context, MaterialPageRoute(builder: (context)=> PrayerTimesScreen()));
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRecentActivity() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Recent activity',
          style: TextStyle(
            fontFamily: AppTheme.fontFamily,
            fontSize: 15.5,
            fontWeight: FontWeight.w700,
            color: Color(0xFF3E1E69),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding:
              const EdgeInsets.symmetric(vertical: 24, horizontal: 18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.02),
                blurRadius: 18,
                offset: const Offset(0, 12),
              )
            ],
          ),
          child: Column(
            children: const [
              Icon(Icons.inbox_rounded,
                  size: 40, color: Color(0xFF75748A)),
              SizedBox(height: 8),
              Text(
                'No activity yet',
                style: TextStyle(
                  fontFamily: AppTheme.fontFamily,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Scan a code or send points to see it here.',
                style: TextStyle(
                  fontFamily: AppTheme.fontFamily,
                  fontSize: 12.5,
                  color: Color(0xFF75748A),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ActionCard extends StatelessWidget {
  const _ActionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
    required this.color,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          height: 110,
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 34,
                width: 34,
                decoration: BoxDecoration(
                  color: color.withOpacity(.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color),
              ),
              const Spacer(),
              Text(
                title,
                style: const TextStyle(
                  fontFamily: AppTheme.fontFamily,
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF3E1E69),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(
                  fontFamily: AppTheme.fontFamily,
                  fontSize: 11.5,
                  color: Color(0xFF75748A),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuickTile extends StatelessWidget {
  const _QuickTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                height: 34,
                width: 34,
                decoration: BoxDecoration(
                  color: AppTheme.primary.withOpacity(.08),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: AppTheme.primary),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontFamily: AppTheme.fontFamily,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontFamily: AppTheme.fontFamily,
                        fontSize: 11.5,
                        color: Color(0xFF75748A),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
