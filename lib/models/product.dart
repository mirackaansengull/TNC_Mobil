class Product {
  const Product({
    required this.id,
    required this.name,
    required this.price,
    required this.priceLabel,
    required this.category,
    required this.image,
    required this.description,
    this.tagline = '',
  });

  final int id;
  final String name;
  final double price;
  final String priceLabel;
  final String category;
  final String image;
  final String description;
  final String tagline;

  factory Product.fromJson(Map<String, dynamic> json) {
    final name = json['name']?.toString() ?? json['title']?.toString() ?? '';
    final rawPrice = json['price'];

    return Product(
      id: _parseInt(json['id']),
      name: name,
      price: _parsePrice(rawPrice),
      priceLabel: _formatPriceLabel(rawPrice, json['currency']),
      category: json['category']?.toString() ?? _resolveCategory(name),
      image: json['image']?.toString() ?? json['img']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      tagline: json['tagline']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': priceLabel,
      'category': category,
      'image': image,
      'description': description,
      'tagline': tagline,
    };
  }

  static int _parseInt(dynamic value) {
    if (value is int) {
      return value;
    }
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  static double _parsePrice(dynamic value) {
    if (value is num) {
      return value.toDouble();
    }
    final cleaned = value?.toString().replaceAll(RegExp(r'[^\d.]'), '') ?? '';
    return double.tryParse(cleaned) ?? 0;
  }

  static String _formatPriceLabel(dynamic value, dynamic currency) {
    if (value == null) {
      return '';
    }
    final text = value.toString().trim();
    if (text.contains(r'$') || text.contains('€') || text.contains('₺')) {
      return text;
    }
    final code = currency?.toString() ?? 'USD';
    if (code == 'USD') {
      return '\$$text';
    }
    return '$text $code';
  }

  static String _resolveCategory(String name) {
    final lower = name.toLowerCase();
    if (lower.contains('iphone')) {
      return 'iPhone';
    }
    if (lower.contains('macbook') || lower.contains('imac')) {
      return 'Mac';
    }
    if (lower.contains('ipad')) {
      return 'iPad';
    }
    if (lower.contains('watch')) {
      return 'Apple Watch';
    }
    if (lower.contains('airpods')) {
      return 'AirPods';
    }
    if (lower.contains('homepod')) {
      return 'HomePod';
    }
    if (lower.contains('vision')) {
      return 'Vision';
    }
    return 'Diğer';
  }
}
