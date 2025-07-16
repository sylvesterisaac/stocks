import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:stocks/cartPage.dart';
import 'package:stocks/clothdetail.dart';
import 'package:stocks/clothitem.dart';

// ignore: camel_case_types
class clothing extends StatefulWidget {
  const clothing({Key? key}) : super(key: key);

  @override
  State<clothing> createState() => _clothingState();
}

// ignore: camel_case_types
class _clothingState extends State<clothing> {
  // Define a list of clothing items
  List<Map<String, dynamic>> clothingItems = [];
  List<Map<String, dynamic>> cartItems = [];
  int totalItemsInCart = 0;

  void updateCartCount() {
    setState(() {
      totalItemsInCart = cartItems.length;
    });
  }

  Future<List<Map<String, dynamic>>> fetchAllClothingItemsByCategory(
      String category) async {
    List<Map<String, dynamic>> clothingItemList = [];

    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection(category).get();

      querySnapshot.docs.forEach((doc) {
        final data = doc.data() as Map<String, dynamic>?;

        if (data != null) {
          final name = data['name'] as String? ?? 'N/A';
          final imageUrl = data['image_url'] as String? ?? 'N/A';
          final price = data['price'] as String? ?? '0.0';
          clothingItemList.add(
            {
              "name": name,
              "imageUrl": imageUrl,
              "price": price,
            },
          );
        }
      });
    } catch (e) {
      print('Error fetching clothing items: $e');
      throw e;
    }

    return clothingItemList;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchClothes('clothing');
  }

  fetchClothes(String category) async {
    clothingItems = await fetchAllClothingItemsByCategory(category);
    setState(() {});
  }

  void addToCart(String name, String price, String imageUrl) {
    setState(() {
      cartItems.add({
        'name': name,
        'price': price,
        'imageUrl': imageUrl,
      });
      updateCartCount();
    });
  }

  @override
  Widget build(BuildContext context) {
    int totalItemsInCart = cartItems.length;

    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          elevation: 4,
          title: Text(
            'Accessories',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
          ),
          actions: [
            Stack(
              alignment: Alignment.topRight,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CartPage(
                          cartItems: cartItems,
                          updateParentCart: (updatedCartItems) {
                            setState(() {
                              cartItems = updatedCartItems;
                            });
                          },
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.shopping_cart_outlined),
                ),
                if (totalItemsInCart > 0)
                  Positioned(
                    right: 4,
                    top: 4,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      constraints:
                          const BoxConstraints(minWidth: 20, minHeight: 20),
                      child: Text(
                        '$totalItemsInCart',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
          ],
          bottom: TabBar(
            isScrollable: true,
            labelColor: Theme.of(context).colorScheme.primary,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Theme.of(context).colorScheme.primary,
            tabs: const [
              Tab(text: 'Home'),
              Tab(text: 'Trouser'),
              Tab(text: 'T-Shirt'),
              Tab(text: 'Shoes'),
              Tab(text: 'Bag'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            clothingItems.isEmpty
                ? Center(child: CircularProgressIndicator())
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10.0,
                        mainAxisSpacing: 10.0,
                        childAspectRatio: 1.0,
                      ),
                      itemCount: clothingItems.length,
                      itemBuilder: (context, index) {
                        final item = clothingItems[index];
                        return ClothingItem(
                          name: item['name'],
                          price: item['price'],
                          imageUrl: item['imageUrl'],
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ClothingDetailpage(
                                  cartItems: cartItems,
                                  name: item['name'],
                                  price: item['price'],
                                  imageUrl: item['imageUrl'],
                                  onAddToCart: () {
                                    addToCart(item['name'], item['price'],
                                        item['imageUrl']);
                                  },
                                  updateCartCount: updateCartCount,
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
            Container(
              child: FutureBuilder(
                future: fetchAllClothingItemsByCategory('Trouser'),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error fetching data'));
                  } else {
                    List<Map<String, dynamic>> trousers =
                        snapshot.data as List<Map<String, dynamic>>;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10.0,
                          mainAxisSpacing: 10.0,
                          childAspectRatio: 1.0,
                        ),
                        itemCount: trousers.length,
                        itemBuilder: (context, index) {
                          final item = trousers[index];
                          return ClothingItem(
                            name: item['name'],
                            price: item['price'],
                            imageUrl: item['imageUrl'],
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ClothingDetailpage(
                                    cartItems: cartItems,
                                    name: item['name'],
                                    price: item['price'],
                                    imageUrl: item['imageUrl'],
                                    onAddToCart: () {
                                      addToCart(item['name'], item['price'],
                                          item['imageUrl']);
                                    },
                                    updateCartCount: updateCartCount,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    );
                  }
                },
              ),
            ),
            Container(
              child: FutureBuilder(
                future: fetchAllClothingItemsByCategory('T-Shirt'),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error fetching data'));
                  } else {
                    List<Map<String, dynamic>> tShirts =
                        snapshot.data as List<Map<String, dynamic>>;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10.0,
                          mainAxisSpacing: 10.0,
                          childAspectRatio: 1.0,
                        ),
                        itemCount: tShirts.length,
                        itemBuilder: (context, index) {
                          final item = tShirts[index];
                          return ClothingItem(
                            name: item['name'],
                            price: item['price'],
                            imageUrl: item['imageUrl'],
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ClothingDetailpage(
                                    cartItems: cartItems,
                                    name: item['name'],
                                    price: item['price'],
                                    imageUrl: item['imageUrl'],
                                    onAddToCart: () {
                                      addToCart(item['name'], item['price'],
                                          item['imageUrl']);
                                    },
                                    updateCartCount: updateCartCount,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    );
                  }
                },
              ),
            ),

            Container(
              child: FutureBuilder(
                future: fetchAllClothingItemsByCategory('Shoes'),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error fetching data'));
                  } else {
                    List<Map<String, dynamic>> shorts =
                        snapshot.data as List<Map<String, dynamic>>;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10.0,
                          mainAxisSpacing: 10.0,
                          childAspectRatio: 1.0,
                        ),
                        itemCount: shorts.length,
                        itemBuilder: (context, index) {
                          final item = shorts[index];
                          return ClothingItem(
                            name: item['name'],
                            price: item['price'],
                            imageUrl: item['imageUrl'],
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ClothingDetailpage(
                                    cartItems: cartItems,
                                    name: item['name'],
                                    price: item['price'],
                                    imageUrl: item['imageUrl'],
                                    onAddToCart: () {
                                      addToCart(item['name'], item['price'],
                                          item['imageUrl']);
                                    },
                                    updateCartCount: updateCartCount,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    );
                  }
                },
              ),
            ),
            // Content for Tab 5
            Container(
              child: FutureBuilder(
                future: fetchAllClothingItemsByCategory('Bag'),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error fetching data'));
                  } else {
                    List<Map<String, dynamic>> bags =
                        snapshot.data as List<Map<String, dynamic>>;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10.0,
                          mainAxisSpacing: 10.0,
                          childAspectRatio: 1.0,
                        ),
                        itemCount: bags.length,
                        itemBuilder: (context, index) {
                          final item = bags[index];
                          return ClothingItem(
                            name: item['name'],
                            price: item['price'],
                            imageUrl: item['imageUrl'],
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ClothingDetailpage(
                                    cartItems: cartItems,
                                    name: item['name'],
                                    price: item['price'],
                                    imageUrl: item['imageUrl'],
                                    onAddToCart: () {
                                      addToCart(item['name'], item['price'],
                                          item['imageUrl']);
                                    },
                                    updateCartCount: updateCartCount,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: SafeArea(
          // 👈 Prevent overflow on devices with system bars
          child: BottomAppBar(
            shape: const CircularNotchedRectangle(),
            color: Theme.of(context).colorScheme.surfaceVariant,
            elevation: 12,
            child: SizedBox(
              height: 60, // 👈 Adjusted height to fit nicely
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Home Button
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        // Navigate to home
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.home_outlined, size: 24),
                          SizedBox(height: 2),
                          Text('Home', style: TextStyle(fontSize: 12)),
                        ],
                      ),
                    ),
                  ),

                  // Spacer for FAB
                  const SizedBox(width: 48),

                  // Profile Button
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        // Navigate to profile
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.account_circle_outlined, size: 24),
                          SizedBox(height: 2),
                          Text('Profile', style: TextStyle(fontSize: 12)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        drawer: Drawer(
          child: Column(
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                ),
                child: Center(
                  child: Text(
                    'Stocks',
                    style: TextStyle(
                      fontSize: 22,
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.home_outlined),
                title: const Text('Home'),
                onTap: () {
                  // Navigate
                },
              ),
              ListTile(
                leading: const Icon(Icons.payment_outlined),
                title: const Text('Payment Info'),
                onTap: () {
                  // Navigate
                },
              ),
              ListTile(
                leading: const Icon(Icons.phone),
                title: const Text('Contact'),
                onTap: () {
                  // Navigate
                },
              ),
              ListTile(
                leading: const Icon(Icons.info_outline),
                title: const Text('About Us'),
                onTap: () {
                  // Navigate
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
