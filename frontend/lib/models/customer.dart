class Customer {
  final int? id;
  final String name;
  final String email;
  final String phone;
  final String iban;
  final DateTime? createdAt;

  Customer({
    this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.iban,
    this.createdAt,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      iban: json['iban'],
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'iban': iban,
    };
  }
}