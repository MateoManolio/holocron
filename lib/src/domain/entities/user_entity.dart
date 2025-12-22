import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String? email;
  final bool isGuest;

  const UserEntity({required this.id, this.email, this.isGuest = false});

  @override
  List<Object?> get props => [id, email, isGuest];
}

