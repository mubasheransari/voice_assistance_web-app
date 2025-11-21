import 'package:flutter/material.dart';
import 'package:voice_assistant_project/Theme/theme.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int myPoints = 120;
  int housePoints = 300;
  int friendsPoints = 80;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(' Loyalty'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _PointsSummaryCard(
              myPoints: myPoints,
              housePoints: housePoints,
              friendsPoints: friendsPoints,
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView(
                children: [
                  _MenuTile(
                    icon: Icons.checklist_rounded,
                    title: 'Feedback Survey',
                    subtitle: 'Answer & earn loyalty points',
                    onTap: () async {
                      // ❌ OLD:
                      // final earned = await Navigator.pushNamed<int>(context, '/survey');

                      // ✅ NEW:
                      final earned =
                          await Navigator.pushNamed(context, '/survey') as int?;

                      if (earned != null && earned > 0) {
                        setState(() => myPoints += earned);
                      }
                    },
                  ),
                  _MenuTile(
                    icon: Icons.group_add_rounded,
                    title: 'Share Loyalty Points',
                    subtitle: 'Same house or friends',
                    onTap: () async {
                      // ❌ OLD:
                      // final result = await Navigator.pushNamed<Map<String, int>>(
                      //   context,
                      //   '/points',
                      //   arguments: {...},
                      // );

                      // ✅ NEW:
                      final result = await Navigator.pushNamed(
                        context,
                        '/points',
                        arguments: {
                          'myPoints': myPoints,
                          'housePoints': housePoints,
                          'friendsPoints': friendsPoints,
                        },
                      ) as Map<String, int>?;

                      if (result != null) {
                        setState(() {
                          myPoints = result['myPoints'] ?? myPoints;
                          housePoints = result['housePoints'] ?? housePoints;
                          friendsPoints =
                              result['friendsPoints'] ?? friendsPoints;
                        });
                      }
                    },
                  ),
                  _MenuTile(
                    icon: Icons.access_time_rounded,
                    title: 'Namaz Times (Pakistan)',
                    subtitle: 'City-wise prayer times',
                    onTap: () {
                      Navigator.pushNamed(context, '/prayers');
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}


// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   int myPoints = 120;
//   int housePoints = 300;
//   int friendsPoints = 80;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(' Loyalty'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             _PointsSummaryCard(
//               myPoints: myPoints,
//               housePoints: housePoints,
//               friendsPoints: friendsPoints,
//             ),
//             const SizedBox(height: 24),
//             Expanded(
//               child: ListView(
//                 children: [
//                   _MenuTile(
//                     icon: Icons.checklist_rounded,
//                     title: 'Feedback Survey',
//                     subtitle: 'Answer & earn loyalty points',
//                     onTap: () async {
//                       final earned = await Navigator.pushNamed<int>(
//                         context,
//                         '/survey',
//                       );
//                       if (earned != null && earned > 0) {
//                         setState(() => myPoints += earned);
//                       }
//                     },
//                   ),
//                   _MenuTile(
//                     icon: Icons.group_add_rounded,
//                     title: 'Share Loyalty Points',
//                     subtitle: 'Same house or friends',
//                     onTap: () async {
//                       final result = await Navigator.pushNamed<Map<String, int>>(
//                         context,
//                         '/points',
//                         arguments: {
//                           'myPoints': myPoints,
//                           'housePoints': housePoints,
//                           'friendsPoints': friendsPoints,
//                         },
//                       );

//                       if (result != null) {
//                         setState(() {
//                           myPoints = result['myPoints'] ?? myPoints;
//                           housePoints = result['housePoints'] ?? housePoints;
//                           friendsPoints = result['friendsPoints'] ?? friendsPoints;
//                         });
//                       }
//                     },
//                   ),
//                   _MenuTile(
//                     icon: Icons.access_time_rounded,
//                     title: 'Namaz Times (Pakistan)',
//                     subtitle: 'City-wise prayer times',
//                     onTap: () {
//                       Navigator.pushNamed(context, '/prayers');
//                     },
//                   ),
//                 ],
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

class _PointsSummaryCard extends StatelessWidget {
  final int myPoints;
  final int housePoints;
  final int friendsPoints;

  const _PointsSummaryCard({
    required this.myPoints,
    required this.housePoints,
    required this.friendsPoints,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Your Loyalty Wallet',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppTheme.primary,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _chip('My Points', myPoints.toString(), Icons.star),
                const SizedBox(width: 8),
                _chip('Same House', housePoints.toString(), Icons.home_rounded),
                const SizedBox(width: 8),
                _chip('Friends', friendsPoints.toString(), Icons.people_alt_rounded),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _chip(String label, String value, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.red.shade50,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Icon(icon, size: 20, color: AppTheme.primary),
            const SizedBox(width: 6),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey.shade700,
                    )),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.primary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _MenuTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.red.shade50,
          child: Icon(icon, color: AppTheme.primary),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
        onTap: onTap,
      ),
    );
  }
}
