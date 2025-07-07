class Taman {
  final String name;
  final String image;
  final double rating;

  Taman({
    required this.name,
    required this.image,
    required this.rating,
  });

  factory Taman.fromMap(Map<String, dynamic> data) {
    return Taman(
      name: data['name'] ?? '',
      image: data['image'] ?? '',
      rating: (data['rating'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'image': image,
      'rating': rating,
    };
  }
}
