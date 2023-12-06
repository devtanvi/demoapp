class Product {
  final int success;
  final List<ProductData> data;

  Product({required this.success, required this.data});

  factory Product.fromJson(Map<String, dynamic> json) {
    final List<dynamic>? jsonData = json['Data'];
    List<ProductData> productData = [];

    if (jsonData != null) {
      productData = jsonData.map((data) => ProductData.fromJson(data)).toList();
    }
    return Product(
      success: json['success'],
      data: productData,
    );
  }
}

class ProductData {
  final String productId;
  final String model;
  final String sku;
  final String upc;
  final String ean;
  final String jan;
  final String isbn;
  final String mpn;
  final String location;
  final String quantity;
  final String stockStatusId;
  final String image;
  final String manufacturerId;
  final String shipping;
  final String price;
  final String originalPrice;
  final String points;
  final String taxClassId;
  final String dateAvailable;
  final String weight;
  final String weightCharge;
  final String weightClassId;
  final String length;
  final String width;
  final String height;
  final String lengthClassId;
  final String subtract;
  final String minimum;
  final String sortOrder;
  final String status;
  final String viewed;
  final String dateAdded;
  final String dateModified;
  final String? lookbookId; // This field may be nullable
  final String name;
  final String description;
  final String specialPrice;
  final List<ProductImage> images;
  final List<ProductAttribute> attribute;

  ProductData({
    required this.productId,
    required this.model,
    required this.sku,
    required this.upc,
    required this.ean,
    required this.jan,
    required this.isbn,
    required this.mpn,
    required this.location,
    required this.quantity,
    required this.stockStatusId,
    required this.image,
    required this.manufacturerId,
    required this.shipping,
    required this.price,
    required this.originalPrice,
    required this.points,
    required this.taxClassId,
    required this.dateAvailable,
    required this.weight,
    required this.weightCharge,
    required this.weightClassId,
    required this.length,
    required this.width,
    required this.height,
    required this.lengthClassId,
    required this.subtract,
    required this.minimum,
    required this.sortOrder,
    required this.status,
    required this.viewed,
    required this.dateAdded,
    required this.dateModified,
    this.lookbookId,
    required this.name,
    required this.description,
    required this.specialPrice,
    required this.images,
    required this.attribute,
  });

  factory ProductData.fromJson(Map<String, dynamic> json) {
    final List<dynamic>? imagesData = json['images'];
    final List<ProductImage> productImages = imagesData != null
        ? imagesData.map((image) => ProductImage.fromJson(image)).toList()
        : [];

    final List<dynamic>? attributesData = json['attribute'];
    final List<ProductAttribute> productAttributes = attributesData != null
        ? attributesData.map((attr) => ProductAttribute.fromJson(attr)).toList()
        : [];

    return ProductData(
      productId: json['product_id'] ?? '',
      // Provide a default value
      model: json['model'] ?? '',
      sku: json['sku'] ?? '',
      upc: json['upc'] ?? '',
      ean: json['ean'] ?? '',
      jan: json['jan'] ?? '',
      isbn: json['isbn'] ?? '',
      mpn: json['mpn'] ?? '',
      location: json['location'] ?? '',
      quantity: json['quantity'] ?? '',
      stockStatusId: json['stock_status_id'] ?? '',
      image: json['image'] ?? '',
      manufacturerId: json['manufacturer_id'] ?? '',
      shipping: json['shipping'] ?? '',
      price: json['price'] ?? '',
      originalPrice: json['original_price'] ?? '',
      points: json['points'] ?? '',
      taxClassId: json['tax_class_id'] ?? '',
      dateAvailable: json['date_available'] ?? '',
      weight: json['weight'] ?? '',
      weightCharge: json['weight_charge'] ?? '',
      weightClassId: json['weight_class_id'] ?? '',
      length: json['length'] ?? '',
      width: json['width'] ?? '',
      height: json['height'] ?? '',
      lengthClassId: json['length_class_id'] ?? '',
      subtract: json['subtract'] ?? '',
      minimum: json['minimum'] ?? '',
      sortOrder: json['sort_order'] ?? '',
      status: json['status'] ?? '',
      viewed: json['viewed'] ?? '',
      dateAdded: json['date_added'] ?? '',
      dateModified: json['date_modified'] ?? '',
      lookbookId: json['lookbook_id'],
      name: json['name'] ?? '',
      description: json['description'],
      specialPrice: json['special_price'],
      images: productImages,
      attribute: productAttributes,
    );
  }
}

class ProductImage {
  final String image;

  ProductImage({required this.image});

  factory ProductImage.fromJson(Map<String, dynamic> json) {
    return ProductImage(image: json['image']);
  }
}

class ProductAttribute {
  final String text;
  final String name;

  ProductAttribute({required this.text, required this.name});

  factory ProductAttribute.fromJson(Map<String, dynamic> json) {
    return ProductAttribute(text: json['text'], name: json['name']);
  }
}
// // class Product {
// //   final int success;
// //   final List<ProductData> data;
// //
// //   Product({
// //     required this.success,
// //     required this.data,
// //   });
// //
// //   factory Product.fromJson(Map<String, dynamic> json) {
// //     final List<dynamic> dataJson = json['Data'];
// //     final List<ProductData> data = dataJson.map((item) => ProductData.fromJson(item)).toList();
// //
// //     return Product(
// //       success: json['success'],
// //       data: data,
// //     );
// //   }
// // }
// //
// // class ProductData {
// //   final String productId;
// //   final String model;
// //   final String sku;
// //   final String upc;
// //   final String ean;
// //   final String jan;
// //   final String isbn;
// //   final String mpn;
// //   // Add other properties here...
// //
// //   ProductData({
// //     required this.productId,
// //     required this.model,
// //     required this.sku,
// //     required this.upc,
// //     required this.ean,
// //     required this.jan,
// //     required this.isbn,
// //     required this.mpn,
// //     // Add other required properties here...
// //   });
// //
// //   factory ProductData.fromJson(Map<String, dynamic> json) {
// //     return ProductData(
// //       productId: json['product_id'],
// //       model: json['model'],
// //       sku: json['sku'],
// //       upc: json['upc'],
// //       ean: json['ean'],
// //       jan: json['jan'],
// //       isbn: json['isbn'],
// //       mpn: json['mpn'],
// //       // Map other properties...
// //     );
// //   }
// // }
