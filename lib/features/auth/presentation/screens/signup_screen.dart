import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:multi_screen_app_with_navigation/core/utils/responsive.dart';
import 'package:multi_screen_app_with_navigation/features/auth/presentation/provider/auth_provider.dart';
import 'package:multi_screen_app_with_navigation/features/auth/presentation/widget/custom_textfield.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  bool obscureConfirmPassword = true;
  bool obscurePassword = true;
  final formKey = GlobalKey<FormState>();
  static const String titleLogin = "Inscription";
  static const String textButtonValue = "Connectez-vous";
  static const String hintTextUsername = "Skred";
  static const String labelTextUsername = "Nom d'utilisateur";
  static const String hintTextEmail = "Ruddy@gmail.com";
  static const String labelTextEmail = "Email";
  static const String hintTextPassword = "********";
  static const String labelTextPassword = "Mot de passe";
  static const String hintTextConfirmPassword = "*********";
  static const String labelTextConfirmPassword = "Confirme le mot de passe";
  static const String labelButton = "S'inscrire";
  static const String messageResultSignUp = "Utilisateur créé";
  String? emailValue;
  String? usernameValue;
  String? passwordvalue;
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authValue = ref.watch(authProvider);
    void submit() {
      print("Validation du formulaire...");
      if (!formKey.currentState!.validate()) {
        print("Formulaire invalide !");
        return;
      }
      formKey.currentState!.save();
      print("Email: $emailValue, Password: $passwordvalue");
      ref
          .read(authProvider.notifier)
          .signUp(emailValue!, passwordvalue!, usernameValue!);
    }

    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(context.padding),
          child: Form(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            key: formKey,
            child: Center(
              child: SizedBox(
                width: context.formWidth,
                child: Column(
                  spacing: context.spacing,
                  children: [
                    Text(
                      titleLogin,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: context.titleFontSize,
                      ),
                    ),

                    Column(
                      spacing: context.fieldSpacing * 2,
                      children: [
                        CustomTextfield(
                          hintTextValue: hintTextUsername,
                          fontWeight: FontWeight.w300,
                          radius: context.radius,
                          labelText: labelTextUsername,
                          spacing: context.fieldSpacing,
                          validatorFunction: (value) {
                            if (value == null || value.isEmpty) {
                              return "Veuillez remplir ce champ";
                            }
                            if (value.length < 5) return "Nom trop court";
                            return null;
                          },
                          onSavedFunction: (value) => usernameValue = value,
                        ),
                        CustomTextfield(
                          hintTextValue: hintTextEmail,
                          fontWeight: FontWeight.w300,
                          radius: context.radius,
                          labelText: labelTextEmail,
                          spacing: context.fieldSpacing,
                          validatorFunction: (value) {
                            if (value == null || value.isEmpty) {
                              return "Veuillez remplir ce champ";
                            }
                            if (!value.contains('@')) {
                              return "Format email invalide";
                            }
                            return null;
                          },
                          onSavedFunction: (value) => emailValue = value,
                        ),
                        CustomTextfield(
                          controller: passwordController,
                          obscureText: obscurePassword,
                          isFieldPassword: true,
                          onPressedFunction: () {
                            setState(() => obscurePassword = !obscurePassword);
                          },
                          onSavedFunction: (value) => passwordvalue = value,
                          hintTextValue: hintTextPassword,
                          fontWeight: FontWeight.w300,
                          radius: context.radius,
                          labelText: labelTextPassword,
                          spacing: context.fieldSpacing,
                          validatorFunction: (value) {
                            if (value == null || value.isEmpty) {
                              return "Veuillez remplir ce champ";
                            }
                            if (value.length < 8) {
                              return "Mot de passe trop court";
                            }
                            return null;
                          },
                        ),
                        CustomTextfield(
                          controller: confirmPasswordController,
                          obscureText: obscureConfirmPassword,
                          isFieldPassword: true,
                          onPressedFunction: () {
                            setState(() {
                              obscureConfirmPassword = !obscureConfirmPassword;
                            });
                          },
                          hintTextValue: hintTextConfirmPassword,
                          fontWeight: FontWeight.w300,
                          radius: context.radius,
                          labelText: labelTextConfirmPassword,
                          spacing: context.fieldSpacing,
                          validatorFunction: (value) {
                            if (value == null || value.isEmpty) {
                              return "Veuillez remplir ce champ";
                            }
                            if (value.length < 8) {
                              return "Mot de passe trop court";
                            }
                            if (passwordController.value.text != value) {
                              return "le mot de passe ne se ressemble pas";
                            }
                            return null;
                          },
                          onSavedFunction: (value) {},
                        ),
                      ],
                    ),

                    SizedBox(
                      height: context.buttonHeight,
                      width: context.formWidth,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () => submit(),
                        child: Text(labelButton),
                        // onPressed: isLoading ? null : _submit,
                        // child: isLoading
                        //     ? const SizedBox(
                        //         height: 20,
                        //         width: 20,
                        //         child: CircularProgressIndicator(
                        //           color: Colors.white,
                        //           strokeWidth: 2,
                        //         ),
                        //       )
                        //     : Text(
                        //         labelButton,
                        //         style: TextStyle(
                        //           fontSize: context.bodyFontSize,
                        //         ),
                        //       ),
                      ),
                    ),

                    Wrap(
                      alignment: WrapAlignment.center,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          "Vous avez déjà un compte?",
                          style: TextStyle(fontSize: context.bodyFontSize),
                        ),
                        TextButton(
                          onPressed: () => context.pop(),
                          child: Text(
                            textButtonValue,
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

//  response : {"access_token":"eyJhbGciOiJFUzI1NiIsImtpZCI6IjhhOTdiZWYxLTcxYmQtNDFmYy1hZDIwLWIwOTEwNDk3MzM1YyIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJodHRwczovL2J5dmNtdWZuYXpiemxjd2luZ3NuLnN1cGFiYXNlLmNvL2F1dGgvdjEiLCJzdWIiOiI3ZTU1NTdjNC01ZDVjLTQ3MTUtYjNkZC04OTEzNDFmZDAxZjAiLCJhdWQiOiJhdXRoZW50aWNhdGVkIiwiZXhwIjoxNzg5NTE2MzMyLCJpYXQiOjE3ODk1MTI3MzIsImVtYWlsIjoicnVkZHlAZ21haWwuY29tIiwicGhvbmUiOiIiLCJhcHBfbWV0YWRhdGEiOnsicHJvdmlkZXIiOiJlbWFpbCIsInByb3ZpZGVycyI6WyJlbWFpbCJdfSwidXNlcl9tZXRhZGF0YSI6eyJlbWFpbCI6InJ1ZGR5QGdtYWlsLmNvbSIsImVtYWlsX3ZlcmlmaWVkIjp0cnVlLCJwaG9uZV92ZXJpZmllZCI6ZmFsc2UsInN1YiI6IjdlNTU1N2M0LTVkNWMtNDcxNS1iM2RkLTg5MTM0MWZkMDFmMCIsInVzZXJuYW1lIjoic2tyZWQifSwicm9sZSI6ImF1dGhlbnRpY2F0ZWQiLCJhYWwiOiJhYWwxIiwiYW1yIjpbeyJtZXRob2QiOiJwYXNzd29yZCIsInRpbWVzdGFtcCI6MTc4OTUxMjczMn1dLCJzZXNzaW9uX2lkIjoiMDcxNmZjYWUtY2Y0Yy00OWMwLWJjOTQtOTQ3ZGEzNzA5MDdkIiwiaXNfYW5vbnltb3VzIjpmYWxzZX0.cjNThE0N14I7suyCSI2U5pl7-oyg8Hcyc958pfBO5LeuYoazjJx-SiGPAGnJXG_ad2tnlj83dqKbD0VLWVeLtg","token_type":"bearer","expires_in":3600,"expires_a
