import 'package:base_flutter_proj/core/base/model/models/base_model.dart';

abstract class BaseDataModel<T> extends BaseModel {
  T? data;
  bool isLoading = false;

  Future<T> load();

  Future<T> reload() async {
    clearError();
    return load();
  }
}
