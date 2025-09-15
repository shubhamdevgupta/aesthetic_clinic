import 'package:aesthetic_clinic/models/appointment/appointment_slots.dart'
    hide Service;
import 'package:aesthetic_clinic/models/appointment/booking_response.dart'
    hide Service;
import 'package:aesthetic_clinic/models/service/all_services.dart' hide Service;
import 'package:aesthetic_clinic/models/appointment/appointment_response.dart'
    hide Service;
import 'package:aesthetic_clinic/models/service/service_detail_response.dart';
import 'package:aesthetic_clinic/models/service/sub_service.dart';
import 'package:aesthetic_clinic/repository/ServiceRepository.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../models/banner_list.dart';
import '../services/ui_state.dart';
import '../utils/CustomException.dart';
import 'authentication_provider.dart';

class ServiceProvider extends ChangeNotifier {
  final ServiceRepository serviceRepository = ServiceRepository();

  UiState<GetAllService> serviceState = Idle();
  UiState<ServiceResponse> subServiceState = Idle();
  UiState<ServiceDetailResponse> serviceDetialState = Idle();
  UiState<AppointmentResponse> bookAppointmentState = Idle();

  UiState<BookingResponse> bookingState = Idle();

  UiState<AppointmentSlots> appointmentSlotsState = Idle();

  Service? _selectedService;

  Service? get selectedService => _selectedService;

  int _selectedDoctorIndex=0;
  int get selectedDoctorIndex => _selectedDoctorIndex;

  DateTime selectedDate = DateTime.now();

  Slot? _selectedSlot;
  Slot? get selectedSlot => _selectedSlot;

  Future<void> getMainServices(BuildContext context,{bool forceRefresh = false}) async {
  if (!forceRefresh && serviceState is Success<GetAllService>) {
  return;
  }
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
      if (!context.mounted) return;  // exit early if widget is gone
      final authProvider = Provider.of<AuthenticationProvider>(
        context,
        listen: false,
      );
      await authProvider.logout(context);
    } catch (e) {
      serviceState = Error("Something went wrong: $e");
    } finally {
      notifyListeners();
    }
  }

  Future<void> getSubService(String parentId,BuildContext context) async {
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
      if (!context.mounted) return;  // exit early if widget is gone
      final authProvider = Provider.of<AuthenticationProvider>(
        context,
        listen: false,
      );
      await authProvider.logout(context);
    } catch (e) {
      subServiceState = Error("Something went wrong: $e");
    } finally {
      notifyListeners();
    }
  }

  Future<void> getServiceDetial(String serviceId,BuildContext context) async {
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
      if (!context.mounted) return;  // exit early if widget is gone
      final authProvider = Provider.of<AuthenticationProvider>(
        context,
        listen: false,
      );
      await authProvider.logout(context);
    } catch (e) {
      serviceDetialState = Error("Something went wrong: $e");
    } finally {
      notifyListeners();
    }
  }

  Future<void> getBookingList(BuildContext context,{bool forceRefresh=false}) async {

    if(!forceRefresh && bookingState is Success<BookingResponse>){
      return;
    }
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
      if (!context.mounted) return;  // exit early if widget is gone
      final authProvider = Provider.of<AuthenticationProvider>(
        context,
        listen: false,
      );
      await authProvider.logout(context);
    } catch (e) {
      bookingState = Error("Something went wrong: $e");
    } finally {
      notifyListeners();
    }
  }

  Future<void> getAppointmentSlots(String serviceId,BuildContext context) async {
    appointmentSlotsState = Loading();
    notifyListeners();
    try {
      final response = await serviceRepository.getAppointmentSlots(serviceId);
      if (response.status && response.statuscode == 200) {
        appointmentSlotsState = Success(response);
      } else {
        appointmentSlotsState = Error("Unexpected response");
      }
    } on AuthenticationException {
      if (!context.mounted) return;  // exit early if widget is gone
      final authProvider = Provider.of<AuthenticationProvider>(
        context,
        listen: false,
      );
      await authProvider.logout(context);
    } catch (e) {
      appointmentSlotsState = Error("Something went wrong: $e");
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
    String prescription,
      BuildContext context
  ) async {
    bookAppointmentState = Loading();
    notifyListeners();
    try {
      final response = await serviceRepository.bookAppointment(
        clientId,
        serviceId,
        doctorId,
        slotId,
        date,
        description,
        purpose,
        prescription,
      );
      if (response.status && response.statusCode == 200) {
        bookAppointmentState = Success(response);
      } else {
        bookAppointmentState = Error("Unexpected response");
      }
    } on NetworkException {
      bookAppointmentState = NoInternet();
    } on AuthenticationException {
      if (!context.mounted) return;  // exit early if widget is gone
      final authProvider = Provider.of<AuthenticationProvider>(
        context,
        listen: false,
      );
      await authProvider.logout(context);
    } catch (e) {
      bookAppointmentState = Error("Something went wrong: $e");
    } finally {
      notifyListeners();
    }
  }

  void selectService(Service service) {
    _selectedService = service;
    notifyListeners();
  }

  void setSelectedSlot(Slot slot) {
    _selectedSlot = slot;
    notifyListeners();
  }
  void setSelectedDate(DateTime dateTime) {
    selectedDate = dateTime;
    _selectedSlot=null;
    notifyListeners();
  }

  void setSelectedDoctorIndex(int index) {
    _selectedDoctorIndex = index;
    _selectedSlot = null;
    notifyListeners();
  }
}
