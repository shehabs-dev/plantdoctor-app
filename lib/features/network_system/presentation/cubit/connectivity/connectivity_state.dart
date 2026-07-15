part of 'connectivity_cubit.dart';

sealed class ConnectivityState {}

class ConnectivityOnline extends ConnectivityState {}

class ConnectivityOffline extends ConnectivityState {}
