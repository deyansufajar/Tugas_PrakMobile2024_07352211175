import 'dart:async';

// Enum untuk menentukan peran pengguna
enum Role { Admin, Customer }

// Kelas Produk untuk mendefinisikan produk dalam sistem
class Product {
  final String productName;
  final double price;
  final bool inStock;

  Product({
    required this.productName,
    required this.price,
    required this.inStock,
  });
}

// Kelas dasar User yang akan digunakan oleh AdminUser dan CustomerUser
class User {
  String name;
  int age;
  late List<Product> products; // Inisialisasi menggunakan late
  Role? role;

  User({required this.name, required this.age, this.role});

  void viewProducts() {
    if (products.isEmpty) {
      print("Tidak ada produk tersedia.");
    } else {
      print("Daftar Produk:");
      for (var product in products) {
        print("Nama: ${product.productName}, Harga: Rp${product.price}, Tersedia: ${product.inStock}");
      }
    }
  }
}

// Subkelas AdminUser untuk pengguna dengan peran Admin
class AdminUser extends User {
  AdminUser({required String name, required int age})
      : super(name: name, age: age, role: Role.Admin) {
    products = [];
  }

  void addProduct(Product product, Map<String, Product> productCatalog, Set<String> productSet) {
    try {
      // Mengecek ketersediaan stok
      if (!product.inStock) {
        throw Exception("Produk ${product.productName} tidak tersedia dalam stok!");
      }
      // Menambahkan produk ke set untuk memastikan tidak ada duplikasi
      if (productSet.add(product.productName)) {
        products.add(product);
        productCatalog[product.productName] = product;
        print("Produk ${product.productName} berhasil ditambahkan.");
      } else {
        print("Produk ${product.productName} sudah ada di katalog.");
      }
    } catch (e) {
      print("Error saat menambahkan produk: ${e}");
    }
  }

  void removeProduct(String productName, Map<String, Product> productCatalog) {
    var product = productCatalog[productName];
    if (product != null) {
      products.remove(product);
      productCatalog.remove(productName);
      print("Produk $productName berhasil dihapus.");
    } else {
      print("Produk $productName tidak ditemukan di katalog.");
    }
  }
}

// Subkelas CustomerUser untuk pengguna dengan peran Customer
class CustomerUser extends User {
  CustomerUser({required String name, required int age})
      : super(name: name, age: age, role: Role.Customer) {
    products = [];
  }

  @override
  void viewProducts() {
    super.viewProducts();
  }
}

// Fungsi asinkron untuk mengambil detail produk dari server
Future<void> fetchProductDetails(Product product) async {
  print("Mengambil detail untuk ${product.productName}...");
  await Future.delayed(Duration(seconds: 2));
  print("Detail ${product.productName}: Harga: Rp${product.price}, Tersedia: ${product.inStock}");
}

void main() async {
  // Katalog produk dan set untuk memastikan produk unik
  Map<String, Product> productCatalog = {};
  Set<String> productSet = {};

  // Membuat instance AdminUser dan CustomerUser
  var admin = AdminUser(name: "Alice", age: 30);
  var customer = CustomerUser(name: "Bob", age: 25);

  // Menambah produk dengan AdminUser
  var product1 = Product(productName: "Laptop", price: 15000000, inStock: true);
  var product2 = Product(productName: "Smartphone", price: 8000000, inStock: false);
  var product3 = Product(productName: "Headphone", price: 2000000, inStock: true);

  admin.addProduct(product1, productCatalog, productSet); // Produk tersedia dalam stok
  admin.addProduct(product2, productCatalog, productSet); // Produk tidak tersedia dalam stok
  admin.addProduct(product3, productCatalog, productSet); // Produk tersedia dalam stok

  // Menghapus produk dari daftar
  admin.removeProduct("Smartphone", productCatalog);

  // CustomerUser mencoba melihat daftar produk
  print("\nProduk yang dapat dilihat oleh Customer:");
  customer.viewProducts();

  // Admin melihat produk yang tersedia
  print("\nProduk yang dapat dilihat oleh Admin:");
  admin.viewProducts();

  // Asynchronous mengambil detail dari produk
  await fetchProductDetails(product1);
}