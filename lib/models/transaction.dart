class Transaction {
  String quantity_of_coins;
  String description;
  String wave_timestamp;
  String operation;

  Transaction({
    this.quantity_of_coins,
    this.description,
    this.wave_timestamp,
    this.operation,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      quantity_of_coins: json['quantity_of_coins'],
      description: json['description'],
      wave_timestamp: json['wave_timestamp'],
      operation: json['operation'],
    );
  }
}
