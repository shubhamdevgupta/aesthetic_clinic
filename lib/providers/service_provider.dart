import 'package:aesthetic_clinic/models/appointment/booking_response.dart' hide Service;
import 'package:aesthetic_clinic/models/service/all_services.dart' hide Service;
import 'package:aesthetic_clinic/models/appointment/appointment_response.dart'
    hide Service;
import 'package:aesthetic_clinic/models/service/service_detail_response.dart';
import 'package:aesthetic_clinic/models/service/sub_service.dart';
import 'package:aesthetic_clinic/repository/ServiceRepository.dart';
import 'package:flutter/cupertino.dart';

import '../models/banner_list.dart';
import '../services/ui_state.dart';
import '../utils/CustomException.dart';

class ServiceProvider extends ChangeNotifier {
  final ServiceRepository serviceRepository = ServiceRepository();

  UiState<GetAllService> serviceState = Idle();
  UiState<ServiceResponse> subServiceState = Idle();
  UiState<ServiceDetailResponse> serviceDetialState = Idle();
  UiState<AppointmentResponse> appointmentState = Idle();

  UiState<BookingResponse> bookingState = Idle();

  Service? _selectedService;

  Service? get selectedService => _selectedService;

  Future<void> getMainServices() async {
    serviceState = Loading();
    notifyListeners();
    try {
      final response = await serviceRepository.getMainServices();
      if (response.status && response.statuscode == 200) {
        serviceState = Success(response);
      } else {
        serviceState = Error("Unexpected response");
      }
    } on NetworkException {
      serviceState = NoInternet();
    } on AuthenticationException {
      rethrow;
    } catch (e) {
      serviceState = Error("Something went wrong: $e");
    } finally {
      notifyListeners();
    }
  }

  Future<void> getSubService(String parentId) async {
    subServiceState = Loading();
    notifyListeners();
    try {
      final response = await serviceRepository.getSubService(parentId);
      if (response.status && response.statusCode == 200) {
        subServiceState = Success(response);
      } else {
        subServiceState = Error("Unexpected response");
      }
    } on NetworkException {
      subServiceState = NoInternet();
    } on AuthenticationException {
      rethrow;
    } catch (e) {
      subServiceState = Error("Something went wrong: $e");
    } finally {
      notifyListeners();
    }
  }

  Future<void> getServiceDetial(String serviceId) async {
    serviceDetialState = Loading();
    notifyListeners();
    try {
      final response = await serviceRepository.getServiceDetial(serviceId);
      if (response.status && response.statuscode == 200) {
        serviceDetialState = Success(response);
      } else {
        serviceDetialState = Error("Unexpected response");
      }
    } on NetworkException {
      serviceDetialState = NoInternet();
    } on AuthenticationException {
      rethrow;
    } catch (e) {
      serviceDetialState = Error("Something went wrong: $e");
    } finally {
      notifyListeners();
    }
  }

  Future<void> getBookingList() async {
    bookingState = Loading();
    notifyListeners();
    try {
      final response = await serviceRepository.getBookingList();
      if (response.status && response.statuscode == 200) {
        bookingState = Success(response);
      } else {
        bookingState = Error("Unexpected response");
      }
    } on NetworkException {
      bookingState = NoInternet();
    } on AuthenticationException {
      rethrow;
    } catch (e) {
      bookingState = Error("Something went wrong: $e");
    } finally {
      notifyListeners();
    }
  }

  Future<void> bookAppointment(
    String clientId,
    String serviceId,
    String doctorId,
    String slotId,
    String date,
    String description,
    String purpose,
    String prescription
  ) async {
    appointmentState = Loading();
    notifyListeners();
    try {
      final response = await serviceRepository.bookAppointment(clientId,serviceId,doctorId,slotId,date,description,purpose,prescription);
      if (response.status && response.statusCode == 200) {
        appointmentState = Success(response);
      } else {
        appointmentState = Error("Unexpected response");
      }
    } on NetworkException {
      appointmentState = NoInternet();
    } on AuthenticationException {
      rethrow;
    } catch (e) {
      appointmentState = Error("Something went wrong: $e");
    } finally {
      notifyListeners();
    }
  }

  void selectService(Service service) {
    _selectedService = service;
    notifyListeners();
  }
}
