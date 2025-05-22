import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../Global_List.dart';
import 'Add_Product.dart';
import 'Detail_Product_Screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Map<int, bool> _isfavourited = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(builder: (BuildContext context){
          return IconButton(onPressed: (){
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
                  decoration: BoxDecoration(
                    color: Colors.deepPurple,
                  ),
             ),
                ListTile(
                  leading: Icon(Icons.home),
                  title: Text("Home"),
                  onTap: (){},
                ),
             ListTile(
               leading: Icon(Icons.favorite),
               title: Text("Favourites"),
               onTap: (){},
             ),
             ListTile(
               leading: Icon(Icons.shopping_cart),
               title: Text("Cart"),
               onTap: (){},
             ),
             Divider(),
             ListTile(
               leading: Icon(Icons.logout),
               title: Text("Logout"),
               onTap: (){},
             ),
           ],
         ),
      ),
      body:
          AllProducts.isEmpty
              ? const Center(child: Text("No Products Added Yet"))
              : Padding(
                padding: const EdgeInsets.all(10.0),
                child: GridView.builder(
                  itemCount: AllProducts.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 0.65,
                  ),
                  itemBuilder: (context, index) {
                    final product = AllProducts[index];
                    final bool isfav = _isfavourited[index] ?? false;
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) => DetailProductScreen(product: product),
                          ),
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
                            ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(12),
                              ),
                              child:
                                  product.images.isNotEmpty
                                      ? Image.file(
                                        product.images[0],
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
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      setState(() {
                                        if (isfav) {
                                          // already favourite => remove
                                          _isfavourited[index] = false;
                                          favourites.remove(product);
                                          Fluttertoast.showToast(
                                            msg:
                                                "Product removed from Favourites",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM,
                                            backgroundColor: Colors.blue,
                                            textColor: Colors.white,
                                            fontSize: 15.0,
                                          );
                                        }
                                        // NotFavourite => Add
                                        else {
                                          _isfavourited[index] = true;
                                          favourites.add(product);
                                          Fluttertoast.showToast(
                                            msg:
                                                "Your Product is added to Favourites",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM,
                                            backgroundColor: Colors.blue,
                                            textColor: Colors.white,
                                            fontSize: 15.0,
                                          );
                                        }
                                      });
                                    },
                                    icon: Icon(
                                      isfav
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      color: isfav ? Colors.red : Colors.grey,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      setState(() {
                                        if (cartlist.contains(product)) {
                                          cartlist.remove(product);
                                          Fluttertoast.showToast(
                                            msg:
                                                "Your Product is remove from Cart",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM,
                                            backgroundColor: Colors.blue,
                                            textColor: Colors.white,
                                            fontSize: 15.0,
                                          );
                                        } else {
                                          cartlist.add(product);
                                          Fluttertoast.showToast(
                                            msg:
                                                "Your Product is added to Cart",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM,
                                            backgroundColor: Colors.blue,
                                            textColor: Colors.white,
                                            fontSize: 15.0,
                                          );
                                        }
                                      });
                                    },
                                    icon: Icon(
                                        cartlist.contains(product)? Icons.shopping_cart : Icons.shopping_cart_outlined,
                                      color: cartlist.contains(product)? Colors.deepPurple: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        product.name,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 5),

                                      // ✅ PRICE AND DISCOUNT
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
                                          if (product.discountPrice !=
                                              null) ...[
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
                                      Text(
                                        "Category: ${product.category}",
                                        style: const TextStyle(fontSize: 12),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        "Stock: ${product.stock} units",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color:
                                              product.isAvailable
                                                  ? Colors.green
                                                  : Colors.red,
                                        ),
                                      ),

                                      const SizedBox(height: 4),
                                      Text(
                                        "Category: ${product.category}",
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                      Text(
                                        "Stock: ${product.isAvailable ? 'In Stock' : 'Out of Stock'}",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color:
                                              product.isAvailable
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
              ),
    );
  }
}
 // project in progress...............