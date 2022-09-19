import 'package:krainet_task/domain/entities/user.dart';

abstract class IAuthenticationRepository {
  abstract final Stream<User> user;
  abstract final Future<User> currentUser;
  Future<void> signUp(UserCredentials credentials);
  Future<void> logIn(UserCredentials credentials);
  Future<void> logOut();
}
