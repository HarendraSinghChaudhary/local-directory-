import 'dart:io';


import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_trimmer/video_trimmer.dart';
import 'package:wemarkthespot/main.dart';
import 'package:wemarkthespot/services/modelProvider.dart';

class ChilPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Upload Video"),
      ),
      body: Center(
        child: Container(
          child: ElevatedButton(
            child: Text("LOAD VIDEO"),
            onPressed: () async {
              FilePickerResult? result = await FilePicker.platform.pickFiles(
                type: FileType.video,
                allowCompression: false,
              );
              if (result != null) {
                File file = File(result.files.single.path!);
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) {
                    return TrimmerView(file);
                  }),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}

class TrimmerView extends StatefulWidget {
  File file;

  TrimmerView(this.file);

  @override
  _TrimmerViewState createState() => _TrimmerViewState();
}

class _TrimmerViewState extends State<TrimmerView> {
  final Trimmer _trimmer = Trimmer();

  double _startValue = 0.0;
  double _endValue = 0.0;

  bool _isPlaying = false;
  bool _progressVisibility = false;

  Future<String?> _saveVideo() async {
    setState(() {
      _progressVisibility = true;
    });

    String? _value;

    await _trimmer
        .saveTrimmedVideo(startValue: _startValue, endValue: _endValue, onSave: (String? outputPath) async {
          print("outputPathh: "+outputPath.toString());
          currentPath = outputPath.toString();

           _value = outputPath;

         });

    print("Pathh: "+widget.file.path.toString());
    Future.delayed(Duration(milliseconds: 100), () {
      if(_value!=null) {
        setState(()  {
          _progressVisibility = false;
          widget.file = File(_value.toString());
        });
        return _value;

      }
    });

  }

  void _loadVideo() {
    _trimmer.loadVideo(videoFile: widget.file);
  }

  @override
  void initState() {
    super.initState();

    _loadVideo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Video Trimmer"),
      ),
      body: Builder(
        builder: (context) => Center(
          child: Container(
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.black,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Visibility(
                  visible: _progressVisibility,
                  child: LinearProgressIndicator(
                    backgroundColor: Colors.red,
                  ),
                ),
                ElevatedButton(
                  onPressed: _progressVisibility
                      ? null
                      : () async {
                          await _saveVideo().then((outputPath) {
                            print('OUTPUT PATH: '+outputPath.toString());
                            popback(context);
                          });

                          /*   final snackBar = SnackBar(
                                content: Text('Video Saved successfully'));
                            ScaffoldMessenger.of(context).showSnackBar(
                              snackBar,
                            );*/




                        },
                  child: Text("SAVE"),
                ),
                Expanded(
                  child: VideoViewer(trimmer: _trimmer),
                ),
                Center(
                  child: TrimEditor(
                    trimmer: _trimmer,
                    viewerHeight: 50.0,
                    viewerWidth: MediaQuery.of(context).size.width,
                    maxVideoLength: Duration(seconds: 10),
                    onChangeStart: (value) {
                      _startValue = value;
                    },
                    onChangeEnd: (value) {
                      _endValue = value;
                    },
                    onChangePlaybackState: (value) {
                      setState(() {
                        _isPlaying = value;
                      });
                    },
                  ),
                ),
                TextButton(
                  child: _isPlaying
                      ? Icon(
                          Icons.pause,
                          size: 80.0,
                          color: Colors.white,
                        )
                      : Icon(
                          Icons.play_arrow,
                          size: 80.0,
                          color: Colors.white,
                        ),
                  onPressed: () async {
                    bool playbackState = await _trimmer.videPlaybackControl(
                      startValue: _startValue,
                      endValue: _endValue,
                    );
                    setState(() {
                      _isPlaying = playbackState;
                    });
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _trimmer.dispose();
    super.dispose();
  }
}

void popback(BuildContext context) {
  Future.delayed(Duration(milliseconds: 100), () {
    if(currentPath!=""){

      Navigator.of(context, rootNavigator: true).pop();
    }else{
      popback(context);
    }


  });

}