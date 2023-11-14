import 'package:declarative_route/model/login.dart';
import 'package:declarative_route/provider/auth_provider.dart';
import 'package:declarative_route/widget/Snackbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:declarative_route/widget/platform_widget.dart';

class LoginScreen extends StatefulWidget {
  final Function() onLogin;
  final Function() onRegister;
  const LoginScreen({
    required this.onLogin,
    required this.onRegister,
    Key? key,
  }) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();

  final passwordController = TextEditingController();
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  final formKey = GlobalKey<FormState>();
  _buildList() {
    return Center(
      child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 300),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: emailController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email.';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    hintText: "Email",
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    hintText: "Password",
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8),
                context.watch<AuthProvider>().isLoadingLogin
                    ? const Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            final scaffoldMessenger =
                                ScaffoldMessenger.of(context);
                            final LoginRequest user = LoginRequest(
                              email: emailController.text,
                              password: passwordController.text,
                            );
                            final authRead = context.read<AuthProvider>();

                            await authRead.login(user);
                            if (!authRead.isError) {
                              showCustomSnackBar(context, "Login Succesfully",
                                  Colors.greenAccent);
                              widget.onLogin();
                            } else {
                              scaffoldMessenger.showSnackBar(
                                const SnackBar(
                                  content:
                                      Text("Your email or password is invalid"),
                                  backgroundColor: Colors.redAccent,
                                ),
                              );
                            }
                          }
                        },
                        child: const Text("LOGIN"),
                      ),
                const SizedBox(height: 8),
                OutlinedButton(
                  onPressed: () => widget.onRegister(),
                  child: const Text("REGISTER"),
                ),
              ],
            ),
          )),
    );
  }

  Widget _buildAndroid(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login Screen"),
      ),
      body: _buildList(),
    );
  }

  Widget _buildIos(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text("Login Screen"),
      ),
      child: _buildList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(androidBuilder: _buildAndroid, iosBuilder: _buildIos);
  }
}
