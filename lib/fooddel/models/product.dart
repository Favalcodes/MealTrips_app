import 'package:flutter/material.dart';

class Product {
  final int discount;
  final String title, foodType, ingredients, description, image;
  final double rating, price;
  final bool isDiscounted, isPopular;

  Product({
    @required this.discount,
    this.ingredients,
    this.foodType,
    @required this.image,
    this.rating,
    this.isDiscounted = false,
    this.isPopular = false,
    @required this.title,
    @required this.price,
    @required this.description,
  });
}

// Our demo Products

List<Product> demoProducts = [
  Product(
    discount: 5,
    title: "Salmon and Zucchini",
    image: 'assets/images/casey-lee-awj7sRviVXo-unsplash.jpg',
    price: 6,
    foodType: 'Italian Cuisine',
    description: 'Mixed with few meat and some other stuffs to prepare this sweet delicious salmon meal.bEat and Enjoy!!',
    ingredients: 'Mixed with few meat and some other stuffs to prepare this sweet delicious salmon meal. Eat and Enjoy!!',
    rating: 4.8,
    isDiscounted: true,
    isPopular: true,
  ),
  Product(
    discount: 10,
    title: 'Vegan Salad and carrot',
    image: 'assets/images/anna-pelzer-IGfIGP5ONV0-unsplash.jpg',
    price: 4,
    description: 'Mixed with few meat and some other stuffs to prepare this sweet delicious salmon meal.bEat and Enjoy!!',
    ingredients: 'Mixed with few meat and some other stuffs to prepare this sweet delicious salmon meal. Eat and Enjoy!!',
    rating: 4.5,
    foodType: 'Italian Cuisine',
    isPopular: true,
  ),
  Product(
    discount: 10,
    title: "Avocado and Egg ",
    foodType: 'Italian Cuisine',
    image: 'assets/images/joseph-gonzalez-fdlZBWIP0aM-unsplash.jpg',
    price: 6,
    description: 'Mixed with few meat and some other stuffs to prepare this sweet delicious salmon meal.bEat and Enjoy!!',
    ingredients: 'Mixed with few meat and some other stuffs to prepare this sweet delicious salmon meal. Eat and Enjoy!!',
    rating: 4.2,
    isDiscounted: false,
    isPopular: true,
  ),
  Product(
    discount: 10,
    title: "Tacos with vegetables ",
    foodType: 'Italian Cuisine',
    image: 'assets/images/foodiesfeed.com_tacos-with-pulled-pork-fresh-vegetables-and-cream.jpg',
    price: 5,
    description: 'Mixed with few meat and some other stuffs to prepare this sweet delicious salmon meal.bEat and Enjoy!!',
    ingredients: 'Mixed with few meat and some other stuffs to prepare this sweet delicious salmon meal. Eat and Enjoy!!',
    rating: 4.1,
    isDiscounted: true,
  ),
  Product(
    discount: 10,
    title: "Rice and Veg Sauce",
    foodType: 'Italian Cuisine',
    image: 'assets/images/foodiesfeed.com_tacos-with-pulled-pork-fresh-vegetables-and-cream.jpg',
    price: 5,
    description: 'Mixed with few meat and some other stuffs to prepare this sweet delicious salmon meal. Eat and Enjoy!!',
    ingredients: 'Mixed with few meat and some other stuffs to prepare this sweet delicious salmon meal. Eat and Enjoy!!',
    rating: 4.1,
    isDiscounted: true,
  ),
  Product(
    discount: 10,
    title: "Avocado and Egg ",
    foodType: 'Italian Cuisine',
    image: 'assets/images/joseph-gonzalez-fdlZBWIP0aM-unsplash.jpg',
    price: 6,
    description: 'Mixed with few meat and some other stuffs to prepare this sweet delicious salmon meal.bEat and Enjoy!!',
    ingredients: 'Mixed with few meat and some other stuffs to prepare this sweet delicious salmon meal. Eat and Enjoy!!',
    rating: 4.2,
    isDiscounted: false,
    isPopular: true,
  ),
  Product(
    discount: 10,
    title: "Tacos with vegetables ",
    foodType: 'Italian Cuisine',
    image: 'assets/images/foodiesfeed.com_tacos-with-pulled-pork-fresh-vegetables-and-cream.jpg',
    price: 5,
    description: 'Mixed with few meat and some other stuffs to prepare this sweet delicious salmon meal.bEat and Enjoy!!',
    ingredients: 'Mixed with few meat and some other stuffs to prepare this sweet delicious salmon meal. Eat and Enjoy!!',
    rating: 4.1,
    isDiscounted: true,
  ),
  Product(
    discount: 10,
    title: "Rice and Veg Sauce",
    foodType: 'Italian Cuisine',
    image: 'assets/images/foodiesfeed.com_tacos-with-pulled-pork-fresh-vegetables-and-cream.jpg',
    price: 5,
    description: 'Mixed with few meat and some other stuffs to prepare this sweet delicious salmon meal. Eat and Enjoy!!',
    ingredients: 'Mixed with few meat and some other stuffs to prepare this sweet delicious salmon meal. Eat and Enjoy!!',
    rating: 4.1,
    isDiscounted: true,
  ),
];
