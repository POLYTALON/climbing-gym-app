import 'package:equatable/equatable.dart';

class UserRole extends Equatable {
  final bool gymuser;
  final bool builder;

  @override
  List<bool> get props => [gymuser, builder];

  UserRole({this.gymuser = false, this.builder = false});
}
