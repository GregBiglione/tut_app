import 'package:city_guide/app/app_preferences.dart';
import 'package:city_guide/data/data_source/local_data_source.dart';
import 'package:city_guide/data/data_source/remote_data_source.dart';
import 'package:city_guide/data/data_source/remote_data_source_implementer.dart';
import 'package:city_guide/data/network/app_api.dart';
import 'package:city_guide/data/network/dio_factory.dart';
import 'package:city_guide/data/repository/repository_implementer.dart';
import 'package:city_guide/domain/repository/repository.dart';
import 'package:city_guide/domain/usecase/home_usecase.dart';
import 'package:city_guide/domain/usecase/login_usecase.dart';
import 'package:city_guide/domain/usecase/register_use_case.dart';
import 'package:city_guide/domain/usecase/store_detail_usecase.dart';
import 'package:city_guide/presentation/forgot_password/forgot_password_view_model.dart';
import 'package:city_guide/presentation/login/login_view_model.dart';
import 'package:city_guide/presentation/register/register_view_model.dart';
import 'package:city_guide/presentation/store_detail/store_detail_view_model.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/data_source/local_data_source_implementer.dart';
import '../../data/network/netwok_info_implementer.dart';
import '../../data/network/network_info.dart';
import '../../domain/usecase/forgot_password_usecase.dart';
import '../../presentation/main/home/home_view_model.dart';

final instance = GetIt.instance;

Future<void> initAppModule() async {
  final sharedPrefs = await SharedPreferences.getInstance();

  // SharedPreferences instance ------------------------------------------------
  instance.registerLazySingleton<SharedPreferences>(() => sharedPrefs);

  // App Preferences instance --------------------------------------------------
  instance.registerLazySingleton<AppPreferences>(() =>
      AppPreferences(instance()));

  // Network info instance -----------------------------------------------------
  instance.registerLazySingleton<NetworkInfo>(() =>
      NetworkInfoImplementer(InternetConnectionChecker()));

  // Dio factory instance ------------------------------------------------------
  instance.registerLazySingleton<DioFactory>(() =>
      DioFactory(instance()));

  // App service client instance -----------------------------------------------
  final dio = await instance<DioFactory>().getDio();
  instance.registerLazySingleton<AppServiceClient>(() =>
      AppServiceClient(dio));

  // Remote data source instance -----------------------------------------------
  instance.registerLazySingleton<RemoteDataSource>(() =>
      RemoteDataSourceImplementer(instance()));

  // Local data source instance ------------------------------------------------
  instance.registerLazySingleton<LocalDataSource>(() =>
      LocalDataSourceImplementer());

  // Repository instance -------------------------------------------------------
  instance.registerLazySingleton<Repository>(() =>
      RepositoryImplementer(instance(), instance(), instance()));
}

initLoginModule() {
  if(!GetIt.I.isRegistered<LoginUseCase>()) {
    // Login use case instance -------------------------------------------------
    instance.registerFactory<LoginUseCase>(() => LoginUseCase(instance()));
    // Login view model instance -----------------------------------------------
    instance.registerFactory<LoginViewModel>(() => LoginViewModel(instance()));
  }
}

initForgotPasswordModule() {
  if(!GetIt.I.isRegistered<ForgotPasswordUseCase>()) {
    // Forgot password use case instance ---------------------------------------
    instance.registerFactory<ForgotPasswordUseCase>(() =>
        ForgotPasswordUseCase(instance()));
    // Forgot password view model instance -------------------------------------
    instance.registerFactory<ForgotPasswordViewModel>(() =>
        ForgotPasswordViewModel(instance()));
  }
}

initRegisterModule() {
  if(!GetIt.I.isRegistered<RegisterUseCase>()) {
    // Register use case instance ----------------------------------------------
    instance.registerFactory<RegisterUseCase>(() => RegisterUseCase(instance()));
    // Register view model instance --------------------------------------------
    instance.registerFactory<RegisterViewModel>(() => RegisterViewModel(instance()));
    // Register image picker ---------------------------------------------------
    instance.registerFactory<ImagePicker>(() => ImagePicker());
  }
}

initHomeModule() {
  if(!GetIt.I.isRegistered<HomeUseCase>()) {
    // Home use case instance --------------------------------------------------
    instance.registerFactory<HomeUseCase>(() => HomeUseCase(instance()));
    // Home view model instance ------------------------------------------------
    instance.registerFactory<HomeViewModel>(() => HomeViewModel(instance()));
  }
}

initStoreDetailModule() {
  if(!GetIt.I.isRegistered<StoreDetailUseCase>()) {
    // Store detail use case instance ------------------------------------------
    instance.registerFactory<StoreDetailUseCase>(() => StoreDetailUseCase(instance()));
    // Store detail view model instance ----------------------------------------
    instance.registerFactory<StoreDetailViewModel>(() => StoreDetailViewModel(instance()));
  }
}

resetAllModules() {
  instance.reset(dispose: false);
  initAppModule();
  initLoginModule();
  initRegisterModule();
  initForgotPasswordModule();
  initHomeModule();
  initStoreDetailModule();
}