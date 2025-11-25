import 'package:flutter/material.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:voice_assistant_project/Theme/theme.dart';



class IslamicCalendarScreen extends StatefulWidget {
  const IslamicCalendarScreen({super.key});

  @override
  State<IslamicCalendarScreen> createState() => _IslamicCalendarScreenState();
}

class _IslamicCalendarScreenState extends State<IslamicCalendarScreen> {
  late HijriCalendar _todayHijri;
  late HijriCalendar _displayHijri;

  // Always English month names
  static const List<String> _hijriMonthsEn = [
    'Muharram',
    'Safar',
    'Rabiʿ al-Awwal',
    'Rabiʿ al-Thani',
    'Jumada al-Ula',
    'Jumada al-Thani',
    'Rajab',
    'Shaʿban',
    'Ramadan',
    'Shawwal',
    'Dhul-Qaʿdah',
    'Dhul-Hijjah',
  ];

  @override
  void initState() {
    super.initState();

    // Force English locale in package (just in case we ever use its names)
    HijriCalendar.setLocal('en');

    _todayHijri = HijriCalendar.now();
    _displayHijri = HijriCalendar.now();
  }

  // ---------- MONTH NAV ----------

  void _goPrevMonth() {
    int y = _displayHijri.hYear;
    int m = _displayHijri.hMonth - 1;
    if (m < 1) {
      m = 12;
      y -= 1;
    }

    final helper = HijriCalendar();
    final DateTime g = helper.hijriToGregorian(y, m, 1);

    setState(() {
      _displayHijri = HijriCalendar.fromDate(g);
    });
  }

  void _goNextMonth() {
    int y = _displayHijri.hYear;
    int m = _displayHijri.hMonth + 1;
    if (m > 12) {
      m = 1;
      y += 1;
    }

    final helper = HijriCalendar();
    final DateTime g = helper.hijriToGregorian(y, m, 1);

    setState(() {
      _displayHijri = HijriCalendar.fromDate(g);
    });
  }

  String _monthTitle() {
    final index = (_displayHijri.hMonth - 1).clamp(0, 11);
    final monthName = _hijriMonthsEn[index];
    return '$monthName ${_displayHijri.hYear} AH';
  }

  bool _isToday(int hDay) {
    return _displayHijri.hYear == _todayHijri.hYear &&
        _displayHijri.hMonth == _todayHijri.hMonth &&
        hDay == _todayHijri.hDay;
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
          'Islamic calendar',
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeaderCard(),
              const SizedBox(height: 16),
              _buildMonthCard(),
              const SizedBox(height: 20),
              _buildLegend(),
            ],
          ),
        ),
      ),
    );
  }

  // ---------- HEADER WITH TODAY ----------

  Widget _buildHeaderCard() {
    final todayG = DateTime.now();

    final int idx = (_todayHijri.hMonth - 1).clamp(0, 11);
    final String todayMonthName = _hijriMonthsEn[idx];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.03),
            blurRadius: 18,
            offset: const Offset(0, 10),
          )
        ],
      ),
      child: Row(
        children: [
          Container(
            height: 42,
            width: 42,
            decoration: BoxDecoration(
              color: AppTheme.primary.withOpacity(.08),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.calendar_month_rounded,
              color: AppTheme.primary,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Today: '
                  '${_todayHijri.hDay} $todayMonthName ${_todayHijri.hYear} AH',
                  style: const TextStyle(
                    fontFamily: AppTheme.fontFamily,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF3E1E69),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Today: '
                  '${todayG.day}/${todayG.month}/${todayG.year}',
                  style: const TextStyle(
                    fontFamily: AppTheme.fontFamily,
                    fontSize: 12,
                    color: Color(0xFF75748A),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------- MONTH CARD ----------

  Widget _buildMonthCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.03),
            blurRadius: 18,
            offset: const Offset(0, 10),
          )
        ],
      ),
      child: Column(
        children: [
          // Month title + arrows
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                splashRadius: 22,
                onPressed: _goPrevMonth,
                icon: const Icon(
                  Icons.chevron_left_rounded,
                  color: AppTheme.primary,
                ),
              ),
              Column(
                children: [
                  Text(
                    _monthTitle(),
                    style: const TextStyle(
                      fontFamily: AppTheme.fontFamily,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF3E1E69),
                    ),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    'Umm al-Qura calendar',
                    style: TextStyle(
                      fontFamily: AppTheme.fontFamily,
                      fontSize: 11.5,
                      color: Color(0xFF75748A),
                    ),
                  ),
                ],
              ),
              IconButton(
                splashRadius: 22,
                onPressed: _goNextMonth,
                icon: const Icon(
                  Icons.chevron_right_rounded,
                  color: AppTheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _buildWeekdayHeader(),
          const SizedBox(height: 8),
          _buildMonthDays(),
        ],
      ),
    );
  }

  Widget _buildWeekdayHeader() {
    // English weekday labels
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: days
          .map(
            (d) => Expanded(
              child: Center(
                child: Text(
                  d,
                  style: const TextStyle(
                    fontFamily: AppTheme.fontFamily,
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF9A8EB5),
                  ),
                ),
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildMonthDays() {
    final int hYear = _displayHijri.hYear;
    final int hMonth = _displayHijri.hMonth;

    final helper = HijriCalendar();

    // Gregorian of 1st day of this Hijri month
    final DateTime firstG = helper.hijriToGregorian(hYear, hMonth, 1);

    // Fresh instance for month length to avoid late init bugs
    final HijriCalendar monthHelper = HijriCalendar.fromDate(firstG);
    final int totalDays = monthHelper.lengthOfMonth;

    final int firstWeekday = firstG.weekday; // 1..7, Monday=1
    final int leadingBlanks = firstWeekday - 1;

    final List<Widget> cells = [];

    for (int i = 0; i < leadingBlanks; i++) {
      cells.add(const SizedBox.shrink());
    }

    for (int d = 1; d <= totalDays; d++) {
      final bool isToday = _isToday(d);

      cells.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 3),
          child: _DayCell(
            hYear: hYear,
            hMonth: hMonth,
            hDay: d,
            isToday: isToday,
          ),
        ),
      );
    }

    while (cells.length % 7 != 0) {
      cells.add(const SizedBox.shrink());
    }

    return GridView.count(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      crossAxisCount: 7,
      mainAxisSpacing: 2,
      crossAxisSpacing: 2,
      childAspectRatio: 0.9,
      children: cells,
    );
  }

  Widget _buildLegend() {
    return Row(
      children: [
        _legendItem(
          color: AppTheme.primary.withOpacity(.15),
          border: AppTheme.primary,
          label: 'Today (Hijri)',
        ),
        const SizedBox(width: 12),
        _legendItem(
          color: Colors.transparent,
          border: const Color(0xFFE0DEEB),
          label: 'Other days',
        ),
      ],
    );
  }

  Widget _legendItem({
    required Color color,
    required Color border,
    required String label,
  }) {
    return Row(
      children: [
        Container(
          height: 18,
          width: 18,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: border, width: 1),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            fontFamily: AppTheme.fontFamily,
            fontSize: 11.5,
            color: Color(0xFF75748A),
          ),
        ),
      ],
    );
  }
}

class _DayCell extends StatelessWidget {
  const _DayCell({
    required this.hYear,
    required this.hMonth,
    required this.hDay,
    required this.isToday,
  });

  final int hYear;
  final int hMonth;
  final int hDay;
  final bool isToday;

  @override
  Widget build(BuildContext context) {
    final helper = HijriCalendar();
    final DateTime g = helper.hijriToGregorian(hYear, hMonth, hDay);

    final bool isFriday = g.weekday == DateTime.friday;

    final Color bg = isToday
        ? AppTheme.primary.withOpacity(.14)
        : Colors.transparent;
    final Color border = isToday
        ? AppTheme.primary
        : const Color(0xFFE0DEEB);

    final Color textColor = isToday
        ? AppTheme.primary
        : (isFriday ? const Color(0xFFE85B7F) : const Color(0xFF3E1E69));

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2),
      padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 2),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: border, width: 1),
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '$hDay',
              style: TextStyle(
                fontFamily: AppTheme.fontFamily,
                fontSize: 13.0,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              // Gregorian date in dd/MM
              '${g.day}/${g.month}',
              style: const TextStyle(
                fontFamily: AppTheme.fontFamily,
                fontSize: 9.5,
                color: Color(0xFF9A8EB5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}





// class IslamicCalendarScreen extends StatefulWidget {
//   const IslamicCalendarScreen({super.key});

//   @override
//   State<IslamicCalendarScreen> createState() => _IslamicCalendarScreenState();
// }

// class _IslamicCalendarScreenState extends State<IslamicCalendarScreen> {
//   late HijriCalendar _todayHijri;
//   late HijriCalendar _displayHijri; // month currently being shown

//   @override
//   void initState() {
//     super.initState();

//     // Use English labels (or 'ar' if you want Arabic names)
//     HijriCalendar.setLocal('en');

//     // Create via now() so internal late fields are initialized
//     _todayHijri = HijriCalendar.now();
//     _displayHijri = HijriCalendar.now();
//   }

//   // ---------- MONTH NAVIGATION ----------

//   void _goPrevMonth() {
//     int y = _displayHijri.hYear;
//     int m = _displayHijri.hMonth - 1;
//     if (m < 1) {
//       m = 12;
//       y -= 1;
//     }

//     final helper = HijriCalendar();
//     final DateTime g = helper.hijriToGregorian(y, m, 1);

//     setState(() {
//       _displayHijri = HijriCalendar.fromDate(g);
//     });
//   }

//   void _goNextMonth() {
//     int y = _displayHijri.hYear;
//     int m = _displayHijri.hMonth + 1;
//     if (m > 12) {
//       m = 1;
//       y += 1;
//     }

//     final helper = HijriCalendar();
//     final DateTime g = helper.hijriToGregorian(y, m, 1);

//     setState(() {
//       _displayHijri = HijriCalendar.fromDate(g);
//     });
//   }

//   String _monthTitle() {
//     final name = _displayHijri.getLongMonthName();
//     return '$name ${_displayHijri.hYear} AH';
//   }

//   bool _isToday(int hDay) {
//     return _displayHijri.hYear == _todayHijri.hYear &&
//         _displayHijri.hMonth == _todayHijri.hMonth &&
//         hDay == _todayHijri.hDay;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF7F8FA),
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         surfaceTintColor: Colors.transparent,
//         elevation: 0,
//         titleSpacing: 16,
//         title: const Text(
//           'Islamic calendar',
//           style: TextStyle(
//             fontFamily: AppTheme.fontFamily,
//             fontSize: 18,
//             color: AppTheme.primary,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//       ),
//       body: SafeArea(
//         top: false,
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               _buildHeaderCard(),
//               const SizedBox(height: 16),
//               _buildMonthCard(),
//               const SizedBox(height: 20),
//               _buildLegend(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   // ---------- HEADER WITH TODAY ----------

//   Widget _buildHeaderCard() {
//     final todayG = DateTime.now();

//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(18),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(.03),
//             blurRadius: 18,
//             offset: const Offset(0, 10),
//           )
//         ],
//       ),
//       child: Row(
//         children: [
//           Container(
//             height: 42,
//             width: 42,
//             decoration: BoxDecoration(
//               color: AppTheme.primary.withOpacity(.08),
//               borderRadius: BorderRadius.circular(14),
//             ),
//             child: const Icon(
//               Icons.calendar_month_rounded,
//               color: AppTheme.primary,
//             ),
//           ),
//           const SizedBox(width: 14),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'Today (Hijri): '
//                   '${_todayHijri.hDay} ${_todayHijri.getLongMonthName()} ${_todayHijri.hYear} AH',
//                   style: const TextStyle(
//                     fontFamily: AppTheme.fontFamily,
//                     fontSize: 13,
//                     fontWeight: FontWeight.w600,
//                     color: Color(0xFF3E1E69),
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   'Today (Gregorian): '
//                   '${todayG.day}/${todayG.month}/${todayG.year}',
//                   style: const TextStyle(
//                     fontFamily: AppTheme.fontFamily,
//                     fontSize: 12,
//                     color: Color(0xFF75748A),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // ---------- MONTH CARD ----------

//   Widget _buildMonthCard() {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(.03),
//             blurRadius: 18,
//             offset: const Offset(0, 10),
//           )
//         ],
//       ),
//       child: Column(
//         children: [
//           // Month title + arrows
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               IconButton(
//                 splashRadius: 22,
//                 onPressed: _goPrevMonth,
//                 icon: const Icon(
//                   Icons.chevron_left_rounded,
//                   color: AppTheme.primary,
//                 ),
//               ),
//               Column(
//                 children: [
//                   Text(
//                     _monthTitle(),
//                     style: const TextStyle(
//                       fontFamily: AppTheme.fontFamily,
//                       fontSize: 16,
//                       fontWeight: FontWeight.w700,
//                       color: Color(0xFF3E1E69),
//                     ),
//                   ),
//                   const SizedBox(height: 2),
//                   const Text(
//                     'Umm al-Qura calendar',
//                     style: TextStyle(
//                       fontFamily: AppTheme.fontFamily,
//                       fontSize: 11.5,
//                       color: Color(0xFF75748A),
//                     ),
//                   ),
//                 ],
//               ),
//               IconButton(
//                 splashRadius: 22,
//                 onPressed: _goNextMonth,
//                 icon: const Icon(
//                   Icons.chevron_right_rounded,
//                   color: AppTheme.primary,
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 10),
//           _buildWeekdayHeader(),
//           const SizedBox(height: 8),
//           _buildMonthDays(),
//         ],
//       ),
//     );
//   }

//   Widget _buildWeekdayHeader() {
//     const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: days
//           .map(
//             (d) => Expanded(
//               child: Center(
//                 child: Text(
//                   d,
//                   style: const TextStyle(
//                     fontFamily: AppTheme.fontFamily,
//                     fontSize: 11.5,
//                     fontWeight: FontWeight.w600,
//                     color: Color(0xFF9A8EB5),
//                   ),
//                 ),
//               ),
//             ),
//           )
//           .toList(),
//     );
//   }

//   Widget _buildMonthDays() {
//     final int hYear = _displayHijri.hYear;
//     final int hMonth = _displayHijri.hMonth;

//     // Helper only for conversion
//     final helper = HijriCalendar();

//     // Gregorian date of 1st day of this Hijri month
//     final DateTime firstG = helper.hijriToGregorian(hYear, hMonth, 1);

//     // Build a FRESH HijriCalendar for this month to safely read lengthOfMonth
//     final HijriCalendar monthHelper = HijriCalendar.fromDate(firstG);
//     final int totalDays = monthHelper.lengthOfMonth;

//     // Monday = 1 ... Sunday = 7
//     final int firstWeekday = firstG.weekday; // 1..7
//     final int leadingBlanks = firstWeekday - 1; // 0 for Mon, 6 for Sun

//     final List<Widget> cells = [];

//     // empty cells before day 1
//     for (int i = 0; i < leadingBlanks; i++) {
//       cells.add(const SizedBox.shrink());
//     }

//     // actual days
//     for (int d = 1; d <= totalDays; d++) {
//       final bool isToday = _isToday(d);

//       cells.add(
//         Padding(
//           padding: const EdgeInsets.symmetric(vertical: 3),
//           child: _DayCell(
//             hYear: hYear,
//             hMonth: hMonth,
//             hDay: d,
//             isToday: isToday,
//           ),
//         ),
//       );
//     }

//     // Pad to complete weeks
//     while (cells.length % 7 != 0) {
//       cells.add(const SizedBox.shrink());
//     }

//     return GridView.count(
//       physics: const NeverScrollableScrollPhysics(),
//       shrinkWrap: true,
//       crossAxisCount: 7,
//       mainAxisSpacing: 2,
//       crossAxisSpacing: 2,
//       // you can tweak this if you want cells slightly taller/shorter
//       childAspectRatio: 0.9,
//       children: cells,
//     );
//   }

//   Widget _buildLegend() {
//     return Row(
//       children: [
//         _legendItem(
//           color: AppTheme.primary.withOpacity(.15),
//           border: AppTheme.primary,
//           label: 'Today (Hijri)',
//         ),
//         const SizedBox(width: 12),
//         _legendItem(
//           color: Colors.transparent,
//           border: const Color(0xFFE0DEEB),
//           label: 'Other days',
//         ),
//       ],
//     );
//   }

//   Widget _legendItem({
//     required Color color,
//     required Color border,
//     required String label,
//   }) {
//     return Row(
//       children: [
//         Container(
//           height: 18,
//           width: 18,
//           decoration: BoxDecoration(
//             color: color,
//             borderRadius: BorderRadius.circular(8),
//             border: Border.all(color: border, width: 1),
//           ),
//         ),
//         const SizedBox(width: 6),
//         Text(
//           label,
//           style: const TextStyle(
//             fontFamily: AppTheme.fontFamily,
//             fontSize: 11.5,
//             color: Color(0xFF75748A),
//           ),
//         ),
//       ],
//     );
//   }
// }

// class _DayCell extends StatelessWidget {
//   const _DayCell({
//     required this.hYear,
//     required this.hMonth,
//     required this.hDay,
//     required this.isToday,
//   });

//   final int hYear;
//   final int hMonth;
//   final int hDay;
//   final bool isToday;

//   @override
//   Widget build(BuildContext context) {
//     final helper = HijriCalendar();
//     final DateTime g = helper.hijriToGregorian(hYear, hMonth, hDay);

//     final bool isFriday = g.weekday == DateTime.friday;

//     final Color bg = isToday
//         ? AppTheme.primary.withOpacity(.14)
//         : Colors.transparent;
//     final Color border = isToday
//         ? AppTheme.primary
//         : const Color(0xFFE0DEEB);

//     final Color textColor = isToday
//         ? AppTheme.primary
//         : (isFriday ? const Color(0xFFE85B7F) : const Color(0xFF3E1E69));

//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 2),
//       padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 2),
//       decoration: BoxDecoration(
//         color: bg,
//         borderRadius: BorderRadius.circular(10),
//         border: Border.all(color: border, width: 1),
//       ),
//       child: FittedBox(
//         fit: BoxFit.scaleDown,
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Text(
//               '$hDay',
//               style: TextStyle(
//                 fontFamily: AppTheme.fontFamily,
//                 fontSize: 13.0,
//                 fontWeight: FontWeight.w600,
//                 color: textColor,
//               ),
//             ),
//             const SizedBox(height: 2),
//             Text(
//               '${g.day}/${g.month}',
//               style: const TextStyle(
//                 fontFamily: AppTheme.fontFamily,
//                 fontSize: 9.5,
//                 color: Color(0xFF9A8EB5),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
