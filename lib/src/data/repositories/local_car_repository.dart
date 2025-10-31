import '../../domain/entities/car.dart';
import '../datasources/local_car_data_source.dart';

class LocalCarRepository {
  LocalCarRepository(this._dataSource);

  final LocalCarDataSource _dataSource;
  List<Car>? _cache;

  Future<List<Car>> fetchCars() async {
    _cache ??= await _dataSource.loadCars();
    return _cache!;
  }
}
