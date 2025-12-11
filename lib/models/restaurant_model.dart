class Menu {
  final String? id;
  final String name;
  final double price;

  Menu({this.id, required this.name, required this.price});

  Map<String, dynamic> toJson(String restaurantId) {
    return {
      'restaurant_id': restaurantId,
      'name': name,
      'price': price,
    };
  }

  factory Menu.fromJson(Map<String, dynamic> json) {
    return Menu(
      id: json['id'],
      name: json['name'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class Review {
  final String id;
  final String userName;
  final String comment;
  final int rating;
  final DateTime createdAt;

  Review({
    required this.id,
    required this.userName,
    required this.comment,
    required this.rating,
    required this.createdAt,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'],
      userName: json['user_name'] ?? 'Anonim',
      comment: json['comment'] ?? '',
      rating: json['rating'] ?? 0,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
    );
  }
}

class Restaurant {
  final String id;
  final String name;
  final String description;
  final String address;
  final String? imageUrl;
  final String userId;
  final DateTime createdAt;

  Restaurant({
    required this.id,
    required this.name,
    required this.description,
    required this.address,
    this.imageUrl,
    required this.userId,
    required this.createdAt,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      address: json['address'] ?? '',
      imageUrl: json['image_url'],
      userId: json['user_id'] ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'address': address,
      'image_url': imageUrl,
      'user_id': userId,
    };
  }
}

// --- CLASS BARU: NOTIFIKASI ---
class NotificationItem {
  final String id;
  final String senderName;
  final String message;
  final DateTime createdAt;

  NotificationItem({
    required this.id,
    required this.senderName,
    required this.message,
    required this.createdAt,
  });

  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    return NotificationItem(
      id: json['id'],
      senderName: json['sender_name'] ?? 'Seseorang',
      message: json['message'] ?? '',
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}