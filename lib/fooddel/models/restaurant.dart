import 'package:flutter/material.dart';

class Restaurant {
  final String title, foodType, description, image, price, address;
  final double rating, ratingNo;

  Restaurant({
    this.foodType,
    @required this.image,
    this.rating,
    this.ratingNo,
    this.address,
    @required this.title,
    @required this.price,
    @required this.description,
  });
}

// Our demo Products

List<Restaurant> demoRestaurant = [
  Restaurant(
    ratingNo: 35,
    title: "Cafeke Rabina",
    image: 'assets/images/davide-cantelli-jpkfc5_d-DI-unsplash.jpg',
    price: '\$4 - \$12',
    description: 'Specializes in Salmos foods, sea foods, Pizzas and all other vegan meals. Our delivery takes not more than 30 minutes to get to your doorstep. Enjoy!!',
    rating: 4.8,
    foodType: 'Chinese, Italian, burgers, BBQ, etc',
    address: 'No 389B gbenga  street, Opp Marina bank, Lagos'
  ),
  Restaurant(
      ratingNo: 298,
      title: "Dallates Kitchen",
      image: 'assets/images/brooke-lark-W9OKrxBqiZA-unsplash.jpg',
      price: '\$5 - \$18',
      description: 'Specializes in Salmos foods, sea foods, Pizzas and all other vegan meals. Our delivery takes not more than 30 minutes to get to your doorstep. Enjoy!!',
      rating: 4.8,
      foodType: 'Chinese, Italian, burgers, BBQ, etc',
      address: 'No 389B gbenga  street, Opp Marina bank, Lagos'
  ),
  Restaurant(
      ratingNo: 15,
      title: "Veredenta Spot",
      image: 'assets/images/brooke-lark-HlNcigvUi4Q-unsplash.jpg',
      price: '\$6 - \$23',
      description: 'Specializes in Salmos foods, sea foods, Pizzas and all other vegan meals. Our delivery takes not more than 30 minutes to get to your doorstep. Enjoy!!',
      rating: 4.6,
      foodType: 'Chinese, Italian, burgers, BBQ, etc',
      address: 'No 389B gbenga  street, Opp Marina bank, Lagos'
  ),

];
