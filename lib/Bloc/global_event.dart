
import 'package:equatable/equatable.dart';

abstract class GlobalEvent extends Equatable {
  const GlobalEvent();

  @override
  List<Object?> get props => [];
}

/// Optional city/country (if null → use state values)
class LoadPrayerTimes extends GlobalEvent {
  final String? city;
  final String? country;
  final int? method;

  const LoadPrayerTimes({this.city, this.country, this.method});

  @override
  List<Object?> get props => [city, country, method];
}

class SetPrayerLocation extends GlobalEvent {
  final String city;
  final String country;
  final int method;

  const SetPrayerLocation({
    required this.city,
    required this.country,
    this.method = 2,
  });

  @override
  List<Object?> get props => [city, country, method];
}
