class SnackshopTransaction {
  final int id;
  final DateTime datetime;
  final String usagetext;
  final double amount;
  final double oldbalance;
  final double newbalance;

  SnackshopTransaction(this.id, this.datetime, this.usagetext, this.amount,
      this.oldbalance, this.newbalance);

  SnackshopTransaction.fromJSON(Map<String, dynamic> data)
      : this.id = int.parse(data['id'] ?? '0'),
        this.datetime = DateTime.parse(data['created']),
        this.usagetext = data['usagetext'],
        this.amount = double.parse(data['amount']),
        this.oldbalance = double.parse(data['oldbalance']),
        this.newbalance = double.parse(data['newbalance']);
}

class SnackshopTransactionList {
  List<SnackshopTransaction> items = [];

  SnackshopTransactionList.fromJSON(List<dynamic> data) {
    data.forEach((item) {
      items.add(SnackshopTransaction.fromJSON(item));
    });
  }
}
