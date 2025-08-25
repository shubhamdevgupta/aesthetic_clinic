import 'package:aesthetic_clinic/models/all_services.dart';
import 'package:aesthetic_clinic/models/service_detail_response.dart';
import 'package:aesthetic_clinic/repository/ServiceRepository.dart';
import 'package:flutter/cupertino.dart';

import '../models/banner_list.dart' hide Service;
import '../services/LocalStorageService.dart';
import '../utils/CustomException.dart';
import '../utils/GlobalExceptionHandler.dart';

class ServiceProvider extends ChangeNotifier{
  final ServiceRepository serviceRepository= ServiceRepository();
  final LocalStorageService _localStorage = LocalStorageService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;


  GetAllService? _serviceResponse;
  GetAllService? get serviceResponse => _serviceResponse;

  ServiceDetailResponse? _serviceDetailResponse;
  ServiceDetailResponse? get serviceDetailResponse => _serviceDetailResponse;


  Service? _selectedService;
  Service? get selectedService => _selectedService;

  Future<void> getAllServices() async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await serviceRepository.getAllServices();

      if(response.status && response.statuscode==200){
        _serviceResponse=response;
        final topServices = _serviceResponse!.data
            .where((item) => item.isTopService)
            .toList();

        if (topServices.isNotEmpty) {
          _selectedService = topServices[0];
        }
      }

    } catch (e) {
      // Don't handle AuthenticationException here - let GlobalExceptionHandler handle it
      if (e is! AuthenticationException) {
        GlobalExceptionHandler.handleException(e as Exception);
      }
      _serviceResponse = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getServiceBYId(String serviceId) async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await serviceRepository.getServicebyID(serviceId);

      if(response.status && response.statuscode==200){
        _serviceDetailResponse=response;
      }

    } catch (e) {
      // Don't handle AuthenticationException here - let GlobalExceptionHandler handle it
      if (e is! AuthenticationException) {
        GlobalExceptionHandler.handleException(e as Exception);
      }
      _serviceDetailResponse = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }


  void selectService(Service service) {
    _selectedService = service;
    notifyListeners();
  }
}