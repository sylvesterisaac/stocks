import 'package:flutter/material.dart';
import 'package:stocks/cartPage.dart';

class ClothingDetailpage extends StatefulWidget {
  final String name;
  final String price;
  final String imageUrl;
  final List<Map<String, dynamic>> cartItems;

  final VoidCallback? onAddToCart;
  final VoidCallback? updateCartCount;

  const ClothingDetailpage({
    super.key,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.cartItems,
    this.onAddToCart,
    this.updateCartCount,
  });

  @override
  State<ClothingDetailpage> createState() => _ClothingDetailpageState();
}

class _ClothingDetailpageState extends State<ClothingDetailpage> {
  List<Map<String, dynamic>> cartItems = [];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Item Details'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CartPage(
                    cartItems: widget.cartItems,
                    updateParentCart: (updatedCartItems) {
                      setState(() {
                        cartItems = updatedCartItems;
                      });
                    },
                  ),
                ),
              );
            },
            icon: Stack(
              children: [
                const Icon(Icons.shopping_cart_outlined),
                if (widget.cartItems.isNotEmpty)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: CircleAvatar(
                      radius: 8,
                      backgroundColor: Colors.red,
                      child: Text(
                        '${widget.cartItems.length}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Card(
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Product Image
              AspectRatio(
                aspectRatio: 1.2,
                child: Image.network(
                  widget.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const Center(child: Icon(Icons.image_not_supported)),
                ),
              ),

              // Info Section
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.name,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '₦${widget.price}',
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    FilledButton.icon(
                      onPressed: () {
                        setState(() {
                          cartItems.add({
                            'name': widget.name,
                            'price': widget.price,
                            'imageUrl': widget.imageUrl,
                          });
                        });

                        widget.onAddToCart?.call();
                        widget.updateCartCount?.call();

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Item added to cart'),
                            duration: Duration(seconds: 1),
                          ),
                        );
                      },
                      icon: const Icon(Icons.shopping_bag_outlined),
                      label: const Text('Add to Cart'),
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 14,
                        ),
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
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(Icons.arrow_back),
        label: const Text('Back'),
        backgroundColor: theme.colorScheme.secondaryContainer,
        foregroundColor: theme.colorScheme.onSecondaryContainer,
      ),
    );
  }
}
