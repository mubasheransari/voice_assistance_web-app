import 'package:flutter/material.dart';
import 'package:voice_assistant_project/Theme/theme.dart';


class PrayerTimesScreen extends StatefulWidget {
  const PrayerTimesScreen({super.key});

  @override
  State<PrayerTimesScreen> createState() => _PrayerTimesScreenState();
}

class _PrayerTimesScreenState extends State<PrayerTimesScreen> {
  final List<String> _cities = [
    'Karachi',
    'Lahore',
    'Islamabad',
    'Peshawar',
    'Quetta',
  ];

  String _selectedCity = 'Karachi';

  late Map<String, PrayerTimes> _currentTimes;

  @override
  void initState() {
    super.initState();
    _currentTimes = _getTimesForCity(_selectedCity);
  }

  Map<String, PrayerTimes> _getTimesForCity(String city) {
    // Dummy sample data. Replace with API integration later.
    switch (city) {
      case 'Lahore':
        return {
          'Fajr': PrayerTimes(start: '04:15', end: '05:35'),
          'Dhuhr': PrayerTimes(start: '12:10', end: '15:30'),
          'Asr': PrayerTimes(start: '15:45', end: '18:10'),
          'Maghrib': PrayerTimes(start: '18:20', end: '19:30'),
          'Isha': PrayerTimes(start: '19:45', end: '04:00'),
        };
      case 'Islamabad':
        return {
          'Fajr': PrayerTimes(start: '04:10', end: '05:30'),
          'Dhuhr': PrayerTimes(start: '12:05', end: '15:20'),
          'Asr': PrayerTimes(start: '15:35', end: '18:05'),
          'Maghrib': PrayerTimes(start: '18:15', end: '19:25'),
          'Isha': PrayerTimes(start: '19:40', end: '03:55'),
        };
      default: // Karachi / others
        return {
          'Fajr': PrayerTimes(start: '04:30', end: '05:50'),
          'Dhuhr': PrayerTimes(start: '12:30', end: '15:40'),
          'Asr': PrayerTimes(start: '15:55', end: '18:25'),
          'Maghrib': PrayerTimes(start: '18:35', end: '19:40'),
          'Isha': PrayerTimes(start: '19:55', end: '04:15'),
        };
    }
  }

  void _onCityChange(String? city) {
    if (city == null) return;
    setState(() {
      _selectedCity = city;
      _currentTimes = _getTimesForCity(city);
    });
  }

  @override
  Widget build(BuildContext context) {
    final keys = _currentTimes.keys.toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Namaz Times'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    const Icon(Icons.location_city_rounded,
                        color: AppTheme.primary),
                    const SizedBox(width: 12),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _selectedCity,
                        decoration: const InputDecoration(
                          labelText: 'Select City (Pakistan)',
                        ),
                        items: _cities
                            .map(
                              (c) => DropdownMenuItem(
                                value: c,
                                child: Text(c),
                              ),
                            )
                            .toList(),
                        onChanged: _onCityChange,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: keys.length,
                itemBuilder: (context, index) {
                  final name = keys[index];
                  final times = _currentTimes[name]!;
                  return _PrayerCard(
                    name: name,
                    start: times.start,
                    end: times.end,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PrayerTimes {
  final String start;
  final String end;

  PrayerTimes({required this.start, required this.end});
}

class _PrayerCard extends StatelessWidget {
  final String name;
  final String start;
  final String end;

  const _PrayerCard({
    required this.name,
    required this.start,
    required this.end,
  });

  @override
  Widget build(BuildContext context) {
    final isImportant =
        name == 'Fajr' || name == 'Maghrib' || name == 'Isha';

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isImportant ? AppTheme.primary : Colors.grey,
          child: Text(
            name[0],
            style: TextStyle(
              color: isImportant ? Colors.white : AppTheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          name,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text('Start: $start   •   End: $end'),
      ),
    );
  }
}
