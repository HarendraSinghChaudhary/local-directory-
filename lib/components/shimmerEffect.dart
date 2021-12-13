import 'package:flutter/material.dart';

import 'package:shimmer/shimmer.dart';
import 'package:sizer/sizer.dart';








class ShimmerEffect extends StatelessWidget {
  const ShimmerEffect({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     
      body: ListView(
      padding: const EdgeInsets.all(8.0),
      children: [


        SizedBox(height: 6.h),


        Shimmer.fromColors(
           enabled: true,
          baseColor: Colors.grey[400]!,
          highlightColor: Colors.grey[100]!,
        
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 4.w),
          height: 19.h,
           width: double.infinity,
          color: Colors.white,
        ),
        ),
        //const Divider(),

        SizedBox(height: 6.h,),


     
        Shimmer.fromColors(
           enabled: true,
          baseColor: Colors.grey[400]!,
          highlightColor: Colors.grey[100]!,
          child: ListView.separated(
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            
            itemCount: 4,
            itemBuilder: (_, __) => Padding(
              padding: EdgeInsets.only(bottom: 1.h),
              child: placeHolderRow(),
            ),
            separatorBuilder: (_, __) => const SizedBox(height: 2),
          ),
        ),
      ],
    ),
    );
    
  }

  // Some white boxes to indicate a placeholder for contents to come.
  // Copied from https://pub.dev/packages/shimmer/example
  Widget placeHolderRow() =>
      Row(crossAxisAlignment: CrossAxisAlignment.start, children: [



        





        Container(
          height: 14.h,
           width: 16.h,
          color: Colors.white,
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: double.infinity,
                height: 2.h,
                color: Colors.white,
              ),
               Padding(
                padding: EdgeInsets.symmetric(vertical: 0.8.h),
              ),
              Container(
                width: double.infinity,
                height: 1.h,
                color: Colors.white,
              ),
             Padding(
                padding: EdgeInsets.symmetric(vertical: 0.8.h),
              ),
              Container(
                width: 50.w,
                height: 1.h,
                color: Colors.white,
              ),

              Padding(
                padding: EdgeInsets.symmetric(vertical: 0.8.h),
              ),
              Container(
                width: 70.w,
                height: 1.h,
                color: Colors.white,
              ),
            ],
          ),
        )
      ]);
}


class ShimmerEffectHome extends StatelessWidget {
  const ShimmerEffectHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     
      body: ListView(
      padding: const EdgeInsets.all(8.0),
      children: [


        SizedBox(height: 3.h),


        Shimmer.fromColors(
           enabled: true,
          baseColor: Colors.grey[400]!,
          highlightColor: Colors.grey[100]!,
        
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 4.w),
          height: 3.h,
           width: double.infinity,
          color: Colors.white,
        ),
        ),
        //const Divider(),

        SizedBox(height: 3.h,),

        Shimmer.fromColors(
           enabled: true,
          baseColor: Colors.grey[400]!,
          highlightColor: Colors.grey[100]!,
        
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 4.w),
          height: 17.h,
           width: double.infinity,
          color: Colors.white,
        ),
        ),

        SizedBox(height: 4.h,),


        Shimmer.fromColors(
           enabled: true,
          baseColor: Colors.grey[400]!,
          highlightColor: Colors.grey[100]!,
        
          child: Container(
            margin: EdgeInsets.symmetric(horizontal:1.w),
          height: 3.h,
           width: double.infinity,
          color: Colors.white,
        ),
        ),

        SizedBox(height: 2.h,),

        // Shimmer.fromColors(
        //    enabled: true,
        //   baseColor: Colors.grey[400]!,
        //   highlightColor: Colors.grey[100]!,
        
        //   child: Container(
        //     margin: EdgeInsets.symmetric(horizontal:1.w),
        //   height: 1.h,
        //    width: double.infinity,
        //   color: Colors.white,
        // ),
        // ),




     
        Shimmer.fromColors(
           enabled: true,
          baseColor: Colors.grey[400]!,
          highlightColor: Colors.grey[100]!,
          child: ListView.separated(
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            
            itemCount: 2,
            itemBuilder: (_, __) => Padding(
              padding: EdgeInsets.only(bottom: 1.h),
              child: placeHolderRow(),
            ),
            separatorBuilder: (_, __) => const SizedBox(height: 2),
          ),

        
        ),

           SizedBox(height: 4.h,),


        Shimmer.fromColors(
           enabled: true,
          baseColor: Colors.grey[400]!,
          highlightColor: Colors.grey[100]!,
        
          child: Container(
            margin: EdgeInsets.symmetric(horizontal:1.w),
          height: 17.h,
           width: double.infinity,
          color: Colors.white,
        ),
        ),

         SizedBox(height: 2.h,),


        Shimmer.fromColors(
           enabled: true,
          baseColor: Colors.grey[400]!,
          highlightColor: Colors.grey[100]!,
        
          child: Container(
            margin: EdgeInsets.symmetric(horizontal:1.w),
          height: 17.h,
           width: double.infinity,
          color: Colors.white,
        ),
        ),
      ],
    ),
    );
    
  }

  // Some white boxes to indicate a placeholder for contents to come.
  // Copied from https://pub.dev/packages/shimmer/example
  Widget placeHolderRow() =>
      Row(crossAxisAlignment: CrossAxisAlignment.start, children: [



        





        
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Container(
              //   width: double.infinity,
              //   height: 2.h,
              //   color: Colors.white,
              // ),
               Padding(
                padding: EdgeInsets.symmetric(vertical: 0.8.h),
              ),
              Container(
                width: double.infinity,
                height: 1.h,
                color: Colors.white,
              ),
             Padding(
                padding: EdgeInsets.symmetric(vertical: 0.8.h),
              ),
              Container(
                width: 50.w,
                height: 1.h,
                color: Colors.white,
              ),

              Padding(
                padding: EdgeInsets.symmetric(vertical: 0.8.h),
              ),
              Container(
                width: 70.w,
                height: 1.h,
                color: Colors.white,
              ),
            ],
          ),
        )
      ]);


      
}



