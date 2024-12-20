import 'package:instagram_clon/features/auth/domain/entities/app_user.dart';

abstract class AuthStates {}

  class AuthInitial extends AuthStates{}


class AuthLoading extends AuthStates{}

class Authenticated extends AuthStates{

  final AppUser user;
  Authenticated(this.user);

}

class UnAuthenticated extends AuthStates{}

class AuthError extends AuthStates{

  final String message;
  AuthError(this.message);

}
