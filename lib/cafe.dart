import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'fore_detail.dart';

class CafePage extends StatelessWidget {
  const CafePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final isAdmin = user?.email == 'admin@gmail.com';

    final List<Map<String, dynamic>> cafes = [
      {'name': "D'Coffee Cup", 'image': 'dcoffeecup.jpg', 'rating': 4.8},
      {'name': "De Mandailing", 'image': 'demandailing.jpg', 'rating': 4.7},
      {'name': "Fore Coffee", 'image': 'fore.jpg', 'rating': 4.5},
      {'name': "Communal Coffee", 'image': 'communal.jpg', 'rating': 4.6},
      {'name': "Calibre", 'image': 'calibre.jpg', 'rating': 4.9},
      {'name': "Mawu Coffee", 'image': 'mawu.webp', 'rating': 4.3},
      {'name': "Kopitagram", 'image': 'kopitagram.webp', 'rating': 4.4},
      {'name': "Monopole Coffee", 'image': 'monopole.webp', 'rating': 4.5},
      {'name': "Historica", 'image': 'historica.jpg', 'rating': 4.6},
      {'name': "Redback", 'image': 'redback.jpg', 'rating': 4.8},
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Rekomendasi Cafe'),
        actions: [
          if (isAdmin)
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () => _showAddCafePopup(context),
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          itemCount: cafes.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 0.75,
          ),
          itemBuilder: (context, index) {
            final cafe = cafes[index];
            return Container(
              decoration: BoxDecoration(
                color: Colors.blueGrey,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                      child: Image.asset(
                        'assets/images/${cafe['image']}',
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          cafe['name'],
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '⭐ ${cafe['rating'].toString()}',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Icon(Icons.reviews, color: Colors.white),
                        const SizedBox(width: 8),
                        if (cafe['name'] == 'Fore Coffee')
                          IconButton(
                            icon: const Icon(Icons.more_vert, color: Colors.white),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const ForeDetailPage(),
                                ),
                              );
                            },
                          )
                        else
                          const Icon(Icons.more_vert, color: Colors.white),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _showAddCafePopup(BuildContext context) {
    final nameController = TextEditingController();
    final descController = TextEditingController();
    final addrController = TextEditingController();
    final imageUrlController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: const LinearGradient(
              colors: [Color.fromARGB(255, 93, 184, 96), Color(0xFF81C784)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Tambah Tempat Cafe',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Nama Cafe',
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: addrController,
                  decoration: const InputDecoration(
                    labelText: 'Alamat',
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: descController,
                  decoration: const InputDecoration(
                    labelText: 'Deskripsi',
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: imageUrlController,
                  decoration: const InputDecoration(
                    labelText: 'Link Gambar (dummy)',
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () async {
                    try {
                      if (nameController.text.isEmpty ||
                          addrController.text.isEmpty ||
                          descController.text.isEmpty ||
                          imageUrlController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Semua field harus diisi')),
                        );
                        return;
                      }

                      await FirebaseFirestore.instance.collection('cafe').add({
                        'name': nameController.text,
                        'address': addrController.text,
                        'description': descController.text,
                        'imageUrl': imageUrlController.text,
                      });

                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Cafe berhasil ditambahkan')),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Gagal menambahkan cafe: $e')),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                  child: const Text('Submit', style: TextStyle(color: Color.fromARGB(255, 20, 67, 22))),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
