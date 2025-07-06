class Wisata {
  final String id;
  final String name;
  final String imageUrl;
  final String address;
  final double rating;

  Wisata({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.address,
    required this.rating,
  });

  factory Wisata.fromMap(Map<String, dynamic> map, String id) {
    return Wisata(
      id: id,
      name: map['name'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      address: map['address'] ?? '',
      rating: (map['rating'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'imageUrl': imageUrl,
      'address': address,
      'rating': rating,
    };
  }
}
