import 'package:city_guide/presentation/common/state_renderer/state_renderer_implementer.dart';
import 'package:city_guide/presentation/forgot_password/forgot_password_view_model.dart';
import 'package:city_guide/presentation/ressource/color_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../app/di/di.dart';
import '../ressource/asset_manager.dart';
import '../ressource/string_manager.dart';
import '../ressource/value_manager.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  final ForgotPasswordViewModel _viewModel = instance<ForgotPasswordViewModel>();
  final TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  _bind() {
    _viewModel.start();
    _emailController.addListener(() =>
        _viewModel.setEmail(_emailController.text)
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.white,
      body: StreamBuilder<FlowState>(
        stream: _viewModel.outputState,
        builder: (context, snapshot) {
          return snapshot.data?.getWidgetScreen(
            context,
            _getContentWidget(),
            () {
              _viewModel.newPassword();
            }
          ) ?? _getContentWidget();
        },
      ),
    );
  }

  Widget _getContentWidget() => Container(
    padding: const EdgeInsets.only(
      top: AppPadding.p100,
    ),
    color: ColorManager.white,
    child: SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            const Image(image: AssetImage(ImageAsset.splashLogo)),
            const SizedBox(height: AppSize.s28,),
            _emailWidget(),
            const SizedBox(height: AppSize.s28,),
            _resetPasswordButtonWidget(),
            const SizedBox(height: AppSize.s8,),
          ],
        ),
      ),
    ),
  );

  //----------------------------------------------------------------------------
  // Email widget
  //----------------------------------------------------------------------------

  Widget _emailWidget() => Padding(
    padding: const EdgeInsets.only(
      left: AppPadding.p28,
      right: AppPadding.p28,
    ),
    child: StreamBuilder<bool>(
      stream: _viewModel.outputIsEmailValid,
      builder: (context, snapshot) {
        return TextFormField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            hintText: AppString.email.tr(),
            labelText: AppString.email.tr(),
            errorText: (snapshot.data ?? true)
                ? null
                : AppString.emailError.tr(),
          ),
        );
      },
    ),
  );

  //----------------------------------------------------------------------------
  // Reset password button widget
  //----------------------------------------------------------------------------

  Widget _resetPasswordButtonWidget() => Padding(
    padding: const EdgeInsets.only(
      left: AppPadding.p28,
      right: AppPadding.p28,
    ),
    child: StreamBuilder<bool>(
      stream: _viewModel.outputIsAllInputValid,
      builder: (context, snapshot) {
        return SizedBox(
          width: double.infinity,
          height: AppSize.s40,
          child: ElevatedButton(
            onPressed: (snapshot.data ?? false)
                ? () {
              _viewModel.newPassword();
            }
                : null,
            child: const Text(
              AppString.resetPassword,
            ).tr(),
          ),
        );
      },
    ),
  );
}
