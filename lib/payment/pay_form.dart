import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stocks/payment/paystackpage.dart';

class PaymentPage extends StatefulWidget {
  final double totalAmount;
  final List<Map<String, dynamic>> cartItems;

  const PaymentPage({
    super.key,
    required this.totalAmount,
    required this.cartItems,
  });

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final formatter = NumberFormat.currency(locale: 'en_NG', symbol: '₦');

  get totalAmount => null;

  @override
  void dispose() {
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Review & Pay"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Cart items list
            Expanded(
              child: ListView(
                children: [
                  ...widget.cartItems.map((item) {
                    final formattedPrice = formatter.format(
                      double.tryParse(item['price']) ?? 0.0,
                    );
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            item['imageUrl'],
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                        ),
                        title: Text(item['name']),
                        subtitle: Text(formattedPrice),
                        trailing:
                            const Icon(Icons.check_circle, color: Colors.green),
                      ),
                    );
                  }),

                  const SizedBox(height: 20),

                  // Delivery Information
                  Text("Delivery Information",
                      style: theme.textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold)),

                  const SizedBox(height: 10),

                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            labelText: "Email",
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null ||
                                value.isEmpty ||
                                !value.contains("@")) {
                              return "Enter a valid email";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          decoration: const InputDecoration(
                            labelText: "Phone Number",
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.length < 11) {
                              return "Enter a valid phone number";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _addressController,
                          decoration: const InputDecoration(
                            labelText: "Delivery Address",
                            border: OutlineInputBorder(),
                          ),
                          maxLines: 2,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Enter delivery location";
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Total amount
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceVariant,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Total",
                            style: theme.textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold)),
                        Text(formatter.format(widget.totalAmount),
                            style: theme.textTheme.titleLarge?.copyWith(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            )),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Pay Button
                  FilledButton.icon(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PaystackPage(
                              title: 'Flutter Paystack Payment',
                              totalAmount: totalAmount,
                            ),
                          ),
                        );
                      }
                    },
                    icon: const Icon(Icons.payment),
                    label: const Text("Confirm & Pay"),
                    style: FilledButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
