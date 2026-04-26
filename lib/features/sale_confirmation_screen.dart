import 'package:flutter/material.dart';

class SaleConfirmationScreen extends StatelessWidget {
  const SaleConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff8f9ff),
      body: Column(
        children: [
          const _TopBar(),
          Expanded(
            child: Row(
              children: const [
                Expanded(flex: 6, child: ScannerSection()),
                Expanded(flex: 4, child: CartSection()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

//////////////////////////////////////////////////
// TOP BAR
//////////////////////////////////////////////////
class _TopBar extends StatelessWidget {
  const _TopBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey)),
        color: Colors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          Row(
            children: [
              Icon(Icons.menu),
              SizedBox(width: 10),
              Text("POS Terminal",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
          CircleAvatar()
        ],
      ),
    );
  }
}

//////////////////////////////////////////////////
// SCANNER SECTION
//////////////////////////////////////////////////
class ScannerSection extends StatelessWidget {
  const ScannerSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        /// Background
        Positioned.fill(
          child: Image.network(
            "https://images.unsplash.com/photo-1586201375761-83865001e31c",
            fit: BoxFit.cover,
          ),
        ),

        /// Dark overlay
        Positioned.fill(
          child: Container(color: Colors.black.withOpacity(0.5)),
        ),

        /// Scanner Box
        Center(
          child: Container(
            width: 260,
            height: 160,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white, width: 2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Stack(
              children: const [
                Positioned.fill(child: _ScannerCorners()),
                _ScannerLine(),
              ],
            ),
          ),
        ),

        /// LIVE badge
        Positioned(
          top: 20,
          left: 20,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.6),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              children: [
                CircleAvatar(radius: 4, backgroundColor: Colors.red),
                SizedBox(width: 6),
                Text("LIVE SCANNER",
                    style: TextStyle(color: Colors.white, fontSize: 10)),
              ],
            ),
          ),
        ),

        /// Bottom buttons
        Positioned(
          bottom: 20,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              _CircleBtn(icon: Icons.flashlight_on),
              SizedBox(width: 16),
              _CircleBtn(icon: Icons.keyboard),
            ],
          ),
        )
      ],
    );
  }
}

class _ScannerCorners extends StatelessWidget {
  const _ScannerCorners();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _corner(Alignment.topLeft),
        _corner(Alignment.topRight),
        _corner(Alignment.bottomLeft),
        _corner(Alignment.bottomRight),
      ],
    );
  }

  Widget _corner(Alignment alignment) {
    return Align(
      alignment: alignment,
      child: Container(
        width: 20,
        height: 20,
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: Colors.green, width: 3),
            left: BorderSide(color: Colors.green, width: 3),
          ),
        ),
      ),
    );
  }
}

class _ScannerLine extends StatelessWidget {
  const _ScannerLine();

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Align(
        alignment: Alignment.center,
        child: Container(
          height: 2,
          color: Colors.red,
        ),
      ),
    );
  }
}

class _CircleBtn extends StatelessWidget {
  final IconData icon;

  const _CircleBtn({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: Colors.white),
    );
  }
}

//////////////////////////////////////////////////
// CART SECTION
//////////////////////////////////////////////////
class CartSection extends StatelessWidget {
  const CartSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        /// Header
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text("Current Cart",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Chip(label: Text("4 ITEMS")),
            ],
          ),
        ),

        /// Items
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(12),
            children: const [
              CartItem(title: "Water 500ml", price: 2.49, qty: 2),
              CartItem(title: "Sourdough Bread", price: 6.50, qty: 1),
              CartItem(title: "Eggs 12pk", price: 4.95, qty: 1),
              CartItem(title: "Pink Salt", price: 8.20, qty: 1, lowStock: true),
            ],
          ),
        ),

        /// Summary
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.white,
          child: Column(
            children: [
              _row("Subtotal", "\$24.58"),
              _row("VAT (15%)", "\$3.69"),
              const SizedBox(height: 8),
              _row("Total", "\$28.27", bold: true),

              const SizedBox(height: 12),

              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 55),
                ),
                child: const Text("Complete Sale"),
              )
            ],
          ),
        )
      ],
    );
  }

  Widget _row(String t, String v, {bool bold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(t),
        Text(v,
            style: TextStyle(
                fontWeight: bold ? FontWeight.bold : FontWeight.normal)),
      ],
    );
  }
}

//////////////////////////////////////////////////
// CART ITEM
//////////////////////////////////////////////////
class CartItem extends StatelessWidget {
  final String title;
  final double price;
  final int qty;
  final bool lowStock;

  const CartItem({
    super.key,
    required this.title,
    required this.price,
    required this.qty,
    this.lowStock = false,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Card(
          child: ListTile(
            leading: const Icon(Icons.shopping_bag),
            title: Text(title),
            subtitle: Text("\$$price"),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.remove),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text("$qty"),
                ),
                const Icon(Icons.add),
              ],
            ),
          ),
        ),

        if (lowStock)
          Positioned(
            right: 0,
            top: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              color: Colors.red,
              child: const Text("LOW STOCK",
                  style: TextStyle(fontSize: 10, color: Colors.white)),
            ),
          )
      ],
    );
  }
}