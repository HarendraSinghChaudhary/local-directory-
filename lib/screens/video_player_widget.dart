import 'package:sizer/sizer.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';


class VideoWidget extends StatefulWidget {

  final play;
  final url;

  const VideoWidget({Key? key, this.url, this.play})
      : super(key: key);

  @override
  _VideoWidgetState createState() => _VideoWidgetState();
}


class _VideoWidgetState extends State<VideoWidget> {
  late VideoPlayerController videoPlayerController ;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    videoPlayerController = new VideoPlayerController.network(widget.url);


    _initializeVideoPlayerFuture = videoPlayerController.initialize().then((_) {
      //       Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
      setState(() {});
    });
  } // This closing tag was missing

  @override
  void dispose() {
    videoPlayerController.dispose();
    //    widget.videoPlayerController.dispose();
    super.dispose();
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
                  margin: EdgeInsets.symmetric(horizontal: 1.w),
                  
                  
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
                  child: Visibility(
                    visible: true,
                    child: Icon(
                      videoPlayerController.value.isPlaying
                          ? Icons.pause
                          : Icons.play_arrow,
                      size: 40,
                      color: Colors.white,
                    ),
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