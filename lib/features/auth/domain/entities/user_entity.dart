class UserEntity {
  const UserEntity({
    required this.name,
    required this.email,
    this.token,
    this.phone,
    this.address,
  });

  final String name;
  final String email;
  final String? token;
  final String? phone;
  final String? address;
}
