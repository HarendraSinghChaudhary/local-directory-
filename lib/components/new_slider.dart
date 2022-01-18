import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:wemarkthespot/screens/explore.dart';

class NewImageSlider extends StatefulWidget {
  final List items;

  NewImageSlider({required this.items});

  @override
  _CustomSliderWidgetState createState() => _CustomSliderWidgetState();
}

class _CustomSliderWidgetState extends State<NewImageSlider> {
  bool isloading = false;

  @override
  void initState() {
    super.initState();

    // featuredBusinessApi();
  }

  int activeIndex = 0;
  setActiveDot(index) {
    setState(() {
      activeIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          height: double.infinity,
          width: double.infinity,
          color: Colors.black,
          child: CarouselSlider(
            options: CarouselOptions(
             
             
             
              autoPlay: true,
              onPageChanged: (index, reason) {
                setActiveDot(index);
              },
              enableInfiniteScroll: false,
              autoPlayCurve: Curves.fastLinearToSlowEaseIn,
              autoPlayAnimationDuration: Duration(seconds: 2),
              // autoPlay: true,
              viewportFraction: 1,
            ),
            items: widget.items.map((i) {
              return Builder(
                builder: (BuildContext context) {
                  return InteractiveViewer(
                    child: Image.network(
                      i,  fit: BoxFit.fill,
                    ),
                  );
                },
              );
            }).toList(),
          ),
        ),
        Positioned(
          left: 20,
          right: 0,
          bottom: 20,
          child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(widget.items.length, (idx) {
                return activeIndex == idx ? ActiveDot() : InactiveDot();
              })),
        )
      ],
    );
  }
}
