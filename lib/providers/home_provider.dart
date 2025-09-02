import 'package:aesthetic_clinic/models/doctor/doctor_detail_response.dart';
import 'package:aesthetic_clinic/models/doctor/doctor_response.dart';
import 'package:aesthetic_clinic/repository/HomeRepository.dart';
import 'package:flutter/cupertino.dart';

import '../models/banner_list.dart';
import '../utils/CustomException.dart';
import '../utils/GlobalExceptionHandler.dart';

class HomeProvider extends ChangeNotifier{
  final HomeRepository homeRepository = HomeRepository();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  AppConfigurationResponse? _appConfigurationResponse;
  AppConfigurationResponse? get appConfigResponse => _appConfigurationResponse;

  DoctorResponse? _doctorResponse;
  DoctorResponse? get doctorResponse => _doctorResponse;

  DoctorDetailModel? _doctorDetailModel;
  DoctorDetailModel? get doctorDetailResponse => _doctorDetailModel;

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
  Future<void> getDoctorData() async {
    _isLoading = true;
    try {
      final response = await homeRepository.getDoctorData();

      if(response.status && response.statuscode==200){
        _doctorResponse=response;
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

  Future<void> getDoctorbyId(String doctorId) async {
    _isLoading = true;
    notifyListeners();
    _doctorDetailModel=null;
    try {
      final response = await homeRepository.getDoctorbyId(doctorId);

      if(response.status! && response.statusCode==200){
        _doctorDetailModel=response;
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