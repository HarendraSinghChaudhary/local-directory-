import 'package:flutter/material.dart';
import 'package:rich_text_controller/rich_text_controller.dart';
import 'package:wemarkthespot/components/default_button.dart';

class ExampleRichText extends StatefulWidget {
  const ExampleRichText({Key? key}) : super(key: key);

  @override
  _ExampleRichTextState createState() => _ExampleRichTextState();
}

class _ExampleRichTextState extends State<ExampleRichText> {
  late RichTextController _controller ;

  @override
  void initState() {

    super.initState();

      _controller = RichTextController(
        patternMatchMap: {
          //
          //* Returns every Hashtag with red color
          //
          RegExp(r"\B#[a-zA-Z0-9]+\b"): TextStyle(color: Colors.red),
          //
          //* Returns every Mention with blue color and bold style.
          //
          RegExp(r"\B@[a-zA-Z0-9]+\b"): TextStyle(
            fontWeight: FontWeight.w800, color: Colors.blue,),
          //
          //* Returns every word after '!' with yellow color and italic style.
          //
          RegExp(r"\B@@[a-zA-Z0-9]+\b"): TextStyle(
              color: Colors.yellow, fontStyle: FontStyle.italic),
          // add as many expressions as you need!
        },
        //* starting v1.2.0
        // Now you have the option to add string Matching!
    /*    stringMatchMap: {
          "String1": TextStyle(color: Colors.red),
          "String2": TextStyle(color: Colors.yellow),
        },*/
        //! Assertion: Only one of the two matching options can be given at a time!

        //* starting v1.1.0
        //* Now you have an onMatch callback that gives you access to a List<String>
        //* which contains all matched strings
        onMatch: (List<String> matches) {

          // Do something with matches.
          //! P.S
          // as long as you're typing, the controller will keep updating the list.
        },
        deleteOnBack: true,

      );

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
        body: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 200,
            ),
            Center(
              child: Container(
                color: Colors.white,
                child: TextField(
                  style:
                  TextStyle(color: Colors.black, fontSize: 12),
                  decoration: InputDecoration(
                    hintText: "Typehere....."
                  ),

                  controller: _controller,
                ),
              ),
            ),
            Container(
              height: 20,
            ),

            DefaultButton(width: 100, height: 50, text: "Print", press: (){
              print(_controller.value.text);
            })
          ],
        ));
  }
}
