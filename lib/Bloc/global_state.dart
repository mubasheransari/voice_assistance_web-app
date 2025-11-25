// lib/blocs/global/global_state.dart
import '../services/prayer_times_service.dart';
import 'package:equatable/equatable.dart';
import '../services/prayer_times_service.dart';
import 'package:equatable/equatable.dart';
import '../services/prayer_times_service.dart';

import 'package:equatable/equatable.dart';
import '../services/prayer_times_service.dart';

enum PrayerTimesStatus { initial, loading, success, failure }

class GlobalState extends Equatable {
  final PrayerTimesStatus prayerTimesStatus;
  final String city;
  final String country;
  final int method;
  final PrayerTimes? prayerTimes;
  final String? error;

  const GlobalState({
    this.prayerTimesStatus = PrayerTimesStatus.initial,
    this.city = 'Karachi',
    this.country = 'Pakistan',
    this.method = 2,
    this.prayerTimes,
    this.error,
  });

  factory GlobalState.initial() => const GlobalState();

  GlobalState copyWith({
    PrayerTimesStatus? prayerTimesStatus,
    String? city,
    String? country,
    int? method,
    PrayerTimes? prayerTimes,
    String? error,
  }) {
    return GlobalState(
      prayerTimesStatus: prayerTimesStatus ?? this.prayerTimesStatus,
      city: city ?? this.city,
      country: country ?? this.country,
      method: method ?? this.method,
      prayerTimes: prayerTimes ?? this.prayerTimes,
      error: error,
    );
  }

  @override
  List<Object?> get props => [
        prayerTimesStatus,
        city,
        country,
        method,
        prayerTimes,
        error,
      ];
}
