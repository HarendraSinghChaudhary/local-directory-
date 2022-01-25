import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import 'package:video_player/video_player.dart';
import 'package:wemarkthespot/constant.dart';


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
        
        /*  VideoItems(
            videoPlayerController: VideoPlayerController.network(
                'https://assets.mixkit.co/videos/preview/mixkit-a-girl-blowing-a-bubble-gum-at-an-amusement-park-1226-large.mp4'
            ),
        
          ),
       
         
          VideoItems(
            videoPlayerController: VideoPlayerController.network(
                "https://www.learningcontainer.com/wp-content/uploads/2020/05/sample-mp4-file.mp4"
            ),
          
          ),*/
        ],
      ),
    );
  }
}

class VideoItemsss extends StatefulWidget {
  var videoPlayerController;



VideoItemsss({
  required this.videoPlayerController,
  

});
 

  @override
  State<VideoItemsss> createState() => _VideoItemsState();
}

class _VideoItemsState extends State<VideoItemsss> {

  late ChewieController _chewieController;
  late VideoPlayerController _videoPlayerController;

  late Future<void> _future;

    Future<void> initVideoPlayer() async {
    await _videoPlayerController.initialize();
    setState(() {
      print("true: "  +_videoPlayerController.value.aspectRatio.toString());
      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController,
        aspectRatio: _videoPlayerController.value.aspectRatio,
        autoPlay: false,
        looping: false,
        autoInitialize: true
      );
    });

    }





  @override
void initState() {
  super.initState();
  _videoPlayerController = VideoPlayerController.network(widget.videoPlayerController);

  _future = _videoPlayerController.initialize().then((_) {
    //       Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
    setState(() {
      _chewieController = ChewieController(
          videoPlayerController: _videoPlayerController,
          aspectRatio: _videoPlayerController.value.aspectRatio,
          autoPlay: false,
          looping: false,
          autoInitialize: true
      );
    });
  });
   // _future = initVideoPlayer();
  // _chewieController = ChewieController(
  //   videoPlayerController: widget.videoPlayerController,
    
  
    
  //   errorBuilder: (context, errorMessage) {
  //     return Center(
  //       child: Text(
  //         errorMessage,
  //         style: TextStyle(color: Colors.white),
  //       ),
  //     );
  //   },
  // );
}



 



@override
void dispose() {
  super.dispose();

  _videoPlayerController.dispose();

  _chewieController.dispose();
}



  @override
  Widget build(BuildContext context) {
    return new FutureBuilder(
      future: _future,
      builder: (context, snapshot) {
        return _videoPlayerController.value.isInitialized
        ? Container(
            width: double.infinity,
           
            child: Chewie(
              controller: _chewieController,
            ),
          ): Center(child: CircularProgressIndicator(color: kPrimaryColor,));
        
       
      }
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Container(
      
     
      
  //     child: Chewie(
  //       controller: _chewieController,
        
  //     ),
  //   );
  // }
}