import 'package:web_dashboard/src/data/repositories/user.dart';

class FirebaseUserData implements UserRepository {
  @override
  final String uid;

  FirebaseUserData(this.uid);
}
