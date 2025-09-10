import 'package:aesthetic_clinic/providers/profile_provider.dart';
import 'package:aesthetic_clinic/services/LocalStorageService.dart';
import 'package:aesthetic_clinic/utils/AppConstants.dart';
import 'package:aesthetic_clinic/views/profile_screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
        elevation: 0,
        leading: BackButton(onPressed: (){Navigator.pop(context);} ,),
        title: const Text(
          'Personalise Profile',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Consumer<ProfileProvider>(
        builder: (context, provider, child) {
          return Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Gender Dropdown
                        Divider(thickness:0.5,color: Colors.grey.shade500,),
                        Padding(
                          padding: EdgeInsetsGeometry.only(left: 16,right: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.person_outline,
                                    color: Colors.grey[400],
                                    size: 20,
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    'Gender',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              GestureDetector(
                                onTap: _showGenderBottomSheet,
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.people_outline,
                                      color: Colors.grey[400],
                                      size: 20,
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        _selectedGender,
                                        style: TextStyle(
                                          color:
                                              _selectedGender == 'Select Gender'
                                              ? Colors.grey[500]
                                              : Colors.black,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                    Icon(
                                      Icons.keyboard_arrow_down,
                                      color: Colors.grey[400],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10,),
                        Divider(thickness:1,color: Colors.grey.shade500,),

                        const SizedBox(height: 14),

                        // Full Name Field
                        _buildInputField(
                          label: 'Full Name',
                          icon: Icons.email_outlined,
                          controller: _fullNameController,
                        ),

                        const SizedBox(height: 14),

                        // Phone Number Field
                        _buildInputField(
                          label: 'Phone Number',
                          icon: Icons.phone_outlined,
                          controller: _phoneController,
                        ),

                        const SizedBox(height: 14),

                        // Email Address Field
                        _buildInputField(
                          label: 'Email Address',
                          icon: Icons.email_outlined,
                          controller: _emailController,
                        ),

                      ],
                    ),
                  ),
                ),

                // Bottom section with message and buttons
                Column(
                  children: [
                    Text(
                      'Complete your profile for better experience',
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 24),

                    // Submit Button
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: ()async {
                          final firstName= _fullNameController.text.split(" ");
                         final success=  await provider.updateProfile(firstName[0],firstName[1]??" ", _emailController.text);
                         if(success){
                           if(widget.isVerified){
                             Navigator.pushReplacement(
                               context,
                               MaterialPageRoute(
                                 builder: (_) => const ProfileScreen(),
                               ),
                             );                           }
                           Navigator.pushReplacementNamed(
                             context,
                             AppConstants.navigateToOnBoardingScreen,
                           );
                         }else{
                           ToastHelper.showErrorSnackBar(
                             context,
                             provider.errorMsg,
                           );
                         }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:  Appcolor.mehrun,
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

                    const SizedBox(height: 16),

                    // Do It Later Button
                    if(widget.isVerified)
                      TextButton(
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

                    const SizedBox(height: 20),
                  ],
                ),
              ],
            ),
          );
        },
      ),
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
}
