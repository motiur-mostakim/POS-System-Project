import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../core/models/product_model.dart';
import '../core/data/mock_data.dart';

class PosScreen extends StatefulWidget {
  const PosScreen({super.key});

  @override
  State<PosScreen> createState() => _PosScreenState();
}

class _PosScreenState extends State<PosScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final MobileScannerController scannerController = MobileScannerController();
  final MobileScannerController cardScannerController =
      MobileScannerController();

  List<CartItemModel> cartItems = [];
  String? lastScannedBarcode;
  DateTime? lastScannedTime;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    scannerController.dispose();
    cardScannerController.dispose();
    super.dispose();
  }

  void _onBarcodeScanned(String code) {
    final now = DateTime.now();
    if (code == lastScannedBarcode && lastScannedTime != null) {
      if (now.difference(lastScannedTime!).inSeconds < 5) return;
    }
    final product = mockProducts.firstWhere(
      (p) => p.barcode == code,
      orElse: () =>
          Product(id: "0", name: "Unknown Product", price: 0, barcode: code),
    );
    if (product.id != "0") {
      setState(() {
        lastScannedBarcode = code;
        lastScannedTime = now;
        int index = cartItems.indexWhere(
          (item) => item.product.id == product.id,
        );
        if (index != -1) {
          cartItems[index].quantity++;
        } else {
          cartItems.insert(0, CartItemModel(product: product));
        }
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("${product.name} যোগ করা হয়েছে"),
          duration: const Duration(milliseconds: 700),
          backgroundColor: Colors.green,
        ),
      );
    }
  }
  double get subtotal => cartItems.fold(
    0,
    (sum, item) => sum + (item.product.price * item.quantity),
  );
  double get total => subtotal + (subtotal * 0.05);
  void _showPaymentOptions() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "পেমেন্ট গেটওয়ে বেছে নিন",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 25),
            _paymentTile("Cash Payment", Icons.money_rounded, Colors.green, () {
              Navigator.pop(context);
              _processPayment("Cash");
            }),
            _paymentTile(
              "bKash Payment",
              Icons.account_balance_wallet,
              const Color(0xFFD12053),
              () {
                Navigator.pop(context);
                _simulateBkash();
              },
            ),
            _paymentTile(
              "SSLCommerz (All Methods)",
              Icons.public,
              Colors.blueAccent,
              () {
                Navigator.pop(context);
                _simulateSSLCommerz();
              },
            ),
            _paymentTile("Card Scan", Icons.credit_card, Colors.blue, () {
              Navigator.pop(context);
              _openCardScanner();
            }),
          ],
        ),
      ),
    );
  }

  Widget _paymentTile(
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.1),
          child: Icon(icon, color: color),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }

  void _simulateBkash() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFFD12053),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Image.network(
          "https://wp.logos-download.com/wp-content/uploads/2022/01/BKash_Logo_icon-700x662.png",
          height: 60,
          color: Colors.white,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "বিকাশ নম্বর এবং পিন দিন",
              style: TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 15),
            TextField(
              decoration: InputDecoration(
                hintText: "01XXXXXXXXX",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFFD12053),
                minimumSize: const Size(double.infinity, 45),
              ),
              onPressed: () {
                Navigator.pop(context);
                _processPayment("bKash");
              },
              child: const Text("Confirm Payment"),
            ),
          ],
        ),
      ),
    );
  }

  void _simulateSSLCommerz() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text("SSLCommerz Gateway"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Choose a payment method:"),
            const SizedBox(height: 15),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                _gateIcon(Icons.credit_card, "Card"),
                _gateIcon(Icons.account_balance, "Bank"),
                _gateIcon(Icons.phone_android, "MFS"),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _processPayment("SSLCommerz");
            },
            child: const Text("Continue"),
          ),
        ],
      ),
    );
  }

  Widget _gateIcon(IconData i, String l) {
    return Column(
      children: [
        CircleAvatar(child: Icon(i)),
        Text(l, style: const TextStyle(fontSize: 10)),
      ],
    );
  }

  void _openCardScanner() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            MobileScanner(
              controller: cardScannerController,
              onDetect: (capture) {},
            ),
            Center(
              child: Container(
                width: 320,
                height: 200,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue, width: 3),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.credit_card, color: Colors.white54, size: 50),
                    SizedBox(height: 10),
                    Text(
                      "কার্ডটি ফ্রেমের ভেতরে রাখুন",
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 50,
              left: 20,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white, size: 30),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            Positioned(
              bottom: 100,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  const CircularProgressIndicator(color: Colors.blue),
                  const SizedBox(height: 20),
                  const Text(
                    "Scanning Card...",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _processPayment("Card");
                    },
                    child: const Text("Simulate Success"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _processPayment(String method) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(30),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 20),
                Text("পেমেন্ট প্রসেস হচ্ছে..."),
              ],
            ),
          ),
        ),
      ),
    );
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pop(context);
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          icon: const Icon(Icons.check_circle, color: Colors.green, size: 60),
          title: const Text("সফল হয়েছে!"),
          content: Text(
            "৳ ${total.toStringAsFixed(2)} পরিশোধিত।\nGateway: $method",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                setState(() => cartItems.clear());
              },
              child: const Text("ঠিক আছে"),
            ),
          ],
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff8f9ff),
      body: Column(
        children: [
          _topBar(),
          Expanded(
            child: Column(
              children: [
                Expanded(flex: 4, child: _scannerView()),
                Expanded(flex: 6, child: _cartView()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _topBar() {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: const [
              Icon(Icons.point_of_sale, color: Colors.blue),
              SizedBox(width: 10),
              Text(
                "POS Terminal",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.redAccent),
            onPressed: () => setState(() => cartItems.clear()),
          ),
        ],
      ),
    );
  }

  Widget _scannerView() {
    return Container(
      color: Colors.black,
      child: Stack(
        fit: StackFit.expand,
        children: [
          MobileScanner(
            controller: scannerController,
            onDetect: (capture) {
              final barcodes = capture.barcodes;
              if (barcodes.isNotEmpty && barcodes.first.rawValue != null) {
                _onBarcodeScanned(barcodes.first.rawValue!);
              }
            },
          ),
          Center(
            child: Container(
              width: 250,
              height: 150,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) => Stack(
                  children: [
                    Positioned(
                      top: 10 + (_controller.value * 130),
                      left: 10,
                      right: 10,
                      child: Container(height: 2, color: Colors.red),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _cartView() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Current Cart",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Chip(label: Text("${cartItems.length} ITEMS")),
              ],
            ),
          ),
          Expanded(
            child: cartItems.isEmpty
                ? const Center(child: Text("কার্টে কোনো প্রোডাক্ট নেই"))
                : ListView.builder(
                    physics: BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      final item = cartItems[index];
                      return Card(
                        elevation: 0,
                        color: Colors.grey.shade50,
                        child: ListTile(
                          title: Text(item.product.name),
                          subtitle: Text(
                            "৳ ${item.product.price} x ${item.quantity}",
                          ),
                          trailing: Text(
                            "৳ ${(item.product.price * item.quantity).toStringAsFixed(2)}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.grey.shade50,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Subtotal"),
                    Text("৳ ${subtotal.toStringAsFixed(2)}"),
                  ],
                ),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Total",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "৳ ${total.toStringAsFixed(2)}",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  onPressed: cartItems.isEmpty ? null : _showPaymentOptions,
                  child: const Text("Complete Sale"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
