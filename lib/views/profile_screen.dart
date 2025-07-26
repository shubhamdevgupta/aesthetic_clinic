import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    String? selectedGender;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          'Personalise Profile',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: ListView(
          children: [
            const Divider(thickness: 1.2, color: Colors.grey),
            const SizedBox(height: 24),

            // Gender Dropdown
            const Text("Gender", style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  icon: Icon(Icons.person_outline),
                  border: InputBorder.none,
                ),
                icon: const Icon(Icons.arrow_drop_down),
                hint: const Text("Select Gender"),
                items: ['Male', 'Female', 'Other']
                    .map((gender) => DropdownMenuItem(
                  value: gender,
                  child: Text(gender),
                ))
                    .toList(),
                onChanged: (value) {
                  selectedGender = value;
                },
              ),
            ),
            const SizedBox(height: 24),

            // Full Name
            const Text("Full Name", style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 6),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.mail_outline),
                hintText: 'Tanya Myroniuk',
                border: UnderlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),

            // Phone Number
            const Text("Phone Number", style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 6),
            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.call_outlined),
                hintText: '+8801712663389',
                border: UnderlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),

            // Email Address
            const Text("Email Address", style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 6),
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.mail_outline),
                hintText: 'tanya.myroniuk@gmail.com',
                border: UnderlineInputBorder(),
              ),
            ),

            const SizedBox(height: 48),
            const Center(
              child: Text(
                "Complete your profile for better experience",
                style: TextStyle(color: Colors.grey),
              ),
            ),
            const SizedBox(height: 24),

            // Submit Button
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF660033), // Dark maroon
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {},
                child: const Text("Submit", style: TextStyle(fontSize: 16,color: Colors.white)),
              ),
            ),

            const SizedBox(height: 12),

            // Do It Later
            Center(
              child: TextButton(
                onPressed: () {},
                child: const Text(
                  "Do it Later",
                  style: TextStyle(
                    color: Colors.grey,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
