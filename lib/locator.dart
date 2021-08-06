import 'package:climbing_gym_app/services/authservice.dart';
import 'package:climbing_gym_app/services/navigationService.dart';
import 'package:climbing_gym_app/services/newsService.dart';
import 'package:climbing_gym_app/services/pageviewService.dart';
import 'package:climbing_gym_app/services/routeColorService.dart';
import 'package:climbing_gym_app/services/routesService.dart';
import 'package:climbing_gym_app/services/gymService.dart';
import 'package:get_it/get_it.dart';

GetIt locator = GetIt.instance;
void setupLocator() {
  locator.registerSingleton(GymService());
  locator.registerSingleton(RoutesService());
  locator.registerSingleton(RouteColorService());
  locator.registerSingleton(NewsService());
  locator.registerSingleton(AuthService());
  locator.registerSingleton(PageViewService());
  locator.registerLazySingleton(() => NavigationService());
}
