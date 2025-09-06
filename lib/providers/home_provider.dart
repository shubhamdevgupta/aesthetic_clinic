import 'package:aesthetic_clinic/models/doctor/doctor_detail_response.dart';
import 'package:aesthetic_clinic/models/doctor/doctor_response.dart';
import 'package:aesthetic_clinic/repository/HomeRepository.dart';
import 'package:flutter/cupertino.dart';

import '../models/banner_list.dart';
import '../services/ui_state.dart';
import '../utils/CustomException.dart';

class HomeProvider extends ChangeNotifier {
  final HomeRepository homeRepository = HomeRepository();

  UiState<AppConfigurationResponse> dashboardState = Idle();
  UiState<DoctorResponse> doctorState = Idle();
  UiState<DoctorDetailModel> doctorDetailState = Idle();

  Future<void> getDashboardData() async {
    dashboardState = Loading();
    notifyListeners();

    try {
      final response = await homeRepository.getDashboardData();
      if (response.status && response.statuscode == 200) {
        dashboardState = Success(response);
      } else {
        dashboardState = Error("Unexpected response");
      }
    } on NetworkException {
      dashboardState = NoInternet();
    } on AuthenticationException {
      rethrow;
    } catch (e) {
      dashboardState = Error("Something went wrong: $e");
    } finally {
      notifyListeners();
    }
  }

  Future<void> getDoctorData() async {
    doctorState = Loading();
    notifyListeners();

    try {
      final response = await homeRepository.getDoctorData();
      if (response.status && response.statuscode == 200) {
        doctorState = Success(response);
      } else {
        doctorState = Error("Unexpected response format");
      }
    } on NetworkException {
      doctorState = NoInternet();
    } on AuthenticationException {
      rethrow;
    } catch (e) {
      doctorState = Error("Something went wrong: $e");
    } finally {
      notifyListeners();
    }
  }

  Future<void> getDoctorById(String doctorId) async {
    doctorDetailState = Loading();
    notifyListeners();

    try {
      final response = await homeRepository.getDoctorbyId(doctorId);
      if (response.status! && response.statusCode == 200) {
        doctorDetailState = Success(response);
      } else {
        doctorDetailState = Error("Unexpected response format");
      }
    } on NetworkException {
      doctorDetailState = NoInternet();
    } on AuthenticationException {
      rethrow;
    } catch (e) {
      doctorDetailState = Error("Something went wrong: $e");
    } finally {
      notifyListeners();
    }
  }
}
