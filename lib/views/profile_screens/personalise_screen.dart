import 'package:aesthetic_clinic/providers/profile_provider.dart';
import 'package:aesthetic_clinic/services/LocalStorageService.dart';
import 'package:aesthetic_clinic/utils/AppConstants.dart';
import 'package:aesthetic_clinic/views/profile_screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/ui_state.dart';
import '../../utils/Appcolor.dart';
import '../../utils/toast_helper.dart';

class PersonalizeScreen extends StatefulWidget {
  final bool isVerified;

   PersonalizeScreen({Key? key,required this.isVerified}):super(key: key);
  @override
  State<PersonalizeScreen> createState() => _PersonalizeScreenState();
}

class _PersonalizeScreenState extends State<PersonalizeScreen> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  final LocalStorageService localStorageService = LocalStorageService();

  String _selectedGender = 'Select Gender';

  @override
  void initState() {
    super.initState();
    // Pre-populate with sample data
    _fullNameController.text = "${localStorageService.getString(AppConstants.prefFirstName)!} ${localStorageService.getString(AppConstants.prefLastName)!}";
    _phoneController.text = localStorageService.getString(
      AppConstants.prefMobile,
    )!;
    _emailController.text = localStorageService.getString(
      AppConstants.prefEmail,
    )!;
    print("Loaded prefMobile = ${localStorageService.getString(AppConstants.prefMobile)}");
    print("Loaded prefEmail = ${localStorageService.getString(AppConstants.prefEmail)}");

  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Personalise Profile',
        ),
        centerTitle: true,
      ),
      body:  Consumer<ProfileProvider>(
        builder: (context, provider, child) {
      final state = provider.updateProfileState;

      if (state is Loading) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }

      if (state is Error) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Something went wrong",
                style: const TextStyle(color: Colors.red, fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async{
                  final parts = _fullNameController.text.split(" ");
                  final firstName = parts.isNotEmpty ? parts[0] : "";
                  final lastName = parts.length > 1 ? parts[1] : "";

                  await provider.updateProfile(
                    firstName,
                    lastName,
                    _emailController.text,
                    context,
                  );
                },
                child: const Text("Retry"),
              ),
            ],
          ),
        );
      }

      return _buildMainForm(context, provider);
    },
    ),


    );
  }

  Widget _buildMainForm(BuildContext context, ProfileProvider provider) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Divider(thickness: 0.5, color: Colors.grey.shade500),
                  _buildGenderSection(),
                  const SizedBox(height: 14),
                  _buildInputField(
                    label: 'Full Name',
                    icon: Icons.person_outline,
                    controller: _fullNameController,
                  ),
                  const SizedBox(height: 14),
                  _buildInputField(
                    label: 'Phone Number',
                    icon: Icons.phone_outlined,
                    controller: _phoneController,
                  ),
                  const SizedBox(height: 14),
                  _buildInputField(
                    label: 'Email Address',
                    icon: Icons.email_outlined,
                    controller: _emailController,
                  ),
                ],
              ),
            ),
          ),
          _buildBottomButtons(context, provider),
        ],
      ),
    );
  }

  Widget _buildBottomButtons(BuildContext context, ProfileProvider provider) {
    return Column(
      children: [
        Text(
          'Complete your profile for better experience',
          style: TextStyle(color: Colors.grey[600], fontSize: 12),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            onPressed: () async {
              final parts = _fullNameController.text.trim().split(" ");
              final firstName = parts.isNotEmpty ? parts[0] : "";
              final lastName = parts.length > 1 ? parts.sublist(1).join(" ") : "";
              final email = _emailController.text.trim();

              // ✅ Validation checks
              if (firstName.isEmpty || lastName.isEmpty || email.isEmpty) {
                ToastHelper.showErrorSnackBar(context, "Please fill all the fields");
                return;
              }

              final emailRegex = RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$');
              if (!emailRegex.hasMatch(email)) {
                ToastHelper.showErrorSnackBar(context, "Please enter a valid email address");
                return;
              }

              // ✅ Trigger updateProfile
              await provider.updateProfile(firstName, lastName, email, context);

              // ✅ Navigate ONLY if API success
              final state = provider.updateProfileState;
              if (state is Success) {
                if (widget.isVerified) {
                  Navigator.pushReplacementNamed(
                    context,
                    AppConstants.navigateToOnBoardingScreen,
                  );
                } else {
                  Navigator.pushReplacementNamed(
                    context,
                    AppConstants.navigateToDashboardScreen,
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Appcolor.mehrun,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Submit',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),

        // ✅ Do It Later → skip API, direct to onboarding
        if (widget.isVerified)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: TextButton(
              onPressed: () {
                Navigator.pushReplacementNamed(
                  context,
                  AppConstants.navigateToOnBoardingScreen,
                );
              },
              child: Text(
                'Do It Later',
                style: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildInputField({
    required String label,
    required IconData icon,
    required TextEditingController controller,
  }) {
    return Padding(
      padding: EdgeInsetsGeometry.only(left: 16,right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 14)),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(icon, color: Colors.grey[400], size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: TextFormField(
                  controller: controller,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                  style: const TextStyle(color: Colors.black, fontSize: 16),
                ),
              ),
            ],
          ),
          Divider(thickness: 1,color: Appcolor.withOpacity(Appcolor.grey, 0.6),)
        ],
      ),
    );
  }

  void _showGenderBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Select Gender',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 20),
              ...['Male', 'Female', 'Other'].map(
                (gender) => ListTile(
                  title: Text(gender),
                  onTap: () {
                    setState(() {
                      _selectedGender = gender;
                    });
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildGenderSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Gender", style: TextStyle(color: Colors.grey[600], fontSize: 14)),
          const SizedBox(height: 8),
          InkWell(
            onTap: () => _showGenderBottomSheet(),
            child: Row(
              children: [
                Icon(Icons.wc, color: Colors.grey[400], size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _selectedGender,
                    style: const TextStyle(color: Colors.black, fontSize: 16),
                  ),
                ),
                const Icon(Icons.arrow_drop_down, color: Colors.grey),
              ],
            ),
          ),
          Divider(
            thickness: 1,
            color: Appcolor.withOpacity(Appcolor.grey, 0.6),
          )
        ],
      ),
    );
  }

}
