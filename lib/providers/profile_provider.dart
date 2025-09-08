import 'package:aesthetic_clinic/models/service/all_services.dart';
import 'package:aesthetic_clinic/models/profile/profile_data.dart';
import 'package:aesthetic_clinic/models/profile/update_profile.dart';
import 'package:aesthetic_clinic/models/service/service_detail_response.dart';
import 'package:aesthetic_clinic/repository/ProfileRepository.dart';
import 'package:aesthetic_clinic/repository/ServiceRepository.dart';
import 'package:flutter/cupertino.dart';

import '../models/banner_list.dart' hide Service;
import '../services/LocalStorageService.dart';
import '../utils/AppConstants.dart';
import '../utils/CustomException.dart';
import '../utils/GlobalExceptionHandler.dart';

class ProfileProvider extends ChangeNotifier{
  final Profilerepository profilerepository= Profilerepository();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String errorMsg = '';


  ProfileResponse? _profileResponse;
  ProfileResponse? get profileResponse => _profileResponse;

  UpdateProfileResponse? _updateProfileResponse;
  UpdateProfileResponse? get updateProfileResponse => _updateProfileResponse;
  final LocalStorageService _localStorage = LocalStorageService();



  Future<void> getUserProfile() async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await profilerepository.getUserProfile();

      if(response.status && response.statusCode==200){
        _profileResponse=response;

      }

    } catch (e) {
      if (e is! AuthenticationException) {
        GlobalExceptionHandler.handleException(e as Exception);
      }
      _profileResponse = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateProfile(String firstName,String lastName,String emailId) async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await profilerepository.updateUserProfile(firstName, lastName, emailId);
        print("-------------- first name $firstName & second name $lastName");

      if(response.status && response.statuscode==200){

        _updateProfileResponse=response;
        _localStorage.saveString(
          AppConstants.prefFirstName,
          firstName,
        );
        _localStorage.saveString(
          AppConstants.prefLastName,
          lastName,
        );
        _localStorage.saveString(
          AppConstants.prefMobile,
          _updateProfileResponse!.data.email,
        );
        _localStorage.saveString(
          AppConstants.prefEmail,
          _updateProfileResponse!.data.phone,
        );
        return true;

      }else{
        errorMsg=_updateProfileResponse!.message;
        return false;

      }

    } catch (e) {
      if (e is! AuthenticationException) {
        GlobalExceptionHandler.handleException(e as Exception);
      }
      _profileResponse = null;
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}