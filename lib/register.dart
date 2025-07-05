import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'provider/auth_provider.dart';

class RegisterPage extends StatefulWidget {
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> with SingleTickerProviderStateMixin {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  late AnimationController _controller;
  late Animation<Color?> _color1;
  late Animation<Color?> _color2;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 5),
      vsync: this,
    )..repeat(reverse: true);

    _color1 = ColorTween(begin: Colors.green.shade200, end: Colors.lightGreen.shade300).animate(_controller);
    _color2 = ColorTween(begin: Colors.green.shade400, end: Colors.teal.shade300).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    auth.islogin = false;

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
                    SizedBox(height: 40),
                    SizedBox(height: 100),
                    Text(
                      'Create your account',
                      style: TextStyle(fontSize: 22, color: Colors.green.shade900),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          _buildInputField(
                            icon: Icons.email,
                            hint: 'Email',
                            validator: (value) {
                              if (value == null || !value.contains('@')) return 'Email tidak valid';
                              return null;
                            },
                            onSaved: (value) => auth.enteredEmail = value!,
                          ),
                          SizedBox(height: 10),
                          _buildInputField(
                            controller: _passwordController,
                            icon: Icons.lock,
                            hint: 'Password',
                            obscure: true,
                            validator: (value) {
                              if (value == null || value.length < 6) return 'Minimal 6 karakter';
                              return null;
                            },
                            onSaved: (value) => auth.enteredPassword = value!,
                          ),
                          SizedBox(height: 10),
                          _buildInputField(
                            controller: _confirmPasswordController,
                            icon: Icons.verified,
                            hint: 'Verifikasi Password',
                            obscure: true,
                            validator: (value) {
                              if (value != _passwordController.text) return 'Password tidak sama';
                              return null;
                            },
                          ),
                          SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () => auth.submit(context),
                            child: Text('SIGN UP'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green.shade800,
                              foregroundColor: Colors.white,
                              minimumSize: Size(double.infinity, 50),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                          ),
                          SizedBox(height: 10),
                          TextButton(
                            onPressed: () => Navigator.pushNamed(context, '/login'),
                            child: Text('Already have an account? Sign In'),
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

  Widget _buildInputField({
    required IconData icon,
    required String hint,
    bool obscure = false,
    TextEditingController? controller,
    String? Function(String?)? validator,
    void Function(String?)? onSaved,
  }) {
    return TextFormField(
      controller: controller,
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
