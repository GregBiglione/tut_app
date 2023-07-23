import 'package:freezed_annotation/freezed_annotation.dart';

part 'login.freezed.dart';
part 'login.g.dart';

@freezed
class Login with _$Login {
  const factory Login(
    String email,
    String password,
  ) = _Login;

  factory Login.fromJson(Map<String, dynamic> json) => _$LoginFromJson(json);

}