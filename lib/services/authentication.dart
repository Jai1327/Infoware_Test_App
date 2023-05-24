import 'package:hive/hive.dart';
import '../model/user.dart';

class AuthenticationService {
  late Box<User> _users;

  Future<void> init() async {
    // setting up the hive boxes
    Hive.registerAdapter(UserAdapter());
    _users = await Hive.openBox<User>('userBox');

    await _users.clear();

    await _users.add(User('test1', '123'));
    await _users.add(User('test2', '456'));
  }

  Future<String?> authUser(final String username, final String password) async {
    final successful = await _users.values.any((element) =>
        element.userName == username && element.password == password);
    if (successful) {
      return username;
    }
    return null;
  }

  Future<UserCreationResult> createUser(
      final String username, final String password) async {
    final alreadyExist = _users.values.any(
      (element) => element.userName.toLowerCase() == username.toLowerCase(),
    );

    if (alreadyExist) {
      return UserCreationResult.exists;
    }
    try {
      await _users.add(User(username, password));
      return UserCreationResult.success;
    } on Exception catch (error) {
      print(error);
      return UserCreationResult.failure;
    }
  }
}

enum UserCreationResult {
  success,
  failure,
  exists,
}
