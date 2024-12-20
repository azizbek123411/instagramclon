
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clon/utility/screen_utils.dart';

import '../../../../../utility/app_padding.dart';
import '../../cubits/auth_cubit.dart';
import '../../widgets/buttons.dart';
import '../../widgets/textfields.dart';

class SignUpPage extends StatefulWidget {
  final void Function()? onTap;

  const SignUpPage({super.key, required this.onTap});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  void register() {
    final String name = nameController.text;
    final String email = emailController.text;
    final String pw = passwordController.text;
    final String confirmPW = confirmPasswordController.text;

    final authCubit = context.read<AuthCubit>();

    if (name.isNotEmpty &&
        email.isNotEmpty &&
        pw.isNotEmpty &&
        confirmPW.isNotEmpty) {
      if (pw == confirmPW) {
        authCubit.register(email, name, pw);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Passwords do not match'),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please, fill the fields'),
        ),
      );
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.selection;
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Padding(
        padding: Dis.all(10),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.person,
                color: Theme.of(context).colorScheme.primary,
                size: 60,
              ),
              const SizedBox(
                height: 15,
              ),
              Text(
                "Create account",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 20,
                ),
              ),
              SizedBox(
                height: 30.h,
              ),
              TextFields(
                hintText: 'Enter name',
                controller: nameController,
              ),
              SizedBox(
                height: 10.h,
              ),
              TextFields(
                hintText: 'Enter your email',
                controller: emailController,
              ),
              SizedBox(
                height: 10.h,
              ),
              TextFields(
                hintText: 'Enter your password',
                controller: passwordController,
              ),
              SizedBox(
                height: 10.h,
              ),
              TextFields(
                hintText: 'Confirm your password',
                controller: confirmPasswordController,
              ),
              SizedBox(
                height: 30.h,
              ),
              Buttons(
                color: Theme.of(context).colorScheme.primary,
                h: 50.h,
                w: double.infinity,
                title: 'Sign Up',
                r: 10,
                onTap: register,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Already a member?',
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 15,
                    ),
                  ),
                  TextButton(
                    onPressed: widget.onTap,
                    child: Text(
                      'Login',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
