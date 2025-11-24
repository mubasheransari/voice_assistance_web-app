import 'dart:convert';
import 'package:http/http.dart' as http;

/// Simple model to hold prayer times for a single date
class PrayerTimes {
  final String fajr;
  final String sunrise;
  final String dhuhr;
  final String asr;
  final String maghrib;
  final String isha;

  PrayerTimes({
    required this.fajr,
    required this.sunrise,
    required this.dhuhr,
    required this.asr,
    required this.maghrib,
    required this.isha,
  });
}

class PrayerTimesService {
  // Using AlAdhan API: https://aladhan.com/prayer-times-api
  static const String _baseUrl = 'https://api.aladhan.com/v1/timingsByCity';

  /// city example: "Karachi"
  /// country example: "Pakistan"
  /// method: calculation method (2 = ISNA, 1 = MuslimWorldLeague, etc.)
  Future<PrayerTimes> getTodayPrayerTimes({
    required String city,
    required String country,
    int method = 2,
  }) async {
    final uri = Uri.parse(
      '$_baseUrl?city=$city&country=$country&method=$method',
    );

    final res = await http.get(uri);

    if (res.statusCode != 200) {
      throw Exception('Failed to load prayer times');
    }

    final data = jsonDecode(res.body) as Map<String, dynamic>;
    final timings = data['data']['timings'] as Map<String, dynamic>;

    return PrayerTimes(
      fajr: timings['Fajr'] ?? '--',
      sunrise: timings['Sunrise'] ?? '--',
      dhuhr: timings['Dhuhr'] ?? '--',
      asr: timings['Asr'] ?? '--',
      maghrib: timings['Maghrib'] ?? '--',
      isha: timings['Isha'] ?? '--',
    );
  }
}
