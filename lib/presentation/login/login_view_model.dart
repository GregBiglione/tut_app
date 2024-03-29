import 'dart:async';

import 'package:city_guide/domain/usecase/login_usecase.dart';
import 'package:city_guide/domain/usecase/login_usecase_input.dart';
import 'package:city_guide/presentation/base/base_view_model.dart';
import 'package:city_guide/presentation/common/login.dart';
import 'package:city_guide/presentation/common/state_renderer/state_renderer_implementer.dart';

import '../common/state_renderer/state_renderer.dart';

class LoginViewModel extends BaseViewModel with LoginViewModelInput,
    LoginViewModelOutput {
  final StreamController _usernameStreamController = StreamController<String>.broadcast();
  final StreamController _passwordStreamController = StreamController<String>.broadcast();
  final StreamController _isAllInputValidStreamController = StreamController<void>.broadcast();
  final StreamController isUserLoggedInSuccessfullyStreamController = StreamController<String>();
  Login loginObject = const Login("", "");
  LoginUseCase _loginUseCase;

  LoginViewModel(this._loginUseCase);

  // Input ---------------------------------------------------------------------
  @override
  void dispose() {
    _usernameStreamController.close();
    _passwordStreamController.close();
    _isAllInputValidStreamController.close();
    isUserLoggedInSuccessfullyStreamController.close();
  }

  @override
  void start() {
    // View tells state to show content of the screen --------------------------
    inputState.add(ContentState());
  }

  @override
  Sink get inputUsername => _usernameStreamController.sink;

  @override
  Sink get inputUserPassword => _passwordStreamController.sink;

  @override
  Sink get inputIsAllInputValid => _isAllInputValidStreamController.sink;

  @override
  login() async {
    inputState.add(LoadingState(stateRendererType: StateRendererType.POPUP_LOADING_STATE));
    (await _loginUseCase.execute(
        LoginUseCaseInput(
            loginObject.username,
            loginObject.password),
    )).fold(
            (failure) => {
              // Failure -------------------------------------------------------
              inputState.add(ErrorState(StateRendererType.POPUP_ERROR_STATE, failure.message)),
            },
            (data) {
              // Authentication ------------------------------------------------
              inputState.add(ContentState());
              // Navigate to main screen after login ---------------------------
              isUserLoggedInSuccessfullyStreamController.add("abcdefgh");
            });
  }

  @override
  setUserName(String username) {
    inputUsername.add(username);
    loginObject = loginObject.copyWith(username: username);
    _validate();
  }

  @override
  setUserPassword(String password) {
    inputUserPassword.add(password);
    loginObject = loginObject.copyWith(password: password);
    _validate();
  }

  // Output --------------------------------------------------------------------
  @override
  Stream<bool> get outputIsUsernameValid => _usernameStreamController
      .stream.map((username) => _isUsernameValid(username));

  @override
  Stream<bool> get outputIsUserPasswordValid => _passwordStreamController
      .stream.map((password) => _isPasswordValid(password));

  @override
  Stream<bool> get outputIsAllInputValid => _isAllInputValidStreamController
      .stream.map((_) => _isAllInputValid());

  // Private function ----------------------------------------------------------
  bool _isUsernameValid(String username) {
    return username.isNotEmpty;
  }

  bool _isPasswordValid(String password) {
    return password.isNotEmpty;
  }

  bool _isAllInputValid() {
    return _isUsernameValid(loginObject.username) && _isPasswordValid(loginObject.password);
  }

  _validate() {
    inputIsAllInputValid.add(null);
  }
}

// Input means order that view model will receive from view --------------------
abstract class LoginViewModelInput {
  // 3 functions for actions ---------------------------------------------------
  setUserName(String username);
  setUserPassword(String password);
  login();

  // 2 sinks for stream --------------------------------------------------------
  Sink get inputUsername;
  Sink get inputUserPassword;
  Sink get inputIsAllInputValid;
}

// Output means data/result that will be sent from view to view ----------------
abstract class LoginViewModelOutput {
  // 2 stream for validation ---------------------------------------------------
  Stream<bool> get outputIsUsernameValid;
  Stream<bool> get outputIsUserPasswordValid;
  Stream<bool> get outputIsAllInputValid;
}