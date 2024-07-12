import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:route_task/core/utilities/app_color.dart';
import 'package:route_task/providers/product_provider.dart';
import 'package:route_task/widgets/main_text.dart';

class ProductListScreen extends StatefulWidget {
  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProductProvider>(context, listen: false).fetchProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: MainText.pageTitle('Route'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  flex: 6,
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: 'What do you search for?',
                      prefixIcon: Icon(Icons.search, size: 30, color: AppColors.primary),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                        borderSide: BorderSide(color: AppColors.primary, width: 2),
                      ),
                    ),
                    onChanged: (value) {
                      Provider.of<ProductProvider>(context, listen: false).filterProducts(value);
                    },
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Icon(Icons.shopping_cart, size: 30, color: AppColors.primary),
                ),
              ],
            ),
          ),
          Expanded(
            child: Consumer<ProductProvider>(
              builder: (context, productProvider, child) {
                if (productProvider.isLoading) {
                  return Center(child: CircularProgressIndicator());
                }

                if (productProvider.isSearching && productProvider.products.isEmpty) {
                  return Center(child: Text('No products found.'));
                }

                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 0.75,
                  ),
                  itemCount: productProvider.products.length,
                  itemBuilder: (context, index) {
                    final product = productProvider.products[index];
                    return Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.secondary, width: 2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Center(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  width: double.infinity,
                                  child: Stack(
                                    alignment: Alignment.topRight,
                                    children: [
                                      Center(
                                        child: Image.network(
                                          product.thumbnail,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          width: 30,
                                          height: 30,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(50),
                                            color: Colors.white,
                                          ),
                                          child: Icon(Icons.favorite_border, color: AppColors.primary),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  MainText.title(product.title),
                                  MainText.title(
                                    product.description.length > 50
                                        ? '${product.description.substring(0, 50)}..'
                                        : product.description,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 4),
                                  Row(
                                    children: [
                                      MainText.title('\$${product.discountPercentage.toString()}'),
                                      SizedBox(width: 30),
                                      MainText.title(
                                        '\$${product.price.toString()}',
                                        color: Colors.blue,
                                        decoration: TextDecoration.lineThrough,
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          MainText.title('Review (${product.rating.toString()})'),
                                          Icon(Icons.star, color: Colors.amber),
                                        ],
                                      ),
                                      Container(
                                        height: 30,
                                        width: 30,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(50),
                                          color: AppColors.primary,
                                        ),
                                        child: Icon(Icons.add, color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
