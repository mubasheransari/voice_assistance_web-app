import 'package:flutter/material.dart';
import 'package:voice_assistant_project/Theme/theme.dart';


import '../services/prayer_times_service.dart';

class PrayerTimesScreen extends StatefulWidget {
  static const String routeName = '/prayer-times';

  const PrayerTimesScreen({super.key});

  @override
  State<PrayerTimesScreen> createState() => _PrayerTimesScreenState();
}

class _PrayerTimesScreenState extends State<PrayerTimesScreen> {
  final _service = PrayerTimesService();

  // You can make these dynamic via dropdowns / textfields
  String _selectedCity = 'Karachi';
  String _selectedCountry = 'Pakistan';

  bool _loading = true;
  String? _error;
  PrayerTimes? _times;

  @override
  void initState() {
    super.initState();
    _loadTimes();
  }

  Future<void> _loadTimes() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final t = await _service.getTodayPrayerTimes(
        city: _selectedCity,
        country: _selectedCountry,
        method: 2, // ISNA (choose what you want)
      );
      if (!mounted) return;
      setState(() {
        _times = t;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = 'Failed to load prayer times';
        _loading = false;
      });
    }
  }

  void _onChangeCity(String city, String country) {
    setState(() {
      _selectedCity = city;
      _selectedCountry = country;
    });
    _loadTimes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        titleSpacing: 16,
        title: const Text(
          'Prayer times',
          style: TextStyle(
            fontFamily: AppTheme.fontFamily,
            fontSize: 18,
            color: AppTheme.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        top: false,
        child: RefreshIndicator(
          onRefresh: _loadTimes,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildCitySelector(),
                const SizedBox(height: 16),
                if (_loading) ...[
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: 40),
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ] else if (_error != null) ...[
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 40),
                      child: Text(
                        _error!,
                        style: const TextStyle(
                          fontFamily: AppTheme.fontFamily,
                          color: Colors.redAccent,
                        ),
                      ),
                    ),
                  ),
                ] else if (_times != null) ...[
                  _buildTodaySummary(),
                  const SizedBox(height: 18),
                  _buildTimesCard(_times!),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCitySelector() {
    // For now simple dropdowns; you can replace by search screen later
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.03),
            blurRadius: 16,
            offset: const Offset(0, 10),
          )
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.location_on_rounded,
              color: AppTheme.primary, size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Current city',
                  style: TextStyle(
                    fontFamily: AppTheme.fontFamily,
                    fontSize: 12,
                    color: Color(0xFF75748A),
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          isExpanded: true,
                          value: _selectedCity,
                          icon: const Icon(Icons.expand_more_rounded),
                          style: const TextStyle(
                            fontFamily: AppTheme.fontFamily,
                            fontSize: 14.5,
                            color: Color(0xFF3E1E69),
                            fontWeight: FontWeight.w600,
                          ),
                          items: const [
                            'Karachi',
                            'Lahore',
                            'Islamabad',
                            'Melbourne',
                            'Sydney',
                          ].map((c) {
                            return DropdownMenuItem<String>(
                              value: c,
                              child: Text(c),
                            );
                          }).toList(),
                          onChanged: (v) {
                            if (v == null) return;
                            // quick mapping country for demo
                            String country = 'Pakistan';
                            if (v == 'Melbourne' || v == 'Sydney') {
                              country = 'Australia';
                            }
                            _onChangeCity(v, country);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTodaySummary() {
    final now = DateTime.now();
    final dateStr =
        '${now.day.toString().padLeft(2, '0')} '
        '${_monthName(now.month)} '
        '${now.year}';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 18),
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
      child: Row(
        children: [
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(.18),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.mosque_rounded, color: Colors.white),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Today · $dateStr',
                  style: const TextStyle(
                    fontFamily: AppTheme.fontFamily,
                    fontSize: 12.5,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _selectedCity,
                  style: const TextStyle(
                    fontFamily: AppTheme.fontFamily,
                    fontSize: 19,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                Text(
                  _selectedCountry,
                  style: const TextStyle(
                    fontFamily: AppTheme.fontFamily,
                    fontSize: 12.5,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimesCard(PrayerTimes t) {
    final entries = [
      _PrayerEntry('Fajr', t.fajr, Icons.nights_stay_rounded),
      _PrayerEntry('Sunrise', t.sunrise, Icons.wb_twighlight),
      _PrayerEntry('Dhuhr', t.dhuhr, Icons.wb_sunny_rounded),
      _PrayerEntry('Asr', t.asr, Icons.wb_sunny_outlined),
      _PrayerEntry('Maghrib', t.maghrib, Icons.nightlight_round),
      _PrayerEntry('Isha', t.isha, Icons.dark_mode_rounded),
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 14),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Today’s prayer times',
            style: TextStyle(
              fontFamily: AppTheme.fontFamily,
              fontSize: 15.5,
              fontWeight: FontWeight.w700,
              color: Color(0xFF3E1E69),
            ),
          ),
          const SizedBox(height: 12),
          for (final e in entries) ...[
            _PrayerRow(entry: e),
            if (e != entries.last)
              const Divider(
                height: 18,
                color: Color(0xFFF1EEFA),
              ),
          ],
        ],
      ),
    );
  }

  String _monthName(int m) {
    const names = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return names[m - 1];
  }
}

class _PrayerEntry {
  final String label;
  final String time;
  final IconData icon;

  _PrayerEntry(this.label, this.time, this.icon);
}

class _PrayerRow extends StatelessWidget {
  final _PrayerEntry entry;

  const _PrayerRow({required this.entry});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 32,
          width: 32,
          decoration: BoxDecoration(
            color: AppTheme.primary.withOpacity(.06),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(entry.icon, size: 18, color: AppTheme.primary),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            entry.label,
            style: const TextStyle(
              fontFamily: AppTheme.fontFamily,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF3E1E69),
            ),
          ),
        ),
        Text(
          entry.time,
          style: const TextStyle(
            fontFamily: AppTheme.fontFamily,
            fontSize: 14,
            color: Color(0xFF75748A),
          ),
        ),
      ],
    );
  }
}


// class PrayerTimesScreen extends StatelessWidget {
//   static const String routeName = '/prayerTimes';

//   const PrayerTimesScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final prayers = [
//       ('Fajr', '05:10 AM'),
//       ('Dhuhr', '12:30 PM'),
//       ('Asr', '03:45 PM'),
//       ('Maghrib', '06:20 PM'),
//       ('Isha', '07:45 PM'),
//     ];

//     return Scaffold(
//       appBar: AppBar(
//         titleSpacing: 16,
//         title: const Text(
//           'Prayer times',
//           style: TextStyle(
//             fontFamily: AppTheme.fontFamily,
//             fontWeight: FontWeight.w600,
//             color: AppTheme.primary,
//           ),
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(18),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'Today in your city',
//               style: TextStyle(
//                 fontFamily: AppTheme.fontFamily,
//                 fontSize: 16,
//                 fontWeight: FontWeight.w700,
//                 color: Color(0xFF3E1E69),
//               ),
//             ),
//             const SizedBox(height: 10),
//             Expanded(
//               child: ListView.separated(
//                 itemCount: prayers.length,
//                 separatorBuilder: (_, __) => const SizedBox(height: 10),
//                 itemBuilder: (_, i) {
//                   final (name, time) = prayers[i];
//                   return Material(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(18),
//                     child: ListTile(
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(18),
//                       ),
//                       leading: Container(
//                         height: 38,
//                         width: 38,
//                         decoration: BoxDecoration(
//                           color: AppTheme.primary.withOpacity(.08),
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         child: const Icon(Icons.wb_twighlight,
//                             color: AppTheme.primary),
//                       ),
//                       title: Text(
//                         name,
//                         style: const TextStyle(
//                           fontFamily: AppTheme.fontFamily,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                       subtitle: Text(
//                         time,
//                         style: const TextStyle(
//                           fontFamily: AppTheme.fontFamily,
//                           fontSize: 12.5,
//                           color: Color(0xFF75748A),
//                         ),
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }



// // class PrayerTimesScreen extends StatefulWidget {
// //   const PrayerTimesScreen({super.key});

// //   @override
// //   State<PrayerTimesScreen> createState() => _PrayerTimesScreenState();
// // }

// // class _PrayerTimesScreenState extends State<PrayerTimesScreen> {
// //   final List<String> _cities = [
// //     'Karachi',
// //     'Lahore',
// //     'Islamabad',
// //     'Peshawar',
// //     'Quetta',
// //   ];

// //   String _selectedCity = 'Karachi';

// //   late Map<String, PrayerTimes> _currentTimes;

// //   @override
// //   void initState() {
// //     super.initState();
// //     _currentTimes = _getTimesForCity(_selectedCity);
// //   }

// //   Map<String, PrayerTimes> _getTimesForCity(String city) {
// //     // Dummy sample data. Replace with API integration later.
// //     switch (city) {
// //       case 'Lahore':
// //         return {
// //           'Fajr': PrayerTimes(start: '04:15', end: '05:35'),
// //           'Dhuhr': PrayerTimes(start: '12:10', end: '15:30'),
// //           'Asr': PrayerTimes(start: '15:45', end: '18:10'),
// //           'Maghrib': PrayerTimes(start: '18:20', end: '19:30'),
// //           'Isha': PrayerTimes(start: '19:45', end: '04:00'),
// //         };
// //       case 'Islamabad':
// //         return {
// //           'Fajr': PrayerTimes(start: '04:10', end: '05:30'),
// //           'Dhuhr': PrayerTimes(start: '12:05', end: '15:20'),
// //           'Asr': PrayerTimes(start: '15:35', end: '18:05'),
// //           'Maghrib': PrayerTimes(start: '18:15', end: '19:25'),
// //           'Isha': PrayerTimes(start: '19:40', end: '03:55'),
// //         };
// //       default: // Karachi / others
// //         return {
// //           'Fajr': PrayerTimes(start: '04:30', end: '05:50'),
// //           'Dhuhr': PrayerTimes(start: '12:30', end: '15:40'),
// //           'Asr': PrayerTimes(start: '15:55', end: '18:25'),
// //           'Maghrib': PrayerTimes(start: '18:35', end: '19:40'),
// //           'Isha': PrayerTimes(start: '19:55', end: '04:15'),
// //         };
// //     }
// //   }

// //   void _onCityChange(String? city) {
// //     if (city == null) return;
// //     setState(() {
// //       _selectedCity = city;
// //       _currentTimes = _getTimesForCity(city);
// //     });
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     final keys = _currentTimes.keys.toList();

// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text('Namaz Times'),
// //       ),
// //       body: Padding(
// //         padding: const EdgeInsets.all(16),
// //         child: Column(
// //           children: [
// //             Card(
// //               child: Padding(
// //                 padding:
// //                     const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
// //                 child: Row(
// //                   children: [
// //                     const Icon(Icons.location_city_rounded,
// //                         color: AppTheme.primary),
// //                     const SizedBox(width: 12),
// //                     Expanded(
// //                       child: DropdownButtonFormField<String>(
// //                         value: _selectedCity,
// //                         decoration: const InputDecoration(
// //                           labelText: 'Select City (Pakistan)',
// //                         ),
// //                         items: _cities
// //                             .map(
// //                               (c) => DropdownMenuItem(
// //                                 value: c,
// //                                 child: Text(c),
// //                               ),
// //                             )
// //                             .toList(),
// //                         onChanged: _onCityChange,
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //             ),
// //             const SizedBox(height: 16),
// //             Expanded(
// //               child: ListView.builder(
// //                 itemCount: keys.length,
// //                 itemBuilder: (context, index) {
// //                   final name = keys[index];
// //                   final times = _currentTimes[name]!;
// //                   return _PrayerCard(
// //                     name: name,
// //                     start: times.start,
// //                     end: times.end,
// //                   );
// //                 },
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }

// // class PrayerTimes {
// //   final String start;
// //   final String end;

// //   PrayerTimes({required this.start, required this.end});
// // }

// // class _PrayerCard extends StatelessWidget {
// //   final String name;
// //   final String start;
// //   final String end;

// //   const _PrayerCard({
// //     required this.name,
// //     required this.start,
// //     required this.end,
// //   });

// //   @override
// //   Widget build(BuildContext context) {
// //     final isImportant =
// //         name == 'Fajr' || name == 'Maghrib' || name == 'Isha';

// //     return Card(
// //       margin: const EdgeInsets.only(bottom: 10),
// //       child: ListTile(
// //         leading: CircleAvatar(
// //           backgroundColor: isImportant ? AppTheme.primary : Colors.grey,
// //           child: Text(
// //             name[0],
// //             style: TextStyle(
// //               color: isImportant ? Colors.white : AppTheme.primary,
// //               fontWeight: FontWeight.bold,
// //             ),
// //           ),
// //         ),
// //         title: Text(
// //           name,
// //           style: const TextStyle(
// //             fontWeight: FontWeight.w600,
// //           ),
// //         ),
// //         subtitle: Text('Start: $start   •   End: $end'),
// //       ),
// //     );
// //   }
// // }
