import '../entities/car.dart';

abstract class CarRepository {
  Future<List<Car>> fetchCars();
  Future<void> cacheCars(List<Car> cars);
  Future<List<Car>> loadCachedCars();
  Future<List<Car>> loadSeedCars();
  Future<List<String>> loadFavorites();
  Future<void> saveFavorites(List<String> ids);
  Future<List<String>> loadCompare();
  Future<void> saveCompare(List<String> ids);
}
