import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stocks/payment/pay_form.dart';

class CartPage extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems;
  final Function(List<Map<String, dynamic>>) updateParentCart;

  const CartPage({
    required this.cartItems,
    required this.updateParentCart,
    super.key,
  });

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final _currencyFormat = NumberFormat.currency(locale: 'en_NG', symbol: '₦');

  void _removeItem(int index) {
    setState(() {
      widget.cartItems.removeAt(index);
    });
    widget.updateParentCart(widget.cartItems);
  }

  double get _totalPrice {
    return widget.cartItems.fold(
      0.0,
      (sum, item) => sum + double.parse(item['price']),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cart = widget.cartItems;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Cart'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total: ${_currencyFormat.format(_totalPrice)}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text('Items: ${cart.length}'),
              ],
            ),
          ),
        ],
      ),
      body: cart.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_cart_outlined,
                      size: 80, color: theme.colorScheme.primary),
                  const SizedBox(height: 12),
                  const Text(
                    "Your cart is empty",
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: cart.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final item = cart[index];
                final itemPriceFormatted = _currencyFormat.format(
                  double.tryParse(item['price']) ?? 0.0,
                );

                return Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      AspectRatio(
                        aspectRatio: 16 / 9,
                        child: Image.network(
                          item['imageUrl'],
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, _) => const Center(
                            child: Icon(Icons.broken_image, size: 40),
                          ),
                        ),
                      ),
                      ListTile(
                        title: Text(
                          item['name'],
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        subtitle: Text('Price: $itemPriceFormatted'),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline),
                          onPressed: () => _removeItem(index),
                          tooltip: 'Remove item',
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
        child: FilledButton.icon(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PaymentPage(
                  totalAmount: _totalPrice,
                  cartItems: widget.cartItems,
                ),
              ),
            );
          },
          icon: const Icon(Icons.payment),
          label: const Text("Checkout Now"),
          style: FilledButton.styleFrom(
            minimumSize: const Size.fromHeight(50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
    );
  }
}
