class BookingModel {
  final int? id;
  final int? userId;
  final int? itemId;
  final String? itemType;
  final String? itemName;
  final String? status;
  final String? date;
  final double? price;

  BookingModel({
    this.id,
    this.userId,
    this.itemId,
    this.itemType,
    this.itemName,
    this.status,
    this.date,
    this.price,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['id'] ?? json['bookingId'],
      userId: json['userId'],
      itemId: json['itemId'],
      itemType: json['itemType'],
      itemName: json['itemName'] ?? json['title'],
      status: json['status'],
      date: json['date'] ?? json['bookingDate'] ?? json['createdAt'],
      price: json['price'] != null ? double.tryParse(json['price'].toString()) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'itemId': itemId,
      'itemType': itemType,
      'itemName': itemName,
      'status': status,
      'date': date,
      'price': price,
    };
  }
}
