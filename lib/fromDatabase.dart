class Product {
  String ProductName,catagory,image;
  double price;
  Product(this.catagory,this.image,this.price,this.ProductName);

  Product.fromMap(Map<dynamic, dynamic> data) {
    ProductName = data['ProductName'];

    catagory = data['category'];
    image = data['image'];
    price = data['subIngredients'];
  }
  Map<dynamic, dynamic> toMap() {
    return {
//      'id': id,
      'ProductName': ProductName,
      'catagory': catagory,
      'image': image,
      'price': price,

    };
  }
}
class Catagory{
  String name;
  Catagory(this.name);
}