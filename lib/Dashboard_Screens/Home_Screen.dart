import 'dart:convert'; // for base64Decode
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shopify/Athentication_module/Login.dart';
import 'package:shopify/BottomBar_Screen/Profile_Screen.dart';
import 'package:shopify/Dashboard_Screens/Order_Detail.dart';
import 'package:shopify/Product_model.dart';
import '../Global_List.dart';
import '../Services/Carts_Services.dart';
import 'Add_Product.dart';
import 'Cart_Products.dart';
import 'Detail_Product_Screen.dart';
import 'Favourite_Screen.dart';

class HomeScreen extends StatefulWidget {
  final String userId;
  const HomeScreen({super.key, required this.userId});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Map<String, bool> _isfavourited = {}; // ✅ product.id based

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              icon: Icon(Icons.menu),
            );
          },
        ),
        title: const Text(
          "All Products",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
        elevation: 4,
        iconTheme: IconThemeData(color: Colors.white),
      ),

      // ✅ Drawer
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: Text("Adeel"),
              accountEmail: Text("madeelahmad986@gmail.com"),
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage('asset/Adeel.jpg'),
              ),
              decoration: BoxDecoration(color: Colors.deepPurple),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text("Home"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomeScreen(userId: FirebaseAuth.instance.currentUser!.uid),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.favorite),
              title: Text("Favourites"),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => FavouriteScreen()));
              },
            ),
            ListTile(
              leading: Icon(Icons.shopping_cart),
              title: Text("Cart"),
              onTap: () {
                final userId = FirebaseAuth.instance.currentUser!.uid;
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CartProducts(userId: userId)));
              },
            ),
            ListTile(
              leading: Icon(Icons.details),
              title: Text("Order Details"),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => OrderDetail()));
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text("Logout"),
              onTap: () {
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) => Login()));
              },
            ),
          ],
        ),
      ),

      // ✅ Product Grid
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("Products")
            .orderBy("createdAt", descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          // print(snapshot.data!.docs.map((e) => e.data()).toList());
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.white,
              ),
            );
          }
          if (snapshot.hasError) {
            return Center(child: Text("Something went wrong: ${snapshot.error}"));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("No Products Added Yet"));
          }

          final products = snapshot.data!.docs.map((doc) {
            return Product.fromMap(doc.data() as Map<String, dynamic>, doc.id);
          }).toList();



          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: GridView.builder(
              itemCount: products.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 0.65,
              ),
              itemBuilder: (context, index) {
                final product = products[index];
                final bool isfav = _isfavourited[product.id] ?? false;

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => DetailProductScreen(product: product)),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade300,
                          blurRadius: 6,
                          offset: const Offset(2, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ✅ Product Image
                        ClipRRect(
                          borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(12)),
                          child: product.images.isNotEmpty
                              ? Image.memory(
                            base64Decode(product.images.first),
                            height: 130,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          )
                              : Container(
                            height: 130,
                            color: Colors.grey[300],
                            child: const Center(
                              child: Icon(Icons.image, size: 50),
                            ),
                          ),
                        ),
                        SizedBox(height: 8),

                        // ✅ Fav + Cart Buttons
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                onPressed: () async{
                                  final String userId= FirebaseAuth.instance.currentUser!.uid;
                                    if (isfav) {

                                      await FirebaseFirestore.instance.collection("Users")
                                          .doc(userId).collection("Favourites").doc(product.id).delete();
                                      setState(() {
                                        _isfavourited[product.id] = false;
                                        favourites.remove(product);
                                      });
                                      Fluttertoast.showToast(
                                        msg: "Product removed from Favourites",
                                        backgroundColor: Colors.blue,
                                        textColor: Colors.white,
                                      );
                                    } else {
                                      await FirebaseFirestore.instance.collection("Users")
                                          .doc(userId).collection("Favourites").doc(product.id)
                                          .set(product.toMap());
                                      setState(() {
                                        _isfavourited[product.id] = true;
                                        favourites.add(product);
                                      });
                                      Fluttertoast.showToast(
                                        msg: "Your Product is added to Favourites",
                                        backgroundColor: Colors.blue,
                                        textColor: Colors.white,
                                      );
                                    }
                                  
                                },
                                icon: Icon(
                                  isfav ? Icons.favorite : Icons.favorite_border,
                                  color: isfav ? Colors.red : Colors.grey,
                                ),
                              ),
                              IconButton(
                                onPressed: () async {
                                  final Carts_Services _carts_services = Carts_Services();
                                  // setState(() {
                                  //   if (cartlist.contains(product)) {
                                  //     cartlist.remove(product);
                                  //   } else {
                                  //     cartlist.add(product);
                                  //   }
                                  // });

                                  // 🔹 Firestore integration
                                  if (cartlist.contains(product)) {
                                    // removed to Firestore

                                    await _carts_services.removeFromCart(
                                      widget.userId,
                                      product.id,
                                    );
                                    Fluttertoast.showToast(
                                      msg: "Your Product is removed from Cart",
                                      backgroundColor: Colors.blue,
                                      textColor: Colors.white,
                                    );

                                  }
                                  else {
                                    //added to firebase
                                    await _carts_services.addToCart(
                                      widget.userId,
                                      product,
                                    );
                                    Fluttertoast.showToast(
                                      msg: "Your Product is added to Cart",
                                      backgroundColor: Colors.blue,
                                      textColor: Colors.white,
                                    );
                                    // Remove from Firestore

                                  }
                                },
                                icon: Icon(
                                  cartlist.contains(product)
                                      ? Icons.shopping_cart
                                      : Icons.shopping_cart_outlined,
                                  color: cartlist.contains(product)
                                      ? Colors.deepPurple
                                      : Colors.grey,
                                ),
                              )
                            ],
                          ),
                        ),

                        // ✅ Product Details
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product.name,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold, fontSize: 16),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 5),

                                  Row(
                                    children: [
                                      Text(
                                        "Rs. ${product.price}",
                                        style: const TextStyle(
                                          color: Colors.deepPurple,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      if (product.discountPrice != null) ...[
                                        const SizedBox(width: 6),
                                        Text(
                                          "Rs. ${product.discountPrice}",
                                          style: const TextStyle(
                                            color: Colors.red,
                                            fontSize: 12,
                                            decoration:
                                            TextDecoration.lineThrough,
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),

                                  const SizedBox(height: 4),
                                  Text("Category: ${product.category}",
                                      style: const TextStyle(fontSize: 12)),
                                  Text("Sub Category: ${product.subCategory}",
                                      style: TextStyle(fontSize: 12)),

                                  Text(
                                    product.isAvailable
                                        ? "In Stock (${product.stock} units)"
                                        : "Out of Stock",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: product.isAvailable
                                          ? Colors.green
                                          : Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),

      // ✅ Add Product FAB
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AddProduct()));
        },
        backgroundColor: Colors.deepPurple,
        child: Icon(Icons.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      // ✅ Bottom NavBar
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 8.0,
        color: Colors.white,
        elevation: 10,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {},
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.home, color: Colors.deepPurple),
                      SizedBox(height: 4),
                      Text("Home",
                          style: TextStyle(color: Colors.deepPurple, fontSize: 12)),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ProfileScreen()));
                },
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.person, color: Colors.deepPurple),
                      SizedBox(height: 4),
                      Text("Profile",
                          style: TextStyle(color: Colors.deepPurple, fontSize: 12)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}