import 'package:cloud_firestore/cloud_firestore.dart';
class Cafe {
  final String id;
  final String name;
  final String address;
  final String description;
  final String imageName;
  final double rating;

  Cafe({
    required this.id,
    required this.name,
    required this.address,
    required this.description,
    required this.imageName,
    required this.rating,
  });

  factory Cafe.fromMap(Map<String, dynamic> map, String id) {
    return Cafe(
      id: id,
      name: map['name'] ?? '',
      address: map['address'] ?? '',
      description: map['description'] ?? '',
      imageName: map['imageName'] ?? '',
      rating: (map['rating'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'address': address,
      'description': description,
      'imageName': imageName,
      'rating': rating,
    };
  }
}

class Review {
  final String userEmail;
  final String reviewText;

  Review({required this.userEmail, required this.reviewText});

  factory Review.fromMap(Map<String, dynamic> map) {
    return Review(
      userEmail: map['userEmail'] ?? '',
      reviewText: map['reviewText'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userEmail': userEmail,
      'reviewText': reviewText,
    };
  }
}