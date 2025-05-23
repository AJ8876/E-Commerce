import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shopify/Dashboard_Screens/Detail_Product_Screen.dart';
import 'package:shopify/Global_List.dart';

class FavouriteScreen extends StatefulWidget {
  const FavouriteScreen({super.key});

  @override
  State<FavouriteScreen> createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Favourites"),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
        foregroundColor: Colors.white,
      ),
      body:
          favourites.isEmpty
              ? Center(
                child: Text(
                  "No Favourites yet",
                  style: TextStyle(fontSize: 18, color: Colors.black54),
                ),
              )
              : Padding(
                padding: EdgeInsets.all(10.0),
                child: GridView.builder(
                  itemCount: favourites.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 0.65,
                  ),
                  itemBuilder: (context, index) {
                    final product = favourites[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) =>
                                    DetailProductScreen(product: product),
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
                              offset: Offset(2, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.vertical(
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
                                        child: Center(
                                          child: Icon(Icons.image, size: 50),
                                        ),
                                      ),
                            ),
                            SizedBox(height: 8),
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
