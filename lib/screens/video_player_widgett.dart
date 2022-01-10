import 'package:sizer/sizer.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';

import '../main.dart';


class VideoWidgett extends StatefulWidget {

  final play;
  final url;

  const VideoWidgett({Key? key, this.url, this.play})
      : super(key: key);

  @override
  _VideoWidgettState createState() => _VideoWidgettState();
}


class _VideoWidgettState extends State<VideoWidgett> {
  late VideoPlayerController videoPlayerController ;
  late Future<void> _initializeVideoPlayerFuture;
  bool isplaying = false;
  @override
  void initState() {
    super.initState();

    videoPlayerController = new VideoPlayerController.network(widget.url);


    _initializeVideoPlayerFuture = videoPlayerController.initialize().then((_) {
      //       Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
      setState(() {

      });
    });
    videoPlayerController.addListener(checkVideo);
  } // This closing tag was missing

  @override
  void dispose() {
    videoPlayerController.dispose();
    //    widget.videoPlayerController.dispose();
    isPlaying1 = false;
    super.dispose();
  }

  void checkVideo(){
    // Implement your calls inside these conditions' bodies :
    if(videoPlayerController.value.position == Duration(seconds: 0, minutes: 0, hours: 0)) {
      print('video Started');
    }

    if(videoPlayerController.value.position == videoPlayerController.value.duration) {
      print('video Ended');
    }


    if(videoPlayerController.value.isPlaying){
      isplaying = true;
    }else{
      isplaying = false;
    }
    setState(() {

    });
  }


  @override
  Widget build(BuildContext context) {

    return FutureBuilder(
      future: _initializeVideoPlayerFuture,
      builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.done) {
        return MaterialApp(
          title: 'Video Player',
          debugShowCheckedModeBanner: false,
          home: Stack(
            children: [
              Center(
                child: Container(
                  color: Colors.black,
                  margin: EdgeInsets.symmetric(horizontal: 2.w),
                  child: videoPlayerController.value.isInitialized
                      ? AspectRatio(
                    aspectRatio: videoPlayerController.value.aspectRatio,
                    child: VideoPlayer(videoPlayerController),
                  )
                      : Container(),
                ),
              ),

              Center(
                child: InkWell(
                  onTap: () {
                    setState(() {
                      if(isplaying){
                        videoPlayerController.pause();
                        isplaying = false;
                        isPlaying2 = true;
                      }else{
                        videoPlayerController.play();
                        isplaying = true;
                        isPlaying2 = false;
                      }
                    });
                  },
                  child: Icon(
                    isplaying
                        ? Icons.pause
                        : Icons.play_arrow,
                    size: 40,
                    color: Colors.white,
                  ),
                ),
              ),

            ],
          ),
        );
      }else{
        return Center(
          child: CircularProgressIndicator(),);
      }
      }
    );
  }

}