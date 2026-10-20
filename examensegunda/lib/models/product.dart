class Rating {
  const Rating({this.rate = 0, this.count = 0});
  final double rate;
  final int count;
  factory Rating.fromJson(Map<String, dynamic>? json) => Rating(rate: (json?['rate'] as num?)?.toDouble() ?? 0, count: (json?['count'] as num?)?.toInt() ?? 0);
  Map<String, dynamic> toJson() => {'rate': rate, 'count': count};
}

class Product {
  const Product({required this.id, required this.title, required this.price, required this.description, required this.category, required this.image, this.rating = const Rating()});
  final int id;
  final String title;
  final double price;
  final String description;
  final String category;
  final String image;
  final Rating rating;
  factory Product.fromJson(Map<String, dynamic> json) => Product(id: (json['id'] as num?)?.toInt() ?? 0, title: json['title'] as String? ?? '', price: (json['price'] as num?)?.toDouble() ?? 0, description: json['description'] as String? ?? '', category: json['category'] as String? ?? '', image: json['image'] as String? ?? '', rating: Rating.fromJson(json['rating'] as Map<String, dynamic>?));
  Map<String, dynamic> toJson() => {'id': id, 'title': title, 'price': price, 'description': description, 'category': category, 'image': image, 'rating': rating.toJson()};
  Product copyWith({int? id, String? title, double? price, String? description, String? category, String? image, Rating? rating}) => Product(id: id ?? this.id, title: title ?? this.title, price: price ?? this.price, description: description ?? this.description, category: category ?? this.category, image: image ?? this.image, rating: rating ?? this.rating);
}
