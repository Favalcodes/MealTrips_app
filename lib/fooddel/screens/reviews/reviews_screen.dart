import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mealtrips/constants.dart';
import 'package:mealtrips/fooddel/data/model/rating_model.dart';
import 'package:mealtrips/fooddel/data/repository/reviews_repo.dart';
import 'package:mealtrips/fooddel/screens/widgets/progress_widget.dart';
import 'package:mealtrips/size_config.dart';

class ReviewScreen extends StatefulWidget {
  final String itemId;
  final String screen;
  ReviewScreen(this.itemId, this.screen);
  @override
  _ReviewScreenState createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  List<RatingModel> reviews = [];
  ReviewsRepo itemsReviewsRepo = ReviewsRepo();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getReviews();
  }

  void getReviews() async {
    if (widget.screen == 'item') {
      reviews = await itemsReviewsRepo.getItemReviews(widget.itemId);
    } else {
      reviews = await itemsReviewsRepo.getResReviews(widget.itemId);
    }
    setState(() => reviews = reviews);
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Reviews',
          style: TextStyle(
            color: Theme.of(context).textSelectionColor,
            fontWeight: FontWeight.w400,
            fontSize: SizeConfig.screenWidth * 0.04,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: Theme.of(context).textSelectionColor),
      ),
      body: isLoading
          ? circularProgress()
          : SafeArea(
              child: Column(
                children: [
                  ...List.generate(reviews.length, (index) {
                    return ReviewScreenBox(
                      reviews: reviews[index],
                    );
                  })
                ],
              ),
            ),
    );
  }
}

class ReviewScreenBox extends StatelessWidget {
  const ReviewScreenBox({
    Key key,
    this.reviews,
  }) : super(key: key);

  final RatingModel reviews;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      child: Column(
        children: [
          Row(
            children: [
              Row(
                children: [
                  Container(
                    height: SizeConfig.screenWidth * 0.1,
                    width: SizeConfig.screenWidth * 0.1,
                    decoration: BoxDecoration(
                        border: Border.all(color: kPrimaryColor),
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: CachedNetworkImageProvider(
                                reviews.profileImage),
                            fit: BoxFit.cover)),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        reviews.username,
                        style: TextStyle(
                            fontSize: SizeConfig.screenWidth * 0.037,
                            fontWeight: FontWeight.w700,
                            color: Theme.of(context).textSelectionColor),
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.star,
                            size: getProportionateScreenWidth(16),
                            color: Color(0XFFFFC107),
                          ),
                          Text(
                            reviews.rating.toString(),
                            style: TextStyle(
                                fontSize: SizeConfig.screenWidth * 0.03,
                                fontWeight: FontWeight.w500,
                                color: Theme.of(context).hintColor),
                          ),
                        ],
                      )
                    ],
                  )
                ],
              ),
              Spacer(),
              Text(
                reviews.date,
                style: TextStyle(
                    fontSize: SizeConfig.screenWidth * 0.037,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).hintColor),
              ),
            ],
          ),
          SizedBox(
            height: SizeConfig.screenWidth * 0.02,
          ),
          Container(
            alignment: Alignment.centerLeft,
            width: MediaQuery.of(context).size.width,
            child: Row(
              children: [
                SizedBox(
                  width: 40,
                ),
                Container(
                  width: MediaQuery.of(context).size.width - 100,
               child: Text(
                 reviews.review,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).hintColor),
                ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
