import 'package:city_guide/app/di/di.dart';
import 'package:city_guide/presentation/register/register_view_model.dart';
import 'package:flutter/material.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final RegisterViewModel _viewModel = instance<RegisterViewModel>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _mobileNumberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  _bind() {
    _viewModel.start();
    _usernameController.addListener(() =>
        _viewModel.setUsername(_usernameController.text),
    );
    _mobileNumberController.addListener(() =>
        _viewModel.setMobileNumber(_mobileNumberController.text),
    );
    _emailController.addListener(() =>
        _viewModel.setEmail(_emailController.text),
    );
    _passwordController.addListener(() =>
        _viewModel.setPassword(_passwordController.text),
    );
  }

  @override
  void initState() {
    _bind();
    super.initState();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    _usernameController.dispose();
    _mobileNumberController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
