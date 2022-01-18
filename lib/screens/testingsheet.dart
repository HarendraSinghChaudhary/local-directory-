import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import 'package:video_player/video_player.dart';


class AApp extends StatefulWidget {
  @override
  State<AApp> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<AApp> {



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.blueGrey[100],
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Flutter Video Player Demo'),
        centerTitle: true,
      ),
      body: ListView(
        children: <Widget>[
        
          VideoItems(
            videoPlayerController: VideoPlayerController.network(
                'https://assets.mixkit.co/videos/preview/mixkit-a-girl-blowing-a-bubble-gum-at-an-amusement-park-1226-large.mp4'
            ),
        
          ),
       
         
          VideoItems(
            videoPlayerController: VideoPlayerController.network(
                "https://www.learningcontainer.com/wp-content/uploads/2020/05/sample-mp4-file.mp4"
            ),
          
          ),
        ],
      ),
    );
  }
}

class VideoItems extends StatefulWidget {
  final VideoPlayerController videoPlayerController;



VideoItems({
  required this.videoPlayerController,
  

});
 

  @override
  State<VideoItems> createState() => _VideoItemsState();
}

class _VideoItemsState extends State<VideoItems> {

  late ChewieController _chewieController;





  @override
void initState() {
  super.initState();
  _chewieController = ChewieController(
    videoPlayerController: widget.videoPlayerController,
    showOptions: true,
    showControlsOnInitialize: true,
    allowedScreenSleep: false,
    fullScreenByDefault: false,
    aspectRatio: widget.videoPlayerController.value.aspectRatio,
 
    
     
    autoInitialize: true,
    autoPlay: false,
    looping: false,
    
    errorBuilder: (context, errorMessage) {
      return Center(
        child: Text(
          errorMessage,
          style: TextStyle(color: Colors.white),
        ),
      );
    },
  );
}

@override
void dispose() {
  super.dispose();
  _chewieController.dispose();
}





  @override
  Widget build(BuildContext context) {
    return Container(
      
     
      // height: 30.h,
      width: double.infinity,
      child: Chewie(
        controller: _chewieController,
        
      ),
    );
  }
}