import 'package:equatable/equatable.dart';

/// TODO: This model is for template purpose
/// 
class UserModel extends Equatable {
  const UserModel({
    this.name,
    this.profilePictureUrl,
    this.bio,
  });

  final String? name;
  final String? profilePictureUrl;
  final String? bio;

  @override
  List<Object?> get props => [name, profilePictureUrl, bio];
}
