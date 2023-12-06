// import 'package:flutter/material.dart';
// import 'package:carousel_slider/carousel_slider.dart';
// import 'model.dart';
//
// class OpenImages extends StatelessWidget {
//
//
//   OpenImages({required imageUrls});
//
//   @override
//   Widget build(BuildContext context) {
//     final ProductData? product;
//     final List<String> imageUrls = product!.images.map((imageData) {
//       return 'https://dealkarde.com/image/${imageData.toString()}';
//     }).toList();
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Image Slider'),
//       ),
//       body: CarouselSlider(
//         options: CarouselOptions(
//           height: 400.0,
//           enlargeCenterPage: true,
//           autoPlay: true,
//           aspectRatio: 16 / 9,
//           autoPlayCurve: Curves.fastOutSlowIn,
//           enableInfiniteScroll: true,
//           autoPlayAnimationDuration: Duration(milliseconds: 800),
//           viewportFraction: 0.8,
//         ),
//         items: imageUrls.map((imageUrl) {
//           return Builder(
//             builder: (BuildContext context) {
//               return Container(
//                 width: MediaQuery.of(context).size.width,
//                 margin: EdgeInsets.symmetric(horizontal: 5.0),
//                 decoration: BoxDecoration(
//                   color: Colors.amber,
//                   borderRadius: BorderRadius.circular(8.0),
//                 ),
//                 child: FadeInImage(
//                   placeholder: AssetImage('asset/image/placeholder.jpg'),
//                   image: NetworkImage(imageUrl),
//                   fit: BoxFit.cover,
//                 ),
//               );
//             },
//           );
//         }).toList(),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'model.dart';

class OpenImages extends StatelessWidget {
  final List<String> imageUrls;

  OpenImages({required this.imageUrls});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Slider'),
      ),
      body: CarouselSlider(
        options: CarouselOptions(
          height: 400.0,
          enlargeCenterPage: true,
          autoPlay: true,
          aspectRatio: 16 / 9,
          autoPlayCurve: Curves.fastOutSlowIn,
          enableInfiniteScroll: true,
          autoPlayAnimationDuration: Duration(milliseconds: 800),
          viewportFraction: 0.8,
        ),
        items: imageUrls.map((imageUrl) {
          return Builder(
            builder: (BuildContext context) {
              return Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.symmetric(horizontal: 5.0),
                decoration: BoxDecoration(
                  color: Colors.amber,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: FadeInImage(
                  placeholder: AssetImage('asset/image/placeholder.jpg'),
                  image: NetworkImage(imageUrl),
                  fit: BoxFit.cover,
                ),
              );
            },
          );
        }).toList(),
      ),
    );
  }
}
