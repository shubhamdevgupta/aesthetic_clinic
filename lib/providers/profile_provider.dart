import 'package:aesthetic_clinic/models/profile/profile_data.dart';
import 'package:aesthetic_clinic/models/profile/update_profile.dart';
import 'package:aesthetic_clinic/repository/ProfileRepository.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../services/LocalStorageService.dart';
import '../services/ui_state.dart';
import '../utils/AppConstants.dart';
import '../utils/CustomException.dart';
import 'authentication_provider.dart';

class ProfileProvider extends ChangeNotifier {
  final Profilerepository profilerepository = Profilerepository();
  final LocalStorageService _localStorage = LocalStorageService();
  String errorMsg = '';

  UiState<ProfileResponse> profileState = Idle();
  UiState<UpdateProfileResponse> updateProfileState = Idle();

  Future<void> getUserProfile(BuildContext context) async {
    profileState = Loading();
    notifyListeners();
    try {
      final response = await profilerepository.getUserProfile();
      if (response.status && response.statusCode == 200) {
        profileState = Success(response);
      } else {
        profileState = Error(response.message);
      }
    } on AuthenticationException {
      if (!context.mounted) return; // exit early if widget is gone
      final authProvider = Provider.of<AuthenticationProvider>(
        context,
        listen: false,
      );
      await authProvider.logout(context);
    } catch (e) {
      profileState = Error("Something went wrong: $e");
    } finally {
      notifyListeners();
    }
  }

  Future<void> updateProfile(
    String firstName,
    String lastName,
    String emailId,
    BuildContext context,
  ) async {
    updateProfileState = Loading();
    notifyListeners();
    try {
      final response = await profilerepository.updateUserProfile(
        firstName,
        lastName,
        emailId,
      );
      print("-------------- first name $firstName & second name $lastName");

      if (response.status && response.statuscode == 200) {
        updateProfileState = Success(response);
        _localStorage.saveString(AppConstants.prefFirstName, firstName);
        _localStorage.saveString(AppConstants.prefLastName, lastName);
        _localStorage.saveString(AppConstants.prefMobile, response.data.phone);
        _localStorage.saveString(AppConstants.prefEmail, response.data.email);
      } else {
        updateProfileState = Error(response.message);
      }
    } on AuthenticationException {
      if (!context.mounted) return; // exit early if widget is gone
      final authProvider = Provider.of<AuthenticationProvider>(
        context,
        listen: false,
      );
      await authProvider.logout(context);
    } catch (e) {
      profileState = Error("Something went wrong: $e");
    } finally {
      notifyListeners();
    }
  }
}
