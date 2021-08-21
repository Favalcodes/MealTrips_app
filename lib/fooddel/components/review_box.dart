import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mealtrips/fooddel/data/model/rating_model.dart';
import 'package:mealtrips/fooddel/data/repository/reviews_repo.dart';
import 'package:mealtrips/fooddel/screens/widgets/progress_widget.dart';
import 'package:mealtrips/size_config.dart';

class ReviewBox extends StatefulWidget {
  final String itemId;
  final String resId;
  final String screen;
  ReviewBox(this.itemId, this.resId, this.press, this.screen);
  final GestureTapCallback press;

  @override
  _ReviewBoxState createState() => _ReviewBoxState();
}

class _ReviewBoxState extends State<ReviewBox> {
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
    return isLoading
        ? circularProgress()
        : GestureDetector(
            onTap: widget.press,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(10)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          ...List.generate(5, (index) {
                            return Icon(
                              Icons.star,
                              color: Color(0XFFFFC107),
                            );
                          }),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            reviews.length > 1
                                ? '${reviews.length} Reviews'
                                : '${reviews.length} Review',
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: SizeConfig.screenWidth * 0.04,
                                color: Theme.of(context).textSelectionColor),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 15,
                          )
                        ],
                      )
                    ],
                  ),
                  Row(
                    children: [
                      ...List.generate(reviews.length > 4 ? 4 : reviews.length,
                          (index) {
                        return ReviewUserBox(
                          reviews: reviews[index],
                        );
                      }),
                    ],
                  )
                ],
              ),
            ),
          );
  }
}

class ReviewUserBox extends StatelessWidget {
  ReviewUserBox({this.reviews});

  final RatingModel reviews;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4),
      child: Container(
        height: getProportionateScreenWidth(35),
        width: getProportionateScreenWidth(35),
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Theme.of(context).hintColor),
            image: DecorationImage(
                image: CachedNetworkImageProvider(reviews.profileImage),
                fit: BoxFit.cover)),
      ),
    );
  }
}
