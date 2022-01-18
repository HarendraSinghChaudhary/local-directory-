import 'package:carousel_slider/carousel_slider.dart';

import 'package:flutter/material.dart';

class NewSliderClass extends StatefulWidget {

    final List items;

 NewSliderClass({required this.items});


 
  @override
  State<NewSliderClass> createState() => _NewSliderClassState();
}

class _NewSliderClassState extends State<NewSliderClass> {
    int currentIndex2 = 0;
  int index = 0;
  final CarouselController _controller = CarouselController();
  List<String> imgList = [
  'assets/one.png',
  'assets/two.png',
  'assets/three.png'
 ];
  @override
  Widget build(BuildContext context) {
    var getScreenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            //  height: 216,
            width: double.infinity,
            child: CarouselSlider.builder(
              //  carouselController: buttonCarouselController,
              carouselController: _controller,
              itemCount: widget.items.length,
              itemBuilder: (BuildContext context,
                  int itemIndex, int pageViewIndex) {
                print("Cur "+currentIndex2.toString()+"^^");
                return InteractiveViewer(
                  maxScale: 14,
                  minScale: 0.2,
                  child: FadeInImage(
                    image: NetworkImage(
                          widget.items.elementAt(itemIndex)),
                      placeholder: AssetImage("assets/images/Business.png"),
                      
                
                  ),
                );
              },
              options: CarouselOptions(
                height: getScreenHeight,
                  viewportFraction: 1.0,
                  autoPlay: true,
                  initialPage: 0,
                  onPageChanged: (index, reason) {
                    setState(() {
                      currentIndex2 = index;
                      print("${index}");
                    });
                  }),
            ),
          ),
          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Center(
              child: SizedBox(
                height: 30,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemCount: widget.items.length,
                    itemBuilder: (context, i) {
                      return Container(
                        width: 8.0,
                        height: 8.0,
                        margin: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 2.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: currentIndex2 == i
                              ? Colors.deepOrangeAccent
                              : Colors.white,
                        ),
                      );
                    }),
              ),
            )

          ),
          
          

        


        ],
      ),
    );
  }
}


