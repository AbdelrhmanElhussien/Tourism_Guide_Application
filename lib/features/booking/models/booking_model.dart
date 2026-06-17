class BookingModel {
  final String? id;
  final String? userId;
  final String? itemId;
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
    final idVal = json['id'] ?? json['Id'] ?? json['bookingId'] ?? json['BookingId'] ?? json['bookingID'];
    final userIdVal = json['userId'] ?? json['UserId'] ?? json['userID'] ?? json['UserID'];
    final itemIdVal = json['itemId'] ?? json['ItemId'] ?? json['itemID'] ?? json['ItemID'];
    final itemTypeVal = json['itemType'] ?? json['ItemType'];
    final itemNameVal = json['itemName'] ?? json['ItemName'] ?? json['title'] ?? json['Title'] ?? json['name'] ?? json['Name'];
    final statusVal = json['status'] ?? json['Status'];
    final dateVal = json['date'] ?? json['Date'] ?? json['bookingDate'] ?? json['BookingDate'] ?? json['createdAt'] ?? json['CreatedAt'] ?? json['bookingDateTime'];
    final priceVal = json['price'] ?? json['Price'];

    return BookingModel(
      id: idVal?.toString(),
      userId: userIdVal?.toString(),
      itemId: itemIdVal?.toString(),
      itemType: itemTypeVal?.toString(),
      itemName: itemNameVal?.toString(),
      status: statusVal?.toString(),
      date: dateVal?.toString(),
      price: priceVal != null ? double.tryParse(priceVal.toString()) : null,
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
