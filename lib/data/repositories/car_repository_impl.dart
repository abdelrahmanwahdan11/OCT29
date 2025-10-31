import '../../domain/entities/car.dart';
import '../../domain/repositories/car_repository.dart';
import '../datasources/car_local_data_source.dart';

class CarRepositoryImpl implements CarRepository {
  CarRepositoryImpl(this._localDataSource);

  final CarLocalDataSource _localDataSource;

  @override
  Future<List<Car>> fetchCars() async {
    final cached = await _localDataSource.loadCachedCars();
    if (cached.isNotEmpty) {
      return cached;
    }
    final seed = await _localDataSource.loadSeedCars();
    await _localDataSource.cacheCars(seed);
    return seed;
  }

  @override
  Future<void> cacheCars(List<Car> cars) => _localDataSource.cacheCars(cars);

  @override
  Future<List<Car>> loadCachedCars() => _localDataSource.loadCachedCars();

  @override
  Future<List<Car>> loadSeedCars() => _localDataSource.loadSeedCars();

  @override
  Future<List<String>> loadFavorites() => _localDataSource.loadFavoriteIds();

  @override
  Future<void> saveFavorites(List<String> ids) => _localDataSource.saveFavoriteIds(ids);

  @override
  Future<List<String>> loadCompare() => _localDataSource.loadCompareIds();

  @override
  Future<void> saveCompare(List<String> ids) => _localDataSource.saveCompareIds(ids);
}
