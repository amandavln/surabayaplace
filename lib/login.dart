import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'provider/auth_provider.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _color1;
  late Animation<Color?> _color2;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    )..repeat(reverse: true);

    _color1 = ColorTween(begin: Colors.green.shade400, end: Colors.teal.shade900).animate(_controller);
    _color2 = ColorTween(begin: Colors.lightGreen.shade200, end: Colors.greenAccent.shade100).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    auth.islogin = true;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Scaffold(
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [_color1.value!, _color2.value!],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: SafeArea(
              child: Form(
                key: auth.form,
                child: Column(
                  children: [
                    const SizedBox(height: 70),
                    Image.asset('assets/images/patung_surabaya.png', height: 250),
                    const SizedBox(height: 20),
                    const Text('Welcome back...', style: TextStyle(fontSize: 24, color: Colors.white)),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          _buildTextField(
                            icon: Icons.email,
                            hint: 'Email',
                            validator: (v) => v == null || !v.contains('@') ? 'Email tidak valid' : null,
                            onSaved: (v) => auth.enteredEmail = v!,
                          ),
                          const SizedBox(height: 15),
                          _buildTextField(
                            icon: Icons.lock,
                            hint: 'Password',
                            obscure: true,
                            validator: (v) => v == null || v.length < 6 ? 'Minimal 6 karakter' : null,
                            onSaved: (v) => auth.enteredPassword = v!,
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () => auth.submit(context),
                            child: const Text('SIGN IN'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.green.shade900,
                              minimumSize: const Size(double.infinity, 50),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextButton(
                            onPressed: () => Navigator.pushNamed(context, '/register'),
                            child: const Text('Don’t have an account? Register', style: TextStyle(color: Colors.white)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTextField({
    required IconData icon,
    required String hint,
    bool obscure = false,
    String? Function(String?)? validator,
    void Function(String?)? onSaved,
  }) {
    return TextFormField(
      obscureText: obscure,
      decoration: InputDecoration(
        prefixIcon: Icon(icon),
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      validator: validator,
      onSaved: onSaved,
    );
  }
}

