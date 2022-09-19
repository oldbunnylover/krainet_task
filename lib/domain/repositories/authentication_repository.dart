import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:krainet_task/data/data_sources/interfaces/i_preference_data_source.dart';
import 'package:krainet_task/domain/entities/user.dart';
import 'package:krainet_task/domain/repositories/interfaces/i_authentication_repository.dart';

class AuthenticationRepository implements IAuthenticationRepository {
  final IPreferenceDataSource _preferenceDataSource;
  final _auth = auth.FirebaseAuth.instance;
  final _users = FirebaseFirestore.instance.collection('users');

  AuthenticationRepository(this._preferenceDataSource);

  @override
  Future<void> logIn(UserCredentials credentials) async {
    await _auth.signInWithEmailAndPassword(
      email: credentials.email,
      password: credentials.password,
    );
  }

  @override
  Future<void> signUp(UserCredentials credentials) async {
    if (credentials.username != null && credentials.dateOfBirth != null) {
      await _auth.createUserWithEmailAndPassword(
        email: credentials.email,
        password: credentials.password,
      );
      await _users.doc(_auth.currentUser?.uid).set({
        'uid': _auth.currentUser?.uid,
        ...credentials.toJson(),
      });
    }
  }

  @override
  Future<void> logOut() async {
    await _auth.signOut();
  }

  @override
  Future<User> get currentUser async {
    final userId = await _preferenceDataSource.getUserId();
    if (userId != null && userId != '') {
      final userMap = (await _users.doc(userId).get()).data();
      return userMap != null ? User.fromJson(userMap) : User.empty;
    } else {
      return User.empty;
    }
  }

  @override
  Stream<User> get user {
    return _auth.authStateChanges().map((firebaseUser) {
      final user = firebaseUser == null ? User.empty : User(id: firebaseUser.uid);
      _preferenceDataSource.saveUserId(user.id);
      return user;
    });
  }
}
