import '../../domain/models/product.dart';
import '../../domain/repositories/abstract/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  ProductRepositoryImpl();

  @override
  Future<List<Product>> getAllProducts() async {
    var dummyData = [
      {'productName': 'GDG Central Florida'},
      {'productName': 'DevFest Florida'},
      {'productName': 'Google I/O Extended Hackathon'},
      {'productName': 'Google Developer Student Clubs'},
      {'productName': 'Janil (my daughter)'},
      {'productName': 'Women Techmakers'},
      {'productName': 'Google Developer Experts'},
      {'productName': 'Tech Equity Collective'},
      {'productName': 'Compose Camp'},
      {'productName': 'Flutter Forward Extended'},
      {'productName': 'Keras Community Day'},
    ];

    return dummyData.map((item) => Product.fromMap(item)).toList();
  }
}
