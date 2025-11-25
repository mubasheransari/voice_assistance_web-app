import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voice_assistant_project/Theme/theme.dart';
import '../services/prayer_times_service.dart';
import '../Bloc/global_bloc.dart';
import '../Bloc/global_event.dart';
import '../Bloc/global_state.dart';



class PrayerTimesScreen extends StatelessWidget {
  static const String routeName = '/prayer-times';

  const PrayerTimesScreen({super.key});

  String _monthName(int m) {
    const names = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return names[m - 1];
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
        child: BlocBuilder<GlobalBloc, GlobalState>(
          builder: (context, state) {
            final selectedCity = state.city;
            final selectedCountry = state.country;
            final status = state.prayerTimesStatus;
            final times = state.prayerTimes;
            final error = state.error;

            Future<void> _onRefresh() async {
              context.read<GlobalBloc>().add(const LoadPrayerTimes());
            }

            void _onChangeCity(String city, String country) {
              context.read<GlobalBloc>().add(
                    SetPrayerLocation(city: city, country: country),
                  );
            }

            return RefreshIndicator(
              onRefresh: _onRefresh,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildCitySelector(
                      selectedCity: selectedCity,
                      onChangeCity: _onChangeCity,
                    ),
                    const SizedBox(height: 16),

                    if (status == PrayerTimesStatus.loading) ...[
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.only(top: 40),
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    ] else if (status == PrayerTimesStatus.failure &&
                        error != null) ...[
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 40),
                          child: Text(
                            error,
                            style: const TextStyle(
                              fontFamily: AppTheme.fontFamily,
                              color: Colors.redAccent,
                            ),
                          ),
                        ),
                      ),
                    ] else if (status == PrayerTimesStatus.success &&
                        times != null) ...[
                      _buildTodaySummary(
                        selectedCity: selectedCity,
                        selectedCountry: selectedCountry,
                        monthName: _monthName,
                      ),
                      const SizedBox(height: 18),
                      _buildTimesCard(times),
                    ] else ...[
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.only(top: 40),
                          child: Text(
                            'No timings available.',
                            style: TextStyle(
                              fontFamily: AppTheme.fontFamily,
                              color: Color(0xFF75748A),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // ---------- UI parts ----------

  Widget _buildCitySelector({
    required String selectedCity,
    required void Function(String city, String country) onChangeCity,
  }) {
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
          const Icon(
            Icons.location_on_rounded,
            color: AppTheme.primary,
            size: 22,
          ),
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
  child: Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    // decoration: BoxDecoration(
    //   color: const Color(0xFFF5F3FF), // soft lilac background
    //   borderRadius: BorderRadius.circular(999),
    //   border: Border.all(
    //     color: AppTheme.primary.withOpacity(0.18),
    //     width: 1.2,
    //   ),
    // ),
    child: DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        isExpanded: true,
        value: selectedCity,
        icon: const Icon(
          Icons.expand_more_rounded,
          size: 22,
          color: AppTheme.primary,
        ),
        dropdownColor: Colors.white,
        borderRadius: BorderRadius.circular(16),
        style: const TextStyle(
          fontFamily: AppTheme.fontFamily,
          fontSize: 14.5,
          color: Color(0xFF3E1E69),
          fontWeight: FontWeight.w600,
        ),
        items: const [
          'Karachi',
          'Lahore',
          'Islamabad'
        ].map((c) {
          return DropdownMenuItem<String>(
            value: c,
            child: Text(
              c,
              style: const TextStyle(
                fontFamily: AppTheme.fontFamily,
                fontSize: 14,
                color: Color(0xFF3E1E69),
                fontWeight: FontWeight.w500,
              ),
            ),
          );
        }).toList(),
        onChanged: (v) {
          if (v == null) return;
          String country = 'Pakistan';
          if (v == 'Melbourne' || v == 'Sydney') {
            country = 'Australia';
          }
          onChangeCity(v, country);
        },
      ),
    ),
  ),
)

                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTodaySummary({
    required String selectedCity,
    required String selectedCountry,
    required String Function(int) monthName,
  }) {
    final now = DateTime.now();
    final dateStr =
        '${now.day.toString().padLeft(2, '0')} '
        '${monthName(now.month)} '
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
                  selectedCity,
                  style: const TextStyle(
                    fontFamily: AppTheme.fontFamily,
                    fontSize: 19,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                Text(
                  selectedCountry,
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
//   const PrayerTimesScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<GlobalBloc, GlobalState>(
//       builder: (context, state) {
//         if (state.loading && state.prayerTimes == null) {
//           return const Center(child: CircularProgressIndicator());
//         }

//         if (state.error != null && state.prayerTimes == null) {
//           return Center(child: Text(state.error!));
//         }

//         final t = state.prayerTimes;
//         if (t == null) {
//           return const Center(child: Text('No timings'));
//         }

//         // build your UI with t.fajr, t.dhuhr, etc
//         return Column(
//           children: [
//             Text('City: ${state.city}, ${state.country}'),
//             Text('Fajr: ${t.fajr}'),
//             Text('Dhuhr: ${t.dhuhr}'),
//             // ...
//           ],
//         );
//       },
//     );
//   }
// }


// class PrayerTimesScreen extends StatefulWidget {
//   static const String routeName = '/prayer-times';

//   const PrayerTimesScreen({super.key});

//   @override
//   State<PrayerTimesScreen> createState() => _PrayerTimesScreenState();
// }

// class _PrayerTimesScreenState extends State<PrayerTimesScreen> {
//   final _service = PrayerTimesService();

//   // You can make these dynamic via dropdowns / textfields
//   String _selectedCity = 'Karachi';
//   String _selectedCountry = 'Pakistan';

//   bool _loading = true;
//   String? _error;
//   PrayerTimes? _times;

//   @override
//   void initState() {
//     super.initState();
//     _loadTimes();
//   }

//   Future<void> _loadTimes() async {
//     setState(() {
//       _loading = true;
//       _error = null;
//     });

//     try {
//       final t = await _service.getTodayPrayerTimes(
//         city: _selectedCity,
//         country: _selectedCountry,
//         method: 2, // ISNA (choose what you want)
//       );
//       if (!mounted) return;
//       setState(() {
//         _times = t;
//         _loading = false;
//       });
//     } catch (e) {
//       if (!mounted) return;
//       setState(() {
//         _error = 'Failed to load prayer times';
//         _loading = false;
//       });
//     }
//   }

//   void _onChangeCity(String city, String country) {
//     setState(() {
//       _selectedCity = city;
//       _selectedCountry = country;
//     });
//     _loadTimes();
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
//           'Prayer times',
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
//         child: RefreshIndicator(
//           onRefresh: _loadTimes,
//           child: SingleChildScrollView(
//             physics: const AlwaysScrollableScrollPhysics(),
//             padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 _buildCitySelector(),
//                 const SizedBox(height: 16),
//                 if (_loading) ...[
//                   const Center(
//                     child: Padding(
//                       padding: EdgeInsets.only(top: 40),
//                       child: CircularProgressIndicator(),
//                     ),
//                   ),
//                 ] else if (_error != null) ...[
//                   Center(
//                     child: Padding(
//                       padding: const EdgeInsets.only(top: 40),
//                       child: Text(
//                         _error!,
//                         style: const TextStyle(
//                           fontFamily: AppTheme.fontFamily,
//                           color: Colors.redAccent,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ] else if (_times != null) ...[
//                   _buildTodaySummary(),
//                   const SizedBox(height: 18),
//                   _buildTimesCard(_times!),
//                 ],
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildCitySelector() {
//     // For now simple dropdowns; you can replace by search screen later
//     return Container(
//       padding: const EdgeInsets.all(14),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(18),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(.03),
//             blurRadius: 16,
//             offset: const Offset(0, 10),
//           )
//         ],
//       ),
//       child: Row(
//         children: [
//           const Icon(Icons.location_on_rounded,
//               color: AppTheme.primary, size: 22),
//           const SizedBox(width: 10),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text(
//                   'Current city',
//                   style: TextStyle(
//                     fontFamily: AppTheme.fontFamily,
//                     fontSize: 12,
//                     color: Color(0xFF75748A),
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 Row(
//                   children: [
//                     Expanded(
//                       child: DropdownButtonHideUnderline(
//                         child: DropdownButton<String>(
//                           isExpanded: true,
//                           value: _selectedCity,
//                           icon: const Icon(Icons.expand_more_rounded),
//                           style: const TextStyle(
//                             fontFamily: AppTheme.fontFamily,
//                             fontSize: 14.5,
//                             color: Color(0xFF3E1E69),
//                             fontWeight: FontWeight.w600,
//                           ),
//                           items: const [
//                             'Karachi',
//                             'Lahore',
//                             'Islamabad',
//                             'Melbourne',
//                             'Sydney',
//                           ].map((c) {
//                             return DropdownMenuItem<String>(
//                               value: c,
//                               child: Text(c),
//                             );
//                           }).toList(),
//                           onChanged: (v) {
//                             if (v == null) return;
//                             // quick mapping country for demo
//                             String country = 'Pakistan';
//                             if (v == 'Melbourne' || v == 'Sydney') {
//                               country = 'Australia';
//                             }
//                             _onChangeCity(v, country);
//                           },
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildTodaySummary() {
//     final now = DateTime.now();
//     final dateStr =
//         '${now.day.toString().padLeft(2, '0')} '
//         '${_monthName(now.month)} '
//         '${now.year}';

//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 18),
//       decoration: BoxDecoration(
//         gradient: const LinearGradient(
//           colors: [AppTheme.primary, AppTheme.accent],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ),
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(.12),
//             blurRadius: 18,
//             offset: const Offset(0, 10),
//           )
//         ],
//       ),
//       child: Row(
//         children: [
//           Container(
//             height: 40,
//             width: 40,
//             decoration: BoxDecoration(
//               color: Colors.white.withOpacity(.18),
//               borderRadius: BorderRadius.circular(16),
//             ),
//             child: const Icon(Icons.mosque_rounded, color: Colors.white),
//           ),
//           const SizedBox(width: 14),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'Today · $dateStr',
//                   style: const TextStyle(
//                     fontFamily: AppTheme.fontFamily,
//                     fontSize: 12.5,
//                     color: Colors.white70,
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   _selectedCity,
//                   style: const TextStyle(
//                     fontFamily: AppTheme.fontFamily,
//                     fontSize: 19,
//                     fontWeight: FontWeight.w700,
//                     color: Colors.white,
//                   ),
//                 ),
//                 Text(
//                   _selectedCountry,
//                   style: const TextStyle(
//                     fontFamily: AppTheme.fontFamily,
//                     fontSize: 12.5,
//                     color: Colors.white70,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildTimesCard(PrayerTimes t) {
//     final entries = [
//       _PrayerEntry('Fajr', t.fajr, Icons.nights_stay_rounded),
//       _PrayerEntry('Sunrise', t.sunrise, Icons.wb_twighlight),
//       _PrayerEntry('Dhuhr', t.dhuhr, Icons.wb_sunny_rounded),
//       _PrayerEntry('Asr', t.asr, Icons.wb_sunny_outlined),
//       _PrayerEntry('Maghrib', t.maghrib, Icons.nightlight_round),
//       _PrayerEntry('Isha', t.isha, Icons.dark_mode_rounded),
//     ];

//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 14),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(18),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(.02),
//             blurRadius: 18,
//             offset: const Offset(0, 12),
//           )
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text(
//             'Today’s prayer times',
//             style: TextStyle(
//               fontFamily: AppTheme.fontFamily,
//               fontSize: 15.5,
//               fontWeight: FontWeight.w700,
//               color: Color(0xFF3E1E69),
//             ),
//           ),
//           const SizedBox(height: 12),
//           for (final e in entries) ...[
//             _PrayerRow(entry: e),
//             if (e != entries.last)
//               const Divider(
//                 height: 18,
//                 color: Color(0xFFF1EEFA),
//               ),
//           ],
//         ],
//       ),
//     );
//   }

//   String _monthName(int m) {
//     const names = [
//       'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
//       'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
//     ];
//     return names[m - 1];
//   }
// }

// class _PrayerEntry {
//   final String label;
//   final String time;
//   final IconData icon;

//   _PrayerEntry(this.label, this.time, this.icon);
// }

// class _PrayerRow extends StatelessWidget {
//   final _PrayerEntry entry;

//   const _PrayerRow({required this.entry});

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         Container(
//           height: 32,
//           width: 32,
//           decoration: BoxDecoration(
//             color: AppTheme.primary.withOpacity(.06),
//             borderRadius: BorderRadius.circular(10),
//           ),
//           child: Icon(entry.icon, size: 18, color: AppTheme.primary),
//         ),
//         const SizedBox(width: 10),
//         Expanded(
//           child: Text(
//             entry.label,
//             style: const TextStyle(
//               fontFamily: AppTheme.fontFamily,
//               fontSize: 14,
//               fontWeight: FontWeight.w600,
//               color: Color(0xFF3E1E69),
//             ),
//           ),
//         ),
//         Text(
//           entry.time,
//           style: const TextStyle(
//             fontFamily: AppTheme.fontFamily,
//             fontSize: 14,
//             color: Color(0xFF75748A),
//           ),
//         ),
//       ],
//     );
//   }
// }
