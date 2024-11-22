import 'package:flutter/material.dart';
import 'package:limerick_generator/controller/poem_controller.dart';
import 'package:limerick_generator/controller/product_controller.dart';

import 'domain/models/product.dart';

class LimerickPage extends StatefulWidget {
  const LimerickPage({super.key, required this.title});

  final String title;

  @override
  State<LimerickPage> createState() => LimerickPageState();
}

class LimerickPageState extends State<LimerickPage> {
  List<Product> listProduct = [];
  final ProductController productController = ProductController();
  final PoemController poemController = PoemController();

  String limerickText = '';
  String productName = 'Google Development Group';

  String subTitle = 'Choose a Google event or program here:';

  Future getProductData() async {
    var productData = await productController.getProducts();
    setState(() {
      listProduct = productData;
    });
  }

  Future getLimerickTextData(String productName) async {
    var poemData = await poemController.getPoem(productName);
    setState(() {
      limerickText = poemData;
    });
  }

  @override
  void initState() {
    super.initState();
    getProductData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 8.0,
      ),
      body: Center(
        child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                buildTopView(),
                const SizedBox(
                  height: 10.0,
                ),
                buildBottomView()
              ],
            )),
      ),
    );
  }

  Column buildTopView() {
    return Column(
      children: <Widget>[
        Text(
          subTitle,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        SizedBox(
          width: 150.0,
          child: DropdownButton<Product>(
            items: listProduct.map((Product value) {
              return DropdownMenuItem<Product>(
                value: value,
                child: Container(
                  padding:
                      const EdgeInsets.all(8.0), // Increase as per your requirement
                  child: Text(value.productName),
                ),
              );
            }).toList(),
            hint: Text(
              productName.toString(),
              style: const TextStyle(color: Colors.deepPurpleAccent),
            ),
            underline: Container(
              height: 1,
              color: Theme.of(context).primaryColor,
            ),
            onChanged: (value) {
              setState(() {
                productName = value!.productName;
                limerickText = '';
              });
            },
            isExpanded: true,
          ),
        ),
        ElevatedButton.icon(
          icon: const Icon(Icons.auto_stories),
          label: const Text('Generate limerick!'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).primaryColor,
            foregroundColor: Colors.white,
            elevation: 5.0,
          ),
          onPressed: () => getLimerickTextData(productName.toString()),
        ),
      ],
    );
  }
  Expanded buildBottomView() {
    return Expanded(
      child: limerickText.isNotEmpty
          ? Card(
              color: Colors.amberAccent.shade100,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 4.0,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: double.maxFinite,
                  child: SingleChildScrollView(
                    child: Text(
                      limerickText,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ),
              ),
            )
          : const CircularProgressIndicator(),
    );
  }
}
