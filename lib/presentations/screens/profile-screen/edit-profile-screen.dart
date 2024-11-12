import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../logic/authCubit/auth_cubit.dart';
import '../../widgets/editprofile-screen-widgets/edit-profile-app-bar-widget.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController nameController;
  late TextEditingController userNameController;
  late TextEditingController websiteController;
  late TextEditingController bioController;
  late TextEditingController emailController;
  late TextEditingController genderController;
  late TextEditingController phoneController;


  @override
  void initState() {
    super.initState();
    // Fetch user info when the screen initializes
    context.read<AuthCubit>().fetchUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
        if (state is AuthSuccess) {
          // Fetch user info again to get updated data
          context.read<AuthCubit>().fetchUserInfo(); // Fetch updated user info
          Navigator.pop(context);
        }

      },
      builder: (context, state) {
        if (state is AuthLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (state is UserInfoLoaded) {
          // Initialize controllers with the loaded user info
          final userInfo = state.userInfo;
          nameController = TextEditingController(text: userInfo.name);
          userNameController = TextEditingController(text: userInfo.userName);
          websiteController = TextEditingController(text: userInfo.website);
          bioController = TextEditingController(text: userInfo.bio);
          emailController = TextEditingController(text: userInfo.email);
          genderController = TextEditingController(text: userInfo.gender);
          phoneController = TextEditingController(text: userInfo.phone);


          return SafeArea(
            child: Scaffold(
              body: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12),
                      child: Column(
                        children: [
                          CustomEditProfileAppBar(
                            onTap: () {
                              context.read<AuthCubit>().updateUserProfile(
                                name: nameController.text,
                                userName: userNameController.text,
                                website: websiteController.text,
                                bio: bioController.text,
                                email: emailController.text,
                                gender: genderController.text,
                                  phone: phoneController.text

                              );                            },
                          ),
                          SizedBox(height: 30.h),
                          Container(
                            width: 90.w,
                            height: 90.h,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white, width: 1),
                                ),
                                child: userInfo.profilePicture != null && userInfo.profilePicture!.isNotEmpty
                                    ? Image.network(
                                  userInfo.profilePicture.toString(),
                                  fit: BoxFit.fill,
                                )
                                    : const SizedBox(),
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          GestureDetector(
                            onTap: () {
                              context.read<AuthCubit>().pickImage();
                            },
                            child: Text(
                              'Change Profile Photo',
                              style: TextStyle(color: Colors.blue),
                            ),
                          ),
                          SizedBox(height: 20.h),
                          buildTextField('Name', nameController),
                          buildTextField('Username', userNameController),
                          buildTextField('Website', websiteController),
                          buildTextField('Bio', bioController, maxLines: 2),
                        ],
                      ),
                    ),
                    Divider(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Switch to Professional Account', style: TextStyle(color: Colors.blue)),
                          buildTextField('Email', emailController),
                          buildTextField('Phone', phoneController),
                          buildTextField('Gender', genderController),
                          SizedBox(height: 20.h),
                          // Done Button
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }

  // Helper method to create text fields
  Widget buildTextField(String label, TextEditingController controller, {int maxLines = 1}) {
    return Row(
      children: [
        Container(width: 100, child: Text(label)),
        SizedBox(width: 30),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: controller,
              maxLines: maxLines,
            ),
          ),
        ),
      ],
    );
  }
}
