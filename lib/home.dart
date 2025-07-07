import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:surabayaplace/cafe.dart';
import 'package:surabayaplace/taman.dart';
import 'package:surabayaplace/wisata.dart';
import 'package:surabayaplace/taman.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final isAdmin = user?.email == 'admin@gmail.com';
    final greetingText = isAdmin ? 'Hai Admin!' : 'Hai, User!';

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // HEADER DENGAN GAMBAR FULL
            Container(
              height: 300,
              width: double.infinity,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    'assets/images/header.webp',
                    fit: BoxFit.cover,
                  ),
                  Container(
                    color: Colors.black.withOpacity(0.3),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Align(
                          alignment: Alignment.topRight,
                          child: IconButton(
                            icon: Icon(Icons.logout, color: Colors.white),
                            onPressed: () async {
                              final confirm = await showDialog<bool>(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: Text('Konfirmasi Logout'),
                                  content: Text('Apakah kamu yakin ingin logout?'),
                                  actions: [
                                    TextButton(
                                      child: Text('Batal'),
                                      onPressed: () => Navigator.of(ctx).pop(false),
                                    ),
                                    TextButton(
                                      child: Text('Logout'),
                                      onPressed: () => Navigator.of(ctx).pop(true),
                                    ),
                                  ],
                                ),
                              );

                              if (confirm == true) {
                                await FirebaseAuth.instance.signOut();
                                Navigator.pushReplacementNamed(context, '/login');
                              }
                            },
                          ),
                        ),
                        const Spacer(),
                        Text(
                          'Selamat Datang di Surabaya Place',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            shadows: [Shadow(blurRadius: 4, color: Colors.black26)],
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: const TextField(
                            decoration: InputDecoration(
                              icon: Icon(Icons.search),
                              hintText: 'Temukan rekomendasi tempat',
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // GREETING
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  greetingText,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.green.shade900,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // MENU BUTTON
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  _buildMenuItem('Cafe', 'assets/images/icon_cafe.png', context),
                  const SizedBox(height: 16),
                  _buildMenuItem('Wisata', 'assets/images/icon_wisata.png', context),
                  const SizedBox(height: 16),
                  _buildMenuItem('Taman', 'assets/images/icon_taman.png', context),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(String title, String iconPath, BuildContext context) {
    return InkWell(
      onTap: () {
        if (title == 'Cafe') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CafePage()),
          );
        } else if (title == 'Wisata') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const WisataPage()),
          );
        } else if (title == 'Taman') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const TamanPage()),
          );
        }
      },

      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3))],
        ),
        child: Row(
          children: [
            Image.asset(iconPath, height: 48),
            const SizedBox(width: 20),
            Text(
              title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}