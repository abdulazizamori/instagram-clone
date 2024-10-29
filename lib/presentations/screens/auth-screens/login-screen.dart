import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instaclone/logic/authCubit/auth_cubit.dart';
import 'package:instaclone/main.dart';
import 'package:instaclone/presentations/screens/auth-screens/register-screen.dart';
import 'package:instaclone/presentations/screens/theme-mode.dart';
import 'package:instaclone/shared/widgets/logo-widget.dart';

import '../../widgets/register-widgets/elevated-button-widget.dart';
import '../../widgets/register-widgets/text-button-widget.dart';
import '../../widgets/register-widgets/textfield-widget.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({super.key});

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AuthCubit>();
    return BlocConsumer<AuthCubit, AuthState>(
        builder: (context, state) {
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
                        text: 'Login',
                        onpressed: () async{
                          if (email.text.trim().isNotEmpty &&
                              password.text.trim().isNotEmpty) {
                            await cubit.signInWithEmailAndPassword(
                                email.text.trim(), password.text.trim());
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text("Please fill in all fields")),
                            );
                          }
                          },
                      ),
                      SizedBox(height: 20,),
                      CustomTextButton(text: 'Create an account ?', onpressed: () {
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => RegisterScreen()));
                      }, textButton: 'Register',),

                    ],
                  ),
                ),
              ),
            ),
          );
        },
        listener: (context, state) {
          if (state is AuthSuccess) {
            Navigator.pushReplacementNamed(context, 'mainScreen');

          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }


        });
  }
}
