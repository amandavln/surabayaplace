import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BungkulDetailPage extends StatefulWidget {
  const BungkulDetailPage({super.key});

  @override
  State<BungkulDetailPage> createState() => _BungkulDetailPageState();
}

class _BungkulDetailPageState extends State<BungkulDetailPage> {
  final TextEditingController _reviewController = TextEditingController();

  Future<void> _submitReview() async {
    final review = _reviewController.text.trim();
    final user = FirebaseAuth.instance.currentUser;

    if (review.isEmpty || user == null) return;

    await FirebaseFirestore.instance.collection('taman_reviews').add({
      'tamanName': 'Taman Bungkul',
      'review': review,
      'userEmail': user.email,
      'timestamp': FieldValue.serverTimestamp(),
    });

    _reviewController.clear();
    Navigator.of(context).pop();
    setState(() {});
  }

  void _showReviewPopup() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Kirim Ulasan'),
        content: TextField(
          controller: _reviewController,
          decoration: const InputDecoration(hintText: 'Tulis ulasan Anda di sini...'),
        ),
        actions: [
          TextButton(
            onPressed: _submitReview,
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Taman')),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset('assets/images/bungkul.webp'),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('Taman Bungkul', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Text('Alamat: Jl. Taman Bungkul, Darmo, Surabaya'),
                  Text('Fasilitas: Area Bermain, Tempat Duduk, WiFi, Parkir'),
                  Text('Jam Buka: 06.00 - 22.00'),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.comment, color: Colors.grey),
              title: const Text('Kirim Ulasan'),
              onTap: _showReviewPopup,
            ),
            const Divider(),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text('Ulasan:', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 8),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('taman_reviews')
                  .where('tamanName', isEqualTo: 'Taman Bungkul')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final docs = snapshot.data?.docs ?? [];
                if (docs.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text('Belum ada ulasan.'),
                  );
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final data = docs[index].data() as Map<String, dynamic>;
                    return ListTile(
                      leading: const Icon(Icons.person, color: Colors.green),
                      title: Text(data['review'] ?? ''),
                      subtitle: Text(data['userEmail'] ?? '', style: const TextStyle(fontSize: 12)),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
