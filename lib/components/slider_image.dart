import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:wemarkthespot/components/new_slider.dart';
import 'package:wemarkthespot/components/new_slider_widget.dart';
import 'package:wemarkthespot/screens/explore.dart';



class HotspotImageSlider extends StatefulWidget {

  final List items;

  HotspotImageSlider({required this.items});

  @override
  _CustomSliderWidgetState createState() => _CustomSliderWidgetState();
}

class _CustomSliderWidgetState extends State<HotspotImageSlider> {
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
      overflow: Overflow.visible,
      children: <Widget>[
        CarouselSlider(
          options: CarouselOptions(
            autoPlay: true,
            onPageChanged: (index, reason) {
              setActiveDot(index);
            },
            enableInfiniteScroll: false,
            autoPlayCurve: Curves.fastLinearToSlowEaseIn,
            autoPlayAnimationDuration: Duration(seconds: 2),
            // autoPlay: true,
            viewportFraction: 1.0,
          ),
          items: widget.items.map((i) {
            print("iisixisi "+i+"^");
            return Builder(
              builder: (BuildContext context) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => NewSliderClass(items: widget.items)));
                  },
                  child: Container(
                    height: 20.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3.w),
                      color: Colors.white,
                      image: DecorationImage(
                        image: NetworkImage(
                            i),
                        fit: BoxFit.cover,
                      ),
                    ),
                    // child: Image.asset(),
                  ),
                );
              },
            );
          }).toList(),
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