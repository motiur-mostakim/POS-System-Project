import 'package:flutter/material.dart';

class RecentTransactions extends StatelessWidget {
  const RecentTransactions({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: const [
          Text("Recent Transactions",
              style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          TransactionItem("Order #8921", "৳ 425", true),
          TransactionItem("Order #8920", "৳ 1,280", true),
          TransactionItem("Order #8919", "-৳ 129", false),
        ],
      ),
    );
  }
}

class TransactionItem extends StatelessWidget {
  final String title;
  final String amount;
  final bool success;

  const TransactionItem(this.title, this.amount, this.success, {super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: success ? Colors.green.shade100 : Colors.red.shade100,
        child: Icon(
          success ? Icons.check : Icons.close,
          color: success ? Colors.green : Colors.red,
        ),
      ),
      title: Text(title),
      trailing: Text(
        amount,
        style: TextStyle(
          color: success ? Colors.black : Colors.red,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
