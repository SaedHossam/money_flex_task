import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frontend/providers/auth_provider.dart';
import 'package:frontend/models/user.dart';

class LoginScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              if (authProvider.errorMessage != null)
                Text(
                  authProvider.errorMessage!,
                  style: TextStyle(color: Colors.red),
                ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: authProvider.isLoading
                    ? null
                    : () async {
                        if (_formKey.currentState!.validate()) {
                          final user = User(
                            email: _emailController.text,
                            password: _passwordController.text,
                          );
                          final success = await authProvider.login(user);
                          if (success && context.mounted) {
                            Navigator.pushReplacementNamed(context, '/customers');
                          }
                        }
                      },
                child: authProvider.isLoading
                    ? CircularProgressIndicator()
                    : Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}