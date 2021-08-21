import 'package:flutter/material.dart';

class Reviews {
  final String name, image, review, date;
  final double rating;

  Reviews({
    this.name,
    @required this.image,
    this.rating,
    this.review,
    @required this.date,

  });
}

// Our demo Products

List<Reviews> demoReviews = [
  Reviews(
      name: 'Errica Hoffman',
      image: 'assets/images/prince-akachi-J1OScm_uHUQ-unsplash.jpg',
      rating: 4.8,
      review: 'Interdum et malesuada fames ac ante ipsum primis in faucibus. Morbi ut nisi odio. Nulla facilisi. Nunc risus massa, gravida id egestas',
      date: '05- oct 2020',
  ),
  Reviews(
    name: 'Wade Warren',
    image: 'assets/images/pexels-alfian-dimas-5242017.jpg',
    rating: 4.8,
    review: 'Interdum et malesuada fames ac ante ipsum primis in faucibus. Morbi ut nisi odio. Nulla facilisi. Nunc risus massa, gravida id egestas',
    date: '05- oct 2020',
  ),
  Reviews(
    name: 'Devon Lane',
    image: 'assets/images/pexels-bulgariangeorge-7032989.jpg',
    rating: 4.8,
    review: 'Interdum et malesuada fames ac ante ipsum primis in faucibus. Morbi ut nisi odio. Nulla facilisi. Nunc risus massa, gravida id egestas',
    date: '05- oct 2020',
  ),
  Reviews(
    name: 'Courtney Henry',
    image: 'assets/images/pexels-ewiin-boediyanto-6474325.jpg',
    rating: 4.3,
    review: 'Interdum et malesuada fames ac ante ipsum primis in faucibus. Morbi ut nisi odio. Nulla facilisi. Nunc risus massa, gravida id egestas',
    date: '05- oct 2020',
  ),
  Reviews(
    name: 'Kathryn Murphy',
    image: 'assets/images/pexels-rama-sondana-6768250.jpg',
    rating: 4.2,
    review: 'Interdum et malesuada fames ac ante ipsum primis in faucibus. Morbi ut nisi odio. Nulla facilisi. Nunc risus massa, gravida id egestas',
    date: '05- oct 2020',
  ),

];
