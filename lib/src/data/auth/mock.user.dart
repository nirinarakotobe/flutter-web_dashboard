import 'package:web_dashboard/src/data/repositories/user.dart';

class MockUserData implements UserRepository {
  @override
  String get uid => "123";
}
