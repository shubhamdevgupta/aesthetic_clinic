import 'package:aesthetic_clinic/repository/HomeRepository.dart';
import 'package:flutter/cupertino.dart';

import '../models/banner_list.dart';
import '../repository/ServiceRepository.dart';
import '../utils/CustomException.dart';
import '../utils/GlobalExceptionHandler.dart';

class HomeProvider extends ChangeNotifier{
  final HomeRepository homeRepository = HomeRepository();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  AppConfigurationResponse? _appConfigurationResponse;
  AppConfigurationResponse? get appConfigResponse => _appConfigurationResponse;

  Future<void> getDashboardData() async {
    _isLoading = true;
    try {
      final response = await homeRepository.getDashboardData();

      if(response.status && response.statuscode==200){
        _appConfigurationResponse=response;
      }

    } catch (e, stack) {
      debugPrint("Error: $e");
      debugPrint("StackTrace: $stack");

      // Don't handle AuthenticationException here - let GlobalExceptionHandler handle it
      if (e is! AuthenticationException) {
        GlobalExceptionHandler.handleException(e as Exception);
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}