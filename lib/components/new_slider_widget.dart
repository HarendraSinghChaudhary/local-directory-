import 'package:carousel_slider/carousel_slider.dart';

import 'package:flutter/material.dart';

class NewSliderClass extends StatefulWidget {

    final List items;
    int index = 0;

 NewSliderClass({required this.items, required this.index});


 
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
  void initState() {
    currentIndex2 = widget.index;
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    var getScreenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(title: Text("Image Viewer"),),
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
                return FadeInImage(
                  image: NetworkImage(
                        widget.items.elementAt(itemIndex)),
                    placeholder: AssetImage("assets/images/Business.png"),


                );
              },
              options: CarouselOptions(
                height: getScreenHeight,
                  viewportFraction: 1.0,
                  autoPlay: true,
                  initialPage: currentIndex2,
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


