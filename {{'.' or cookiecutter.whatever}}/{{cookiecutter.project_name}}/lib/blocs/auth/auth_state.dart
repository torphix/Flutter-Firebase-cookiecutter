part of 'auth_cubit.dart';

class AuthState {
  final User? currentUser;

  AuthState({this.currentUser});

  AuthState copyWith({User? currentUser}) {
    return AuthState(currentUser: currentUser ?? this.currentUser);
  }
}
