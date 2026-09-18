import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:multi_screen_app_with_navigation/core/utils/responsive.dart';
import 'package:multi_screen_app_with_navigation/features/auth/data/model/auth_response_model.dart';
import 'package:multi_screen_app_with_navigation/features/auth/presentation/provider/auth_provider.dart';
import 'package:multi_screen_app_with_navigation/features/auth/presentation/widget/custom_textfield.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  bool obscurePassword = true;
  static const String titleLogin = "Connexion";
  static const String hintTextEmail = "Ruddy@gmail.com";
  static const String labelTextEmail = "Email";
  static const String hintTextPassword = "********";
  static const String labelTextPassword = "Mot de passe";
  static const String labelButton = "Se connecter";
  // static const String messageResultLogin = "Connexion réussie";

  String? email;
  String? password;
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final isLoading = authState.isLoading;

    ref.listen(authProvider, (previous, next) {
      if (next.hasError && !next.isLoading) {
        ScaffoldMessenger.of(context)
          ..clearSnackBars()
          ..showSnackBar(
            SnackBar(
              backgroundColor: Colors.red,
              content: Text(next.error.toString()),
            ),
          );
      }
      if (previous?.isLoading == true && !next.hasError && !next.isLoading) {
        ScaffoldMessenger.of(context)
          ..clearSnackBars()
          ..showSnackBar(
            const SnackBar(
              backgroundColor: Colors.green,
              content: Text("Connexion réussie"),
            ),
          );
      }
    });
    void submit() {
      ScaffoldMessenger.of(context).clearSnackBars();
      print("Validation du formulaire...");
      if (!formKey.currentState!.validate()) {
        print("Formulaire invalide !");
        return;
      }
      formKey.currentState!.save();
      print("Email: $email, Password: $password");

      ref.read(authProvider.notifier).signIn(email!, password!);
    }

    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(context.padding),
          child: Form(
            key: formKey,
            child: Center(
              child: SizedBox(
                width: context.formWidth,
                child: Column(
                  spacing: context.spacing,
                  children: [
                    SizedBox(
                      height: context.buttonHeight,
                      width: context.formWidth,
                      child: Center(
                        child: Text(
                          titleLogin,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: context.titleFontSize,
                          ),
                        ),
                      ),
                    ),

                    CustomTextfield(
                      hintTextValue: hintTextEmail,
                      fontWeight: FontWeight.w300,
                      radius: context.radius,
                      labelText: labelTextEmail,
                      spacing: context.fieldSpacing,
                      onSavedFunction: (value) => email = value,
                      validatorFunction: (value) {
                        if (value == null || value.isEmpty) {
                          return "Veuillez remplir ce champ";
                        }
                        if (!value.contains('@')) {
                          return "Format email invalide";
                        }
                        return null;
                      },
                    ),
                    CustomTextfield(
                      obscureText: obscurePassword,
                      isFieldPassword: true,
                      onPressedFunction: () {
                        setState(() => obscurePassword = !obscurePassword);
                      },
                      onSavedFunction: (value) => password = value,
                      hintTextValue: hintTextPassword,
                      fontWeight: FontWeight.w300,
                      radius: context.radius,
                      labelText: labelTextPassword,
                      spacing: context.fieldSpacing,
                      validatorFunction: (value) {
                        if (value == null || value.isEmpty) {
                          return "Veuillez remplir ce champ";
                        }
                        return null;
                      },
                    ),

                    SizedBox(
                      height: context.buttonHeight,
                      width: context.formWidth,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: isLoading
                            ? null
                            : () {
                                submit();
                              },
                        child: isLoading
                            ? CircularProgressIndicator()
                            : Text(labelButton),
                      ),
                    ),

                    Wrap(
                      alignment: WrapAlignment.center,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          "Pas de compte?",
                          style: TextStyle(fontSize: context.bodyFontSize),
                        ),
                        TextButton(
                          onPressed: () => context.push("/signup"),
                          child: Text(
                            "Inscrivez-vous ici",
                            style: TextStyle(fontSize: context.bodyFontSize),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
