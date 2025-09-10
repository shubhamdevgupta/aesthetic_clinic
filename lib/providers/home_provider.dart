import 'package:aesthetic_clinic/models/doctor/doctor_detail_response.dart';
import 'package:aesthetic_clinic/models/doctor/doctor_response.dart';
import 'package:aesthetic_clinic/models/doctor/get_review.dart';
import 'package:aesthetic_clinic/models/doctor/submit_doctor_review.dart';
import 'package:aesthetic_clinic/providers/authentication_provider.dart';
import 'package:aesthetic_clinic/repository/HomeRepository.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../models/banner_list.dart';
import '../services/ui_state.dart';
import '../utils/CustomException.dart';

class HomeProvider extends ChangeNotifier {
  final HomeRepository homeRepository = HomeRepository();

  TextEditingController reviewController = TextEditingController();

  UiState<AppConfigurationResponse> dashboardState = Idle();
  UiState<DoctorResponse> doctorState = Idle();
  UiState<DoctorDetailModel> doctorDetailState = Idle();

  UiState<DoctorReview> doctorReviewState = Idle();
  UiState<ReviewResponse> submitReviewState = Idle();

  double _selectedRating = 0.0;

  double get selectedRating => _selectedRating;

  Future<void> getDashboardData(BuildContext context) async {
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
      if (!context.mounted) return;  // exit early if widget is gone
      final authProvider = Provider.of<AuthenticationProvider>(
        context,
        listen: false,
      );
      await authProvider.logout(context);
    } catch (e) {
      dashboardState = Error("Something went wrong: $e");
    } finally {
      notifyListeners();
    }
  }

  Future<void> getDoctorData(BuildContext context) async {
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
      if (!context.mounted) return;  // exit early if widget is gone
      final authProvider = Provider.of<AuthenticationProvider>(
        context,
        listen: false,
      );
      await authProvider.logout(context);
    } catch (e) {
      doctorState = Error("Something went wrong: $e");
    } finally {
      notifyListeners();
    }
  }

  Future<void> getDoctorById(String doctorId,BuildContext context) async {
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
      if (!context.mounted) return;  // exit early if widget is gone
      final authProvider = Provider.of<AuthenticationProvider>(
        context,
        listen: false,
      );
      await authProvider.logout(context);
    } catch (e) {
      doctorDetailState = Error("Something went wrong: $e");
    } finally {
      notifyListeners();
    }
  }

  Future<void> submitReview(
    String rating,
    String review,
    String doctorId,
      BuildContext context
  ) async {
    submitReviewState = Loading();
    notifyListeners();

    try {
      final response = await homeRepository.submitReview(
        rating,
        review,
        doctorId,
      );
      if (response.status && response.statuscode == 200) {
        submitReviewState = Success(response);
      } else {
        submitReviewState = Error("Unexpected response format");
      }
    } on NetworkException {
      submitReviewState = NoInternet();
    } on AuthenticationException {
      if (!context.mounted) return;  // exit early if widget is gone
      final authProvider = Provider.of<AuthenticationProvider>(
        context,
        listen: false,
      );
      await authProvider.logout(context);
    } catch (e) {
      submitReviewState = Error("Something went wrong: $e");
    } finally {
      notifyListeners();
    }
  }

  Future<void> getDoctorReview(String doctorId,BuildContext context) async {
    doctorReviewState = Loading();
    notifyListeners();

    try {
      final response = await homeRepository.getReview(doctorId);
      print("review data --- $response");
      if (response.status && response.statuscode == 200) {
        doctorReviewState = Success(response);
      } else {
        doctorReviewState = Error("Unexpected response format");
      }
    } on AuthenticationException {
      if (!context.mounted) return;  // exit early if widget is gone
      final authProvider = Provider.of<AuthenticationProvider>(
        context,
        listen: false,
      );
      await authProvider.logout(context);
    } catch (e) {
      doctorReviewState = Error("Something went wrong: $e");
    } finally {
      notifyListeners();
    }
  }

  void setSelectedRating(double rating) {
    _selectedRating = rating;
    notifyListeners();
  }
}
