import 'package:get_it/get_it.dart';
import 'package:krainet_task/data/data_sources/interfaces/i_preference_data_source.dart';
import 'package:krainet_task/data/data_sources/preference_data_source.dart';
import 'package:krainet_task/domain/repositories/authentication_repository.dart';
import 'package:krainet_task/domain/repositories/firebase_image_repository.dart';
import 'package:krainet_task/domain/repositories/interfaces/i_authentication_repository.dart';
import 'package:krainet_task/domain/repositories/interfaces/i_firebase_image_repository.dart';
import 'package:krainet_task/presentation/app/app_cubit.dart';
import 'package:krainet_task/presentation/pages/login/login_cubit.dart';
import 'package:krainet_task/presentation/pages/main/main_cubit.dart';
import 'package:krainet_task/presentation/pages/registration/registration_cubit.dart';

GetIt get i => GetIt.instance;

void initInjector() {
  i.registerSingleton<IPreferenceDataSource>(PreferenceDataSource());

  i.registerSingleton<IAuthenticationRepository>(AuthenticationRepository(i.get()));
  i.registerSingleton<IFirebaseImageRepository>(FirebaseImageRepository());

  i.registerFactory(() => AppCubit(i.get()));
  i.registerFactory(() => LoginCubit(i.get()));
  i.registerFactory(() => RegistrationCubit(i.get()));
  i.registerFactory(() => MainCubit(i.get(), i.get()));
}
