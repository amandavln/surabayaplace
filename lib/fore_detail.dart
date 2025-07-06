import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ForeDetailPage extends StatefulWidget {
  const ForeDetailPage({super.key});

  @override
  State<ForeDetailPage> createState() => _ForeDetailPageState();
}

class _ForeDetailPageState extends State<ForeDetailPage> {
  final TextEditingController _reviewController = TextEditingController();

  Future<void> _submitReview() async {
    final review = _reviewController.text.trim();
    final user = FirebaseAuth.instance.currentUser;

    if (review.isEmpty || user == null) return;

    await FirebaseFirestore.instance.collection('cafe_reviews').add({
      'cafeName': 'Fore Coffee',
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
      appBar: AppBar(title: const Text('Detail Cafe')),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset('assets/images/fore.jpg'),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('Fore Coffee', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Text('Alamat: Galaxy Mall 2, Surabaya'),
                  Text('Fasilitas: WiFi, Colokan, AC, Area Outdoor'),
                  Text('Jam Buka: 07.00 - 22.00'),
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

            // ✅ StreamBuilder DIBENERIN DI SINI:
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('cafe_reviews')
                  .where('cafeName', isEqualTo: 'Fore Coffee')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text('Terjadi kesalahan saat memuat ulasan.'),
                  );
                }

                if (!snapshot.hasData || snapshot.data == null || snapshot.data!.docs.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text('Belum ada ulasan.'),
                  );
                }

                final docs = snapshot.data!.docs;
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
