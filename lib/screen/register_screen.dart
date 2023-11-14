import 'package:declarative_route/model/register.dart';
import 'package:declarative_route/provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:declarative_route/widget/platform_widget.dart';

class RegisterScreen extends StatefulWidget {
  final Function() onLogin;
  final Function() onRegister;
  const RegisterScreen({
    required this.onLogin,
    required this.onRegister,
    Key? key,
  }) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final emailController = TextEditingController();

  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
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
                  controller: nameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name.';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    hintText: "Name",
                  ),
                ),
                const SizedBox(height: 8),
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
                context.watch<AuthProvider>().isLoadingRegister
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : OutlinedButton(
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            final RegisterRequest user = RegisterRequest(
                              email: emailController.text,
                              password: passwordController.text,
                              name: nameController.text,
                            );
                            final authRead = context.read<AuthProvider>();
                            await authRead.saveUser(user);
                            if (authRead.isError) {
                              String message = authRead.isErrorMessage;
                              if (message.isNotEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(message),
                                    backgroundColor: Colors.redAccent,
                                  ),
                                );
                              }
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('success registerd'),
                                  backgroundColor: Colors.greenAccent,
                                ),
                              );
                              widget.onLogin();
                            }
                          }
                        },
                        child: const Text("REGISTER"),
                      ),
                const SizedBox(height: 8),
                context.watch<AuthProvider>().isLoadingLogin
                    ? const Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                        onPressed: () => widget.onLogin(),
                        child: const Text("LOGIN"),
                      ),
                const SizedBox(height: 8),
              ],
            ),
          )),
    );
  }

  Widget _buildAndroid(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register Screen"),
      ),
      body: _buildList(),
    );
  }

  Widget _buildIos(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text("Register Screen"),
      ),
      child: _buildList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(androidBuilder: _buildAndroid, iosBuilder: _buildIos);
  }
}
