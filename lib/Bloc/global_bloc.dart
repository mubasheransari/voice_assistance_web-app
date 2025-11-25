// lib/blocs/global/global_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';

import '../services/prayer_times_service.dart';
import 'global_event.dart';
import 'global_state.dart';
import 'package:bloc/bloc.dart';


class GlobalBloc extends Bloc<GlobalEvent, GlobalState> {
  final PrayerTimesService _service;

  GlobalBloc(this._service) : super(GlobalState.initial()) {
    on<LoadPrayerTimes>(_onLoadPrayerTimes);
    on<SetPrayerLocation>(_onSetPrayerLocation);
  }

  Future<void> _onLoadPrayerTimes(
    LoadPrayerTimes event,
    Emitter<GlobalState> emit,
  ) async {
    final city = event.city ?? state.city;
    final country = event.country ?? state.country;
    final method = event.method ?? state.method;

    emit(
      state.copyWith(
        prayerTimesStatus: PrayerTimesStatus.loading,
        city: city,
        country: country,
        method: method,
        error: null,
      ),
    );

    try {
      final times = await _service.getTodayPrayerTimes(
        city: city,
        country: country,
        method: method,
      );
      emit(
        state.copyWith(
          prayerTimesStatus: PrayerTimesStatus.success,
          prayerTimes: times,
          error: null,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          prayerTimesStatus: PrayerTimesStatus.failure,
          error: 'Failed to load prayer times',
        ),
      );
    }
  }

  Future<void> _onSetPrayerLocation(
    SetPrayerLocation event,
    Emitter<GlobalState> emit,
  ) async {
    // Just reuse LoadPrayerTimes with new location
    add(
      LoadPrayerTimes(
        city: event.city,
        country: event.country,
        method: event.method,
      ),
    );
  }
}
