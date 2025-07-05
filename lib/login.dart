import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'provider/auth_provider.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    auth.islogin = true; // tandai ini halaman login

    return Scaffold(
      backgroundColor: Colors.green.shade800,
      body: SafeArea(
        child: Form(
          key: auth.form,
          child: Column(
            children: [
              SizedBox(height: 70),
              Image.asset('assets/images/patung_surabaya.png', height: 250),
              SizedBox(height: 20),
              Text('Welcome back...', style: TextStyle(fontSize: 24, color: Colors.white)),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    TextFormField(
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.email),
                        hintText: 'Email',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      validator: (value) {
                        if (value == null || !value.contains('@')) return 'Email tidak valid';
                        return null;
                      },
                      onSaved: (value) => auth.enteredEmail = value!,
                    ),
                    SizedBox(height: 15),
                    TextFormField(
                      obscureText: true,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.lock),
                        hintText: 'Password',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      validator: (value) {
                        if (value == null || value.length < 6) return 'Minimal 6 karakter';
                        return null;
                      },
                      onSaved: (value) => auth.enteredPassword = value!,
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () => auth.submit(context),
                      child: Text('SIGN IN'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade100,
                        foregroundColor: Colors.green.shade800,
                        minimumSize: Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                    SizedBox(height: 10),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/register');
                      },
                      child: Text('Don’t have an account? Register', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
