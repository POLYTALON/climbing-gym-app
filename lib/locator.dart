import 'package:climbing_gym_app/services/gymService.dart';
import 'package:get_it/get_it.dart';

GetIt locator = GetIt.instance;
void setupLocator() {
  locator.registerSingleton(GymService());
}
