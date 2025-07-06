import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TuguDetailPage extends StatefulWidget {
  const TuguDetailPage({super.key});

  @override
  State<TuguDetailPage> createState() => _TuguDetailPageState();
}

class _TuguDetailPageState extends State<TuguDetailPage> {
  final TextEditingController _reviewController = TextEditingController();

  Future<void> _submitReview() async {
    final review = _reviewController.text.trim();
    final user = FirebaseAuth.instance.currentUser;

    if (review.isEmpty || user == null) return;

    await FirebaseFirestore.instance.collection('wisata_reviews').add({
      'wisataName': 'Tugu Pahlawan',
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
      appBar: AppBar(title: const Text('Detail Wisata')),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset('assets/images/tugu.webp'),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('Tugu Pahlawan', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Text('Alamat: Jl. Pahlawan, Alun-alun Contong, Surabaya'),
                  Text('Fasilitas: Taman, Museum, Tempat Duduk, Parkir'),
                  Text('Jam Buka: 08.00 - 18.00'),
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
                  .collection('wisata_reviews')
                  .where('wisataName', isEqualTo: 'Tugu Pahlawan') // sudah benar sekarang
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
                      leading: const Icon(Icons.person, color: Colors.blue),
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
