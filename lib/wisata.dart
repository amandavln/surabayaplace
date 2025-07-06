import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'tugu_detail.dart';

class WisataPage extends StatefulWidget {
  const WisataPage({super.key});

  @override
  State<WisataPage> createState() => _WisataPageState();
}

class _WisataPageState extends State<WisataPage> {
  final user = FirebaseAuth.instance.currentUser;

  void _showAddWisataPopup(BuildContext context) {
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
              colors: [Color.fromARGB(255, 64, 150, 225), Color.fromARGB(255, 125, 190, 255)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Tambah Tempat Wisata', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
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

                    await FirebaseFirestore.instance.collection('wisata').add({
                      'name': nameController.text,
                      'address': addrController.text,
                      'description': descController.text,
                      'imageUrl': imageUrlController.text,
                    });

                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Wisata berhasil ditambahkan')),
                    );
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                  child: const Text('Submit', style: TextStyle(color: Color.fromARGB(255, 20, 67, 122))),
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

    final List<Map<String, dynamic>> wisataList = [
      {'name': "Kembang Jepun", 'image': 'kembangjepun.jpg', 'rating': 4.6},
      {'name': "Tugu Pahlawan", 'image': 'tugu.webp', 'rating': 4.8},
      {'name': "Monumen Kapal Selam", 'image': 'monkasel.jpg', 'rating': 4.7},
      {'name': "Hutan Bambu", 'image': 'hutanbambu.jpg', 'rating': 4.5},
      {'name': "Pantai Kenjeran", 'image': 'pantaikenjeran.jpg', 'rating': 4.6},
      {'name': "Ekowisata Mangrove", 'image': 'mangrove.jpg', 'rating': 4.4},
      {'name': "Kebun Binatang Surabaya", 'image': 'kbs.jpeg', 'rating': 4.3},
      {'name': "North Quay", 'image': 'northquay.jpg', 'rating': 4.5},
      {'name': "Klenteng Sanggar Agung", 'image': 'klenteng.jpg', 'rating': 4.6},
      {'name': "THR Surabaya", 'image': 'thr.jpeg', 'rating': 4.2},
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Rekomendasi Wisata'),
        actions: [
          if (isAdmin)
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () => _showAddWisataPopup(context),
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          itemCount: wisataList.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 0.75,
          ),
          itemBuilder: (context, index) {
            final wisata = wisataList[index];
            return Container(
              decoration: BoxDecoration(
                color: Colors.blue.shade300,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                      child: Image.asset(
                        'assets/images/${wisata['image']}',
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
                          wisata['name'],
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '⭐ ${wisata['rating'].toString()}',
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
                            if (wisata['name'] == 'Tugu Pahlawan') {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const TuguDetailPage(),
                                ),
                              );
                            }
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
