import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'bungkul_detail.dart';

class TamanPage extends StatefulWidget {
  const TamanPage({super.key});

  @override
  State<TamanPage> createState() => _TamanPageState();
}

class _TamanPageState extends State<TamanPage> {
  final user = FirebaseAuth.instance.currentUser;

  void _showAddTamanPopup(BuildContext context) {
    final nameController = TextEditingController();
    final addrController = TextEditingController();
    final descController = TextEditingController();
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
              colors: [Color.fromARGB(255, 97, 190, 130), Color.fromARGB(255, 158, 225, 176)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Tambah Data Taman',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Nama', filled: true, fillColor: Colors.white),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: addrController,
                  decoration: const InputDecoration(labelText: 'Alamat', filled: true, fillColor: Colors.white),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: descController,
                  decoration: const InputDecoration(labelText: 'Deskripsi', filled: true, fillColor: Colors.white),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: imageUrlController,
                  decoration: const InputDecoration(labelText: 'Link Gambar (dummy)', filled: true, fillColor: Colors.white),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () async {
                    if (nameController.text.isEmpty ||
                        addrController.text.isEmpty ||
                        descController.text.isEmpty ||
                        imageUrlController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Semua field harus diisi')),
                      );
                      return;
                    }

                    await FirebaseFirestore.instance.collection('taman').add({
                      'name': nameController.text,
                      'address': addrController.text,
                      'description': descController.text,
                      'imageUrl': imageUrlController.text,
                    });

                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Taman berhasil ditambahkan')),
                    );
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                  child: const Text('Submit', style: TextStyle(color: Colors.green)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isAdmin = user?.email == 'admin@gmail.com';

    final List<Map<String, dynamic>> tamanList = [
      {'name': "Taman Bungkul", 'image': 'bungkul.webp', 'rating': 4.7},
      {'name': "Taman Surya", 'image': 'surya.webp', 'rating': 4.6},
      {'name': "Taman Pelangi", 'image': 'pelangi.webp', 'rating': 4.5},
      {'name': "Taman Apsari", 'image': 'apsari.webp', 'rating': 4.4},
      {'name': "Taman Prestasi", 'image': 'prestasi.webp', 'rating': 4.6},
      {'name': "Taman Ekspresi", 'image': 'ekspresi.webp', 'rating': 4.3},
      {'name': "Taman Suroboyo", 'image': 'suroboyo.webp', 'rating': 4.5},
      {'name': "Taman Wira", 'image': 'wira.jpg', 'rating': 4.4},
      {'name': "Taman Pakal", 'image': 'pakal.jpg', 'rating': 4.2},
      {'name': "Taman Harmoni", 'image': 'harmoni.jpeg', 'rating': 4.6},
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Rekomendasi Taman'),
        actions: [
          if (isAdmin)
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () => _showAddTamanPopup(context),
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          itemCount: tamanList.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 0.75,
          ),
          itemBuilder: (context, index) {
            final taman = tamanList[index];
            return Container(
              decoration: BoxDecoration(
                color: Colors.green.shade300,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                      child: Image.asset(
                        'assets/images/${taman['image']}',
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
                          taman['name'],
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '⭐ ${taman['rating'].toString()}',
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
                        GestureDetector(
                          onTap: () {
                            if (taman['name'] == 'Taman Bungkul') {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const BungkulDetailPage(),
                                ),
                              );
                            }
                            // Tambahkan else if jika ingin detail taman lainnya
                          },
                          child: const Icon(Icons.more_vert, color: Colors.white),
                        ),
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
}
