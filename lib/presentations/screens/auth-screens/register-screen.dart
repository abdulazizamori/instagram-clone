import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instaclone/logic/authCubit/auth_cubit.dart';
import 'package:instaclone/main.dart';
import 'package:instaclone/presentations/screens/auth-screens/login-screen.dart';
import 'package:instaclone/shared/widgets/logo-widget.dart';

import '../../widgets/register-widgets/elevated-button-widget.dart';
import '../../widgets/register-widgets/text-button-widget.dart';
import '../../widgets/register-widgets/textfield-widget.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AuthCubit>();
    return BlocConsumer<AuthCubit, AuthState>(builder: (context, state) {
      return SafeArea(
        child: Scaffold(
          body: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  LogoWidget(),
                  SizedBox(
                    height: 20,
                  ),
                  CustomTextField(
                    hint: 'Name',
                    controller: name, textFieldType: false,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  CustomTextField(
                    hint: 'Email',
                    controller: email, textFieldType: false,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  CustomTextField(hint: 'Password', controller: password, textFieldType: true,),
                  SizedBox(
                    height: 20,
                  ),
                  CustomElevatedButton(
                    text: 'Sign up',
                    onpressed: () async {
                      if (name.text.isNotEmpty &&
                          email.text.isNotEmpty &&
                          password.text.isNotEmpty) {
                        await cubit.signUpWithEmailAndPassword(
                            email.text.trim(), password.text.trim(),name.text.trim());
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Please fill in all fields")),
                        );
                      }
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  CustomTextButton(
                    text: 'Do you have an account?',
                    onpressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  LogInScreen()));
                    },
                    textButton: 'Sign in',
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }, listener: (context, state) {
      if (state is UserCreateSuccess) {
        Navigator.pushReplacementNamed(
            context,'login');
      }else if (state is AuthError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(state.message)),
        );
      }
    });
  }
}
