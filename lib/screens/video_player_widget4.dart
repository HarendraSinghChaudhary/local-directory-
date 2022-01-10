import 'package:sizer/sizer.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';

import '../main.dart';


class VideoWidget4 extends StatefulWidget {

  final play;
  final url;

  const VideoWidget4({Key? key, this.url, this.play})
      : super(key: key);

  @override
  _VideoWidget4State createState() => _VideoWidget4State();
}


class _VideoWidget4State extends State<VideoWidget4> {
  late VideoPlayerController videoPlayerController ;
  late Future<void> _initializeVideoPlayerFuture;
  @override
  void initState() {
    super.initState();

    videoPlayerController = new VideoPlayerController.network(widget.url);

    _initializeVideoPlayerFuture = videoPlayerController.initialize().then((_) {
      //       Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
      setState(() {
        videoPlayerController.value.isPlaying
            ? videoPlayerController.pause()
            : videoPlayerController.play();
      });
    });
    videoPlayerController.addListener(() {checkVideo();});
  } // This closing tag was missing
  void checkVideo(){
    // Implement your calls inside these conditions' bodies :
    if(videoPlayerController.value.position == Duration(seconds: 0, minutes: 0, hours: 0)) {
      print('video Started');
    }

    if(videoPlayerController.value.position == videoPlayerController.value.duration) {
      print('video Ended');
    }

    setState(() {

    });
  }
  @override
  void dispose() {
    videoPlayerController.dispose();
    //    widget.videoPlayerController.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    if(videoPlayerController.value.isPlaying){

      isPlaying2= true;
    }else{
      isPlaying2 = false;
    }
    return FutureBuilder(
      future: _initializeVideoPlayerFuture,
      builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.done) {
        return MaterialApp(
          title: 'Video Demo',
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
                      videoPlayerController.value.isPlaying
                          ? videoPlayerController.pause()
                          : videoPlayerController.play();
                    });
                  },
                  child: Icon(
                    isPlaying2
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

  void checkisPlaying() {
    Future.delayed(Duration(seconds: 1), (){

    print("controllerplaying "+videoPlayerController.value.isPlaying.toString());
    print("isPlaying2 "+isPlaying2.toString());
    if(mounted) {
      setState(() {

      });
    }
    checkisPlaying();
    });
  }

}