enum UserRole { customer, business }

class Session {
  const Session({required this.userId, required this.name, required this.role});
  final String userId;
  final String name;
  final UserRole role;
}
