import 'package:aesthetic_clinic/models/all_services.dart';
import 'package:aesthetic_clinic/repository/ServiceRepository.dart';
import 'package:flutter/cupertino.dart';

import '../models/banner_list.dart';
import '../services/LocalStorageService.dart';
import '../utils/GlobalExceptionHandler.dart';

class ServiceProvider extends ChangeNotifier{
  final ServiceRepository serviceRepository= ServiceRepository();
  final LocalStorageService _localStorage = LocalStorageService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;


  ServiceResponse? _serviceResponse;
  ServiceResponse? get serviceResponse => _serviceResponse;


  AppConfigurationResponse? _appConfigurationResponse;
  AppConfigurationResponse? get appConfigResponse => _appConfigurationResponse;


  Future<void> getAllServices() async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await serviceRepository.getAllServices();

      if(response.status && response.statuscode==200){
        _serviceResponse=response;
      }

    } catch (e) {
      GlobalExceptionHandler.handleException(e as Exception);
      _serviceResponse = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  Future<void> getBannerList() async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await serviceRepository.getBannerList();

      if(response.status && response.statuscode==200){
        _appConfigurationResponse=response;
      }

    } catch (e) {
      GlobalExceptionHandler.handleException(e as Exception);
      _appConfigurationResponse = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}