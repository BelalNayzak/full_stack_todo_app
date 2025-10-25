class CreateUserDto {
  final String name;
  final String email;

  const CreateUserDto({required this.name, required this.email});

  Map<String, dynamic> toJson() => {'name': name, 'email': email};
}
