import 'package:flutter/material.dart';

import '../core/widgets/recent_transactions.dart';
import '../core/widgets/sales_chat.dart';
import '../core/widgets/stats_sections.dart';

class PosDashboardScreen extends StatefulWidget {
  const PosDashboardScreen({super.key});

  @override
  State<PosDashboardScreen> createState() => _PosDashboardScreenState();
}

class _PosDashboardScreenState extends State<PosDashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("POS Dashboard"),
        actions: [
          const Padding(
            padding: EdgeInsets.only(right: 12),
            child: CircleAvatar(
              backgroundImage: NetworkImage("https://i.pravatar.cc/150?img=3"),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.add_shopping_cart),
                    label: const Text("Start Sale"),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.add_box),
                    label: const Text("Add Product"),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const StatsSection(),
            const SizedBox(height: 20),
            SalesChart(),
            RecentTransactions(),
          ],
        ),
      ),
    );
  }
}
