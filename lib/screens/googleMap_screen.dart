// ignore_for_file: unused_field

import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:wemarkthespot/constant.dart';
import 'package:wemarkthespot/screens/Filter_screen.dart';
import 'package:wemarkthespot/screens/detailBusiness.dart';
import 'package:wemarkthespot/screens/detailBusinessdynamic.dart';
import 'package:wemarkthespot/screens/explore.dart';
import 'package:wemarkthespot/screens/homenave.dart';
import 'package:wemarkthespot/screens/hotspot.dart';
import 'package:wemarkthespot/services/api_client.dart';
import 'dart:ui' as ui;
import "package:collection/collection.dart";
import 'package:supercharged/supercharged.dart';
import 'package:wemarkthespot/services/modelProvider.dart';

import '../models/body.dart';
import 'mainnnn.dart';

class GoogleMapScreen extends StatefulWidget {
  var list;
  var route;
  var business_type;
  var hablamos_espanol;
  var religious_spiritual;
  var current_promotion;


  GoogleMapScreen({Key? key, this.list, this.route, this.business_type, this.hablamos_espanol, this.religious_spiritual, this.current_promotion}) : super(key: key);
  @override
  _GoogleMapLocationTestingState createState() =>
      _GoogleMapLocationTestingState();
}

class _GoogleMapLocationTestingState extends State<GoogleMapScreen> {
  bool viewVisible = false;
  var check = "";
  var business_type;
  var hablamos_espanol;
  var religious_spiritual;
  var current_promotion;
  bool _hasBeenPressed = true;
  var ids = "";
  var id = "";
  var user_id = "";
  var fav = "";
  var business_name = "";
  var business_images = "";
  var distance = "";
  var ratting = "";
  var description = "";
  var business_category = "";
  var user_count = "";
  var review_count = "";
  var location = "";
  var category_name = "";
  var latlong_position = "";
  var lat1, long1;
  bool isCheckinClicked = false;
  var isFilter = false;
  var avgratting = "";
  var countUserreview = "";
  var firecount = 0;
  var okcount = 0;
  var notcool_count = 0;
  List<NearBy> selectedList = [];
  double? lat;
  double? long;
  var isImageloaded = false;
  List<NearBy> nearByRestaurantList = [];

  BitmapDescriptor? customIcon;
  BitmapDescriptor? fireIcon;
  BitmapDescriptor? okIcon;
  BitmapDescriptor? notcoolIcon;
  TextEditingController mesageTextController = new TextEditingController();
  String searchText = "";
  LatLng sourceLocation = LatLng(26.862471, 75.762413);
  bool isloading = false;
  Map map = new Map();
  final dataSet = [];
  Completer<GoogleMapController> _controllerGoogleMap = Completer();

  GoogleMapController? newGoogleMapController;
  late Position currentPosition;
  List<Marker> markers = [];
  bool visible = false;

  late BitmapDescriptor mapMarker;
  // late Position position;
  Timer? debounce;

  Future setCustomMarker() async {
  //  mapMarker = await BitmapDescriptor.fromAssetImage(ImageConfiguration(), "assets/images/fire.png");

    final Uint8List fireI =
        await getBytesFromAsset('assets/images/fire.png', 50);
    final Uint8List notcoolI =
        await getBytesFromAsset('assets/snow/snow.png', 50);
    final Uint8List okI =
        await getBytesFromAsset('assets/beckance/bakance.png', 50);
    final Uint8List placeholde =
        await getBytesFromAsset('assets/images/placeholder.png', 50);
    fireIcon = await BitmapDescriptor.fromBytes(fireI);
    notcoolIcon = await BitmapDescriptor.fromBytes(notcoolI);
    okIcon = await BitmapDescriptor.fromBytes(okI);
    customIcon = await BitmapDescriptor.fromBytes(placeholde);
    /*BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(1, 1)),
        'assets/images/fire.png')
        .then((d) {
      customIcon = d;
    });*/
    return true;
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }


  Future<Uint8List> getBytesFromCanvas(int customNum, int width, int height) async  {
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final Paint paint = Paint()..color = kPrimaryColor;
    final Radius radius = Radius.circular(width/2);

    canvas.drawRRect(
        RRect.fromRectAndCorners(
          Rect.fromLTWH(0.0, 0.0, width.toDouble(),  height.toDouble()),
          topLeft: radius,
          topRight: radius,
          bottomLeft: radius,
          bottomRight: radius,
        ),
        paint);

    TextPainter painter = TextPainter(textDirection: TextDirection.ltr);
    painter.text = TextSpan(
      text: customNum.toString(), // your custom number here
      style: TextStyle(fontSize: 25.0, color: Colors.white),
    );

    painter.layout();
    painter.paint(
        canvas,
        Offset((width * 0.5) - painter.width * 0.5,
            (height * .5) - painter.height * 0.5));
    final img = await pictureRecorder.endRecording().toImage(width, height);
    final data = await img.toByteData(format: ui.ImageByteFormat.png);
    return data!.buffer.asUint8List();
  }

  Future<Uint8List> getImagefromCanvas(int customNum, int width, int height) async  {
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final Paint paint = Paint()..color = kPrimaryColor;
    final Radius radius = Radius.circular(width/2);
    Image image = Image(image: AssetImage("assets/images/placeholder.png"));


 /*   canvas.drawRRect(
        RRect.fromRectAndCorners(
          Rect.fromLTWH(0.0, 0.0, width.toDouble(),  height.toDouble()),
          topLeft: radius,
          topRight: radius,
          bottomLeft: radius,
          bottomRight: radius,
        ),
        paint);*/
    Uint8List placeholde =
    await getBytesFromAsset('assets/images/location-pin.png', 45);
    ui.Image imagee = await loadImage(placeholde);
    canvas.drawImage(imagee, Offset((10),
        (8)), paint);
    TextPainter painter = TextPainter(textDirection: TextDirection.ltr);
    painter.text = TextSpan(
      text: customNum.toString(), // your custom number here
      style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold, color: Colors.white),
    );

    painter.layout();


    painter.paint(
        canvas,
        Offset((width * 0.5) - painter.width * 0.55,
            (height * .4) - painter.height * 0.5));
    final img = await pictureRecorder.endRecording().toImage(width, height);
    final data = await img.toByteData(format: ui.ImageByteFormat.png);
    return data!.buffer.asUint8List();
  }

  Future<ui.Image> loadImage(Uint8List img) async {
    final Completer<ui.Image> completer = new Completer();
    ui.decodeImageFromList(img, (ui.Image img) {
      setState(() {
        isImageloaded = true;
      });
      return completer.complete(img);
    });
    return completer.future;
  }

  initilize(List<NearBy> businessList) async {
    print("into the initalizer method");
    print("businessLength " + businessList.length.toString() + "");
    try{


    for (final business in businessList) {
      var length = map[business.lat].length;
      if(business.lat.toString()!="null") {
        if (map[business.lat].length > 1) {
          print("Lengthhhh " + map[business.lat].length.toString() + "^^");


          Uint8List markerIcon = await getImagefromCanvas(length, 70, 70);

          if (business.lat != null && business.long != null) {
            if (business.lat.toString() != "null" &&
                business.long.toString() != "null") {
              if (business.firecount == 0 &&
                  business.okcount == 0 &&
                  business.notcool_count == 0) {
                Marker firstMarker = Marker(
                    onTap: () {
                      setState(() {
                        viewVisible = true;
                        business_name = business.business_name.toString();
                        avgratting = business.avgratting.toString();
                        firecount = business.firecount;
                        notcool_count = business.notcool_count;
                        user_count = business.user_count.toString();
                        review_count = business.totalReviewusers.toString();
                        business_images = business.business_images.toString();
                        id = business.id.toString();
                        lat1 = double.parse(business.lat);
                        long1 = double.parse(business.long);
                        okcount = business.okcount;
                        print("okok: " + okcount.toString());
                        selectedList.clear();
                        for (var k in map[business.lat]) {
                          NearBy nearBy = NearBy();
                          nearBy = NearBy.fromJson(k);
                          selectedList.add(nearBy);
                        }
                      });
                    },
                    markerId: MarkerId(business.id),
                    position: LatLng(
                        double.parse(business.lat),
                        double.parse(business.long)),
                    infoWindow: InfoWindow(
                      title: business_name = business.business_name.toString(),
                    ),
                    /* icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueRed),*/
                    icon: BitmapDescriptor.fromBytes(markerIcon));

                markers.add(firstMarker);
              } else {
                Marker firstMarker = Marker(
                    onTap: () {
                      setState(() {
                        viewVisible = true;
                        business_name = business.business_name.toString();
                        avgratting = business.avgratting.toString();
                        firecount = business.firecount;
                        notcool_count = business.notcool_count;
                        user_count = business.user_count.toString();
                        review_count = business.totalReviewusers.toString();
                        business_images = business.business_images.toString();
                        id = business.id.toString();
                        lat1 = double.parse(business.lat);
                        long1 = double.parse(business.long);
                        okcount = business.okcount;
                        print("okok: " + okcount.toString());
                        selectedList.clear();
                        for (var k in map[business.lat]) {
                          NearBy nearBy = NearBy();
                          nearBy = NearBy.fromJson(k);
                          selectedList.add(nearBy);
                        }
                        print(selectedList.length);
                      });
                    },
                    markerId: MarkerId(business.id),
                    position: LatLng(
                        double.parse(business.lat),
                        double.parse(business.long)),
                    infoWindow: InfoWindow(
                      title: business_name = business.business_name.toString(),
                    ),
                    /* icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueRed),*/
                    icon: BitmapDescriptor.fromBytes(markerIcon));

                markers.add(firstMarker);
              }
              print("markerslength: " + markers.length.toString());
              print("business_lat: " + business.lat.toString());
            }
          }
        } else {
          if (business.lat != null && business.long != null) {
            if (business.lat.toString() != "null" &&
                business.long.toString() != "null") {
              if (business.firecount == 0 &&
                  business.okcount == 0 &&
                  business.notcool_count == 0) {
                Marker firstMarker = Marker(
                    onTap: () {
                      setState(() {
                        viewVisible = true;
                        business_name = business.business_name.toString();
                        avgratting = business.avgratting.toString();
                        firecount = business.firecount;
                        notcool_count = business.notcool_count;
                        user_count = business.user_count.toString();
                        review_count = business.totalReviewusers.toString();
                        business_images = business.business_images.toString();
                        id = business.id.toString();
                        lat1 = double.parse(business.lat);
                        long1 = double.parse(business.long);
                        okcount = business.okcount;
                        print("okok: " + okcount.toString());
                        selectedList.clear();
                        for (var k in map[business.lat]) {
                          NearBy nearBy = NearBy();
                          nearBy = NearBy.fromJson(k);
                          selectedList.add(nearBy);
                        }
                        print(selectedList.length);
                      });
                    },
                    markerId: MarkerId(business.id),
                    position: LatLng(
                        double.parse(business.lat),
                        double.parse(business.long)),
                    infoWindow: InfoWindow(
                      title: business_name = business.business_name.toString(),
                    ),
                    /* icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueRed),*/
                    icon: customIcon!);

                markers.add(firstMarker);
              } else {
                Marker firstMarker = Marker(
                    onTap: () {
                      setState(() {
                        viewVisible = true;
                        business_name = business.business_name.toString();
                        avgratting = business.avgratting.toString();
                        firecount = business.firecount;
                        notcool_count = business.notcool_count;
                        user_count = business.user_count.toString();
                        review_count = business.totalReviewusers.toString();
                        business_images = business.business_images.toString();
                        id = business.id.toString();
                        lat1 = double.parse(business.lat);
                        long1 = double.parse(business.long);
                        okcount = business.okcount;
                        selectedList.clear();
                        for (var k in map[business.lat]) {
                          NearBy nearBy = NearBy();
                          nearBy = NearBy.fromJson(k);
                          selectedList.add(nearBy);
                        }
                        print(selectedList.length);
                        print("okok: " + okcount.toString());
                      });
                    },
                    markerId: MarkerId(business.id),
                    position: LatLng(
                        double.parse(business.lat),
                        double.parse(business.long)),
                    infoWindow: InfoWindow(
                      title: business_name = business.business_name.toString(),
                    ),
                    /* icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueRed),*/
                    icon: business.firecount > business.okcount
                        ? business.firecount > business.notcool_count
                        ? fireIcon!
                        : notcoolIcon!
                        : business.okcount > business.notcool_count
                        ? okIcon!
                        : notcoolIcon!);

                markers.add(firstMarker);
              }
              print("markerslength: " + markers.length.toString());
              print("business_latttt: " + lat1.toString());
              lat1 = double.parse(business.lat.toString());
              long1 = double.parse(business.long.toString());
            }
          }
        }
      }
    }
    }catch(error){
      print("Error "+error.toString()+"");
    }
    print("Running Animation BEfore "+lat1.toString()+"^^");
    if (lat1.toString() != "null" && long1.toString()!="null") {
      print("Running Animation "+lat1.toString()+"^^");
      LatLng latLngPosition = LatLng(lat1, long1);
      print("lat1: " + lat1.toString());
      print("long2 " + long1.toString());

      CameraPosition cameraPosition =
          new CameraPosition(target: latLngPosition, zoom: 12);
      newGoogleMapController!
          .animateCamera(CameraUpdate.newCameraPosition(cameraPosition)).then((value) {
            print("Completed");
      });
      print("Running Animation");
    }
    /* if(isFilter) {
      setState(() {
        viewVisible = true;
      });
    }*/
  }

  initilize2(List<NearBy> businessList) async {
    print("into the initalizer method");
    print("businessLength " + businessList.length.toString() + "");
    try{


      for (final business in businessList) {
        var length = map[business.lat].length;
        if(business.lat.toString()!="null") {
          if (map[business.lat].length > 1) {
            print("Lengthhhh " + map[business.lat].length.toString() + "^^");


            Uint8List markerIcon = await getImagefromCanvas(length, 70, 70);

            if (business.lat != null && business.long != null) {
              if (business.lat.toString() != "null" &&
                  business.long.toString() != "null") {
                if (business.firecount == 0 &&
                    business.okcount == 0 &&
                    business.notcool_count == 0) {
                  Marker firstMarker = Marker(
                      onTap: () {
                        setState(() {
                          viewVisible = true;
                          business_name = business.business_name.toString();
                          avgratting = business.avgratting.toString();
                          firecount = business.firecount;
                          notcool_count = business.notcool_count;
                          user_count = business.user_count.toString();
                          review_count = business.totalReviewusers.toString();
                          business_images = business.business_images.toString();
                          id = business.id.toString();
                          lat1 = double.parse(business.lat);
                          long1 = double.parse(business.long);
                          okcount = business.okcount;
                          print("okok: " + okcount.toString());
                          selectedList.clear();
                          for (var k in map[business.lat]) {
                            NearBy nearBy = NearBy();
                            nearBy = NearBy.fromJson(k);
                            selectedList.add(nearBy);
                          }
                        });
                      },
                      markerId: MarkerId(business.id),
                      position: LatLng(
                          double.parse(business.lat),
                          double.parse(business.long)),
                      infoWindow: InfoWindow(
                        title: business_name = business.business_name.toString(),
                      ),
                      /* icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueRed),*/
                      icon: BitmapDescriptor.fromBytes(markerIcon));

                  markers.add(firstMarker);
                } else {
                  Marker firstMarker = Marker(
                      onTap: () {
                        setState(() {
                          viewVisible = true;
                          business_name = business.business_name.toString();
                          avgratting = business.avgratting.toString();
                          firecount = business.firecount;
                          notcool_count = business.notcool_count;
                          user_count = business.user_count.toString();
                          review_count = business.totalReviewusers.toString();
                          business_images = business.business_images.toString();
                          id = business.id.toString();
                          lat1 = double.parse(business.lat);
                          long1 = double.parse(business.long);
                          okcount = business.okcount;
                          print("okok: " + okcount.toString());
                          selectedList.clear();
                          for (var k in map[business.lat]) {
                            NearBy nearBy = NearBy();
                            nearBy = NearBy.fromJson(k);
                            selectedList.add(nearBy);
                          }
                          print(selectedList.length);
                        });
                      },
                      markerId: MarkerId(business.id),
                      position: LatLng(
                          double.parse(business.lat),
                          double.parse(business.long)),
                      infoWindow: InfoWindow(
                        title: business_name = business.business_name.toString(),
                      ),
                      /* icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueRed),*/
                      icon: BitmapDescriptor.fromBytes(markerIcon));

                  markers.add(firstMarker);
                }
                print("markerslength: " + markers.length.toString());
                print("business_lat: " + business.lat.toString());
              }
            }
          } else {
            if (business.lat != null && business.long != null) {
              if (business.lat.toString() != "null" &&
                  business.long.toString() != "null") {
                if (business.firecount == 0 &&
                    business.okcount == 0 &&
                    business.notcool_count == 0) {
                  Marker firstMarker = Marker(
                      onTap: () {
                        setState(() {
                          viewVisible = true;
                          business_name = business.business_name.toString();
                          avgratting = business.avgratting.toString();
                          firecount = business.firecount;
                          notcool_count = business.notcool_count;
                          user_count = business.user_count.toString();
                          review_count = business.totalReviewusers.toString();
                          business_images = business.business_images.toString();
                          id = business.id.toString();
                          lat1 = double.parse(business.lat);
                          long1 = double.parse(business.long);
                          okcount = business.okcount;
                          print("okok: " + okcount.toString());
                          selectedList.clear();
                          for (var k in map[business.lat]) {
                            NearBy nearBy = NearBy();
                            nearBy = NearBy.fromJson(k);
                            selectedList.add(nearBy);
                          }
                          print(selectedList.length);
                        });
                      },
                      markerId: MarkerId(business.id),
                      position: LatLng(
                          double.parse(business.lat),
                          double.parse(business.long)),
                      infoWindow: InfoWindow(
                        title: business_name = business.business_name.toString(),
                      ),
                      /* icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueRed),*/
                      icon: customIcon!);

                  markers.add(firstMarker);
                } else {
                  Marker firstMarker = Marker(
                      onTap: () {
                        setState(() {
                          viewVisible = true;
                          business_name = business.business_name.toString();
                          avgratting = business.avgratting.toString();
                          firecount = business.firecount;
                          notcool_count = business.notcool_count;
                          user_count = business.user_count.toString();
                          review_count = business.totalReviewusers.toString();
                          business_images = business.business_images.toString();
                          id = business.id.toString();
                          lat1 = double.parse(business.lat);
                          long1 = double.parse(business.long);
                          okcount = business.okcount;
                          selectedList.clear();
                          for (var k in map[business.lat]) {
                            NearBy nearBy = NearBy();
                            nearBy = NearBy.fromJson(k);
                            selectedList.add(nearBy);
                          }
                          print(selectedList.length);
                          print("okok: " + okcount.toString());
                        });
                      },
                      markerId: MarkerId(business.id),
                      position: LatLng(
                          double.parse(business.lat),
                          double.parse(business.long)),
                      infoWindow: InfoWindow(
                        title: business_name = business.business_name.toString(),
                      ),
                      /* icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueRed),*/
                      icon: business.firecount > business.okcount
                          ? business.firecount > business.notcool_count
                          ? fireIcon!
                          : notcoolIcon!
                          : business.okcount > business.notcool_count
                          ? okIcon!
                          : notcoolIcon!);

                  markers.add(firstMarker);
                }
                print("markerslength: " + markers.length.toString());
                print("business_latttt: " + lat1.toString());
                lat1 = double.parse(business.lat.toString());
                long1 = double.parse(business.long.toString());
              }
            }
          }
        }
      }
    }catch(error){
      print("Error "+error.toString()+"");
    }
    print("Running Animation BEfore "+lat1.toString()+"^^");

  }
  @override
  void initState() {
    super.initState();
    setCustomMarker();
    print(widget.route.toString() + "**");
    this.mesageTextController.addListener(_onSearchChanged);
    if (widget.route.toString() == "home") {
      print("RunHomeRoute");
      WidgetsBinding.instance.addPostFrameCallback((_) {
        locatePosition();
      });

      nearBy();
      initilize(nearByRestaurantList);
    } else {
      if (widget.list != null) {
        if (widget.list.length.toString() == "0") {
          locatePosition();
          nearBy();
          initilize(nearByRestaurantList);
        } else {
          // locatePosition();
        
          filterData(context, widget.list, widget.business_type, widget.hablamos_espanol, widget.religious_spiritual, widget.current_promotion);
          isFilter = true;
        }
      } else {
        locatePosition();
        nearBy();
        initilize(nearByRestaurantList);
      }
    }
  }

  @override
  void dispose() {
    newGoogleMapController!.dispose();
    this.mesageTextController.removeListener(_onSearchChanged);
    this.mesageTextController.dispose();
    debounce?.cancel();

    super.dispose();
  }

  void locatePosition() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    currentPosition = position;

    LatLng latLngPosition = LatLng(position.latitude, position.longitude);
    print("lat: " + position.latitude.toString());
    print("long " + position.longitude.toString());

    CameraPosition cameraPosition =
        new CameraPosition(target: latLngPosition, zoom: 12);
    if(newGoogleMapController!=null) {
      newGoogleMapController!
          .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    }
  }

  static final CameraPosition _currentPosition =
      CameraPosition(target: LatLng(26.862471, 75.762413), zoom: 12);

  void updateUI(){
    setState(() {
      visible = false;
      FocusScope.of(context).unfocus();
      searchData(mesageTextController.text);
    });
}
  @override
  Widget build(BuildContext context) {
   business_type = '${context.watch<Counter>().isOnline}';
    hablamos_espanol = '${context.watch<Counter>().isHablamos}';
    religious_spiritual = '${context.watch<Counter>().isReligious}';
    current_promotion = '${context.watch<Counter>().isCurrent}';


    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading:  Padding(
          padding: const EdgeInsets.all(12.0),
          child: InkWell(
                onTap: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => HomeNav(index:3)));
                },
                child: SvgPicture.asset(
                  "assets/icons/explore.svg",
                  width: 10,
                  color: Colors.white,
                ),
              ),
        ),
        title:   Text(
              "MAP",
       style: TextStyle(fontFamily: 'Segoepr', fontWeight: FontWeight.w600),
            ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 3.w),
            child: InkWell(
              onTap: () {
                debounce?.cancel();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => FliterScreen(list: widget.list)));
              },
              child: SvgPicture.asset(
                "assets/icons/filter-list.svg",
                width: 26,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            GoogleMap(
              onTap: (latLong) {
                setState(() {
                  viewVisible = false;
                  visible = false;
                });
              },
              initialCameraPosition: _currentPosition,
              myLocationEnabled: true,
              zoomControlsEnabled: true,
              zoomGesturesEnabled: true,
              mapType: MapType.normal,
              onMapCreated: (GoogleMapController controller) {
                _controllerGoogleMap.complete(controller);
                newGoogleMapController = controller;

                //locatePosition();
                setState(() {});
              },
              markers: markers.map((e) => e).toSet(),
            ),
            Padding(
              padding: EdgeInsets.only( top: 8, left: 10,right: 50 ),
              child: ListView(
                shrinkWrap: true,

                children: [
                  Container(
                    height: 6.h,
                    margin: EdgeInsets.only(top: 3, left: 5, right: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.w),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black54,
                            offset: Offset(2, 3),
                            blurRadius: 10,
                            spreadRadius: 1)
                      ],
                    ),
                    child: TextFormField(
                      controller: mesageTextController,
                      onChanged: (value) {
                        if (value.length == 0) {
                          nearBy();
                        }
                      },
                      validator: (val) {},
                      onEditingComplete:updateUI,
                      style: TextStyle(
                          color: kPrimaryColor,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w700),
                      decoration: InputDecoration(
                        suffixIconConstraints: BoxConstraints(minWidth: 50),
                        prefixIconConstraints: BoxConstraints(minWidth: 50),
                        contentPadding: EdgeInsets.only(top: 0),
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        hintText: "Search",
                        hintStyle: TextStyle(
                            color: kPrimaryColor,
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w700),
                        suffixIcon: InkWell(
                          onTap: () {
                            mesageTextController.clear();
                            nearByRestaurantList.clear();
                            markers.clear();

                            // getHostSpotList.clear();

                            // getHotspotApi();
                          },
                          child: SvgPicture.asset(
                            "assets/icons/cross.svg",
                            width: 15,
                            color: kPrimaryColor,
                          ),

                          // child: SearchPrefixIcon(svgIcon: "assets/icons/cross.svg")
                        ),
                        prefixIcon: SvgPicture.asset(
                          "assets/icons/-search.svg",
                          width: 20,
                          color: kPrimaryColor,
                        ),
                      ),
                    ),
                  ),

                  mesageTextController.text.length>0? buildSuggestions(context)
                      :Container(height: 0,)
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndDocked,
      floatingActionButton: Visibility(
        visible: viewVisible,
        child: Padding(
          // padding: EdgeInsets.only(top: 57.2.h, left: 13.5.w),
          padding: EdgeInsets.only(left: 14.w,bottom: 7.h, right: 6.w),
          child: Container(
            height: 170,
            child: ListView.builder(
                itemCount: selectedList.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (con, i) {

             return Padding(
               padding: const EdgeInsets.all(8.0),
               child: InkWell(
                  onTap: () {

            // Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //         builder: (context) =>
            //             DetailBussinessDynamic(id: id)));

        },
            child: Container(
                height: 20.h,
                width: 70.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3.w),
                  color: kBackgroundColor,
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 14),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: () {
                              if (user_id == "72") {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    content: Text(
                                        "Please login or signup first to checkin at business")));
                              } else {
                                if (isCheckinClicked == false) {
                                  setState(() {
                                    isCheckinClicked = true;
                                  });
                                  checkInApi(id, "fire");
                                }
                              }
                            },
                            child: Container(
                              child: Column(
                                children: [
                                  SvgPicture.asset("assets/icons/file.svg",
                                      color: kPrimaryColor, width: 5.w),
                                  SizedBox(
                                    height: 0.6.h,
                                  ),
                                  Text(
                                    "Fire(" + selectedList[i].firecount.toString() + ")",
                                    style: TextStyle(
                                      fontSize: 10.sp,
                                      color: Colors.white,

                                      //fontFamily: "Roboto"
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              if (user_id == "72") {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    content: Text(
                                        "Please login or signup first to checkin at business")));
                              } else {
                                if (isCheckinClicked == false) {
                                  setState(() {
                                    isCheckinClicked = true;
                                  });
                                  checkInApi(id, "OkOk");
                                }
                              }
                            },
                            child: Container(
                              child: Column(
                                children: [
                                  SvgPicture.asset("assets/icons/bakance.svg",
                                      color: kokokColor, width: 10.w),
                                  Text(
                                    "Ok Ok(" + selectedList[i].okcount.toString() + ")",
                                    style: TextStyle(
                                      fontSize: 10.sp,
                                      color: Colors.white,

                                      //fontFamily: "Roboto"
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              if (user_id == "72") {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    content: Text(
                                        "Please login or signup first to checkin at business")));
                              } else {
                                if (isCheckinClicked == false) {
                                  setState(() {
                                    isCheckinClicked = true;
                                  });
                                  checkInApi(id, "Not Cool");
                                }
                              }
                            },
                            child: Container(
                              child: Column(
                                children: [
                                  SvgPicture.asset("assets/icons/snow.svg",
                                      color: kNotCoolColor, width: 8.w),
                                  Text(
                                    "Not Cool(" + selectedList[i].notcool_count.toString() + ")",
                                    style: TextStyle(
                                      fontSize: 10.sp,
                                      color: Colors.white,

                                      //fontFamily: "Roboto"
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SvgPicture.asset("assets/icons/star.svg",
                                    color: kPrimaryColor, width: 6.w),
                                SizedBox(
                                  height: 1.h,
                                ),
                                Text(
                                  //"3.5",
                                  selectedList[i].avgratting.toString(),
                                  style: TextStyle(
                                    fontSize: 11.sp,
                                    color: Colors.white,

                                    //fontFamily: "Roboto"
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        if (user_id == "72") {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                  "Please login or signup first to view business profile")));
                        } else {

                          NotificationModel model = NotificationModel();
                          model.review_id = selectedList[i].id.toString();
                          model.reply_id = "";
                          model.type = "business";

                          Navigator.pushNamed(context, "/detailedbusiness", arguments: model);
                        }
                      },
                      child: Padding(
                        padding: EdgeInsets.only(top: 1.h, left: 3.5.w),
                        child: Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                height: 16.w,
                                width: 18.w,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(3.w),
                                    color: Colors.red,
                                    image: DecorationImage(image: NetworkImage(
                                      //"assets/images/restaurant.jpeg"
                                        selectedList[i].business_images), fit: BoxFit.fill)),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 8.0, bottom: 10),
                                child: Column(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 45.w,
                                      child: Text(
                                        //"Bar Name",
                                        selectedList[i].business_name.toString(),
                                        // widget.nearBy.business_name.toString() != "null"
                                        //     ? widget.nearBy.business_name.toString()
                                        //     : "Bar Name",
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontSize: 13.sp,
                                            color: kCyanColor,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: "Segoepr"),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 0.5.h,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          // communityReviewList != null &&
                                          //         communityReviewList.length > 0
                                          //     ? communityReviewList.length.toString() +
                                          //         " Reviews "
                                          selectedList[i].totalReviewusers.toString() + " Reviews",
                                          style: TextStyle(
                                              fontSize: 10.sp,
                                              color: kPrimaryColor,
                                              // fontWeight: FontWeight.w500,
                                              fontFamily: "Roboto"
                                            //fontFamily: "Segoepr"
                                          ),
                                        ),
                                        Text(
                                          " | ",
                                          style: TextStyle(
                                              fontSize: 10.sp,
                                              color: kPrimaryColor,
                                              // fontWeight: FontWeight.w500,
                                              fontFamily: "Roboto"
                                            //fontFamily: "Segoepr"
                                          ),
                                        ),
                                        Text(
                                          // widget.nearBy.user_count.toString() +
                                          selectedList[i].user_count.toString() + " People",
                                          style: TextStyle(
                                              fontSize: 10.sp,
                                              color: kPrimaryColor,
                                              // fontWeight: FontWeight.w500,
                                              fontFamily: "Roboto"
                                            //fontFamily: "Segoepr"
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
            ),
        ),
             );}),
          )
        ),
      ),
    );
  }

  List<String> _oldFilters = [];
  OnSearchChanged? onSearchChanged;
  Widget buildSuggestions(BuildContext context) {
    return Visibility(
      visible: _oldFilters.length>0?visible:false,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8.w),
        color:Colors.white,height: 300,
        child: ListView.builder(
          itemCount: _oldFilters.length,
          itemBuilder: (context, index) {
            return ListTile(
              leading: Icon(Icons.restore),
              title: Text("${_oldFilters[index]}"),
              onTap: () {
                setState(() {
                  mesageTextController.text = _oldFilters[index].toString();
                  mesageTextController.selection = TextSelection.fromPosition(TextPosition(offset: mesageTextController.text.length));

                  Future.delayed(const Duration(seconds: 1), () {



                    setState(() {
                      visible = false;
                      FocusScope.of(context).unfocus();
                    });

                  });


                  //searchData(_oldFilters[index].toString());
                });
              },
            );
          },
        ),
      ),
    );
  }

  Future<List<String>> _getRecentSearchesLike(String query) async {
    _oldFilters.clear();
    final pref = await SharedPreferences.getInstance();
    final allSearches = pref.getStringList("recentSearches");
   var list = allSearches!.where((search) => search.startsWith(query)).toList();

   if(list.length>0){
     _oldFilters.addAll(list);
     setState(() {
       visible = true;

     });

   }
    return list;
  }

  Future<void> _saveToRecentSearches(String searchText) async {
    if (searchText == null) return; //Should not be null
    final pref = await SharedPreferences.getInstance();

    //Use `Set` to avoid duplication of recentSearches
    Set<String> allSearches =
        pref.getStringList("recentSearches")?.toSet() ?? {};
/*    if(allSearches.length>4){
      allSearches.remove(allSearches.last);
    }*/

    //Place it at first in the set
    allSearches = {searchText, ...allSearches};
    pref.setStringList("recentSearches", allSearches.toList());
  }
  _onSearchChanged() {
    if (debounce?.isActive ?? false) debounce?.cancel();

    debounce = Timer(const Duration(milliseconds: 500), () {
      if (mesageTextController.text.toString().length == 0) {
        nearBy();
      } else if (searchText != mesageTextController.text) {
        _getRecentSearchesLike(mesageTextController.text);
        searchData(mesageTextController.text);

      }
    });
  }

  Future<dynamic> searchData(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getString("id");
    print("id Print: " + id.toString());
    print("key Print: " + key.toString());

    var request = http.post(
        Uri.parse(RestDatasource.SEARCHMAP_URL
            // RestDatasource.SEND_OTP,
            ),
        body: {
          "business_name": key.toString(),
          "user_id": id.toString(),
        });

    var jsonArray;
    var jsonRes;
    var res;
    await request.then((http.Response response) {
      res = response;
      final JsonDecoder _decoder = new JsonDecoder();
      jsonRes = _decoder.convert(response.body.toString());
      print("ResponseSearch: " + response.body.toString() + "_");
      print("ResponseJSON Search: " + jsonRes.toString() + "_");
      jsonArray = jsonRes['data'];
    });
    if(mesageTextController.text.length>0) {
      await _saveToRecentSearches(mesageTextController.text);
    }
    if (res!.statusCode == 200) {
      setState(() {
        viewVisible = false;
      });
      if (jsonRes["status"] == true) {
        nearByRestaurantList.clear();
        markers.clear();
        for (var i = 0; i < jsonArray.length; i++) {
          if(jsonArray[i]["lat"].toString()!="null") {
            NearBy modelAgentSearch = new NearBy();
            modelAgentSearch.id = jsonArray[i]["id"].toString();
            modelAgentSearch.business_name =
                jsonArray[i]["business_name"].toString();
            modelAgentSearch.business_images =
                jsonArray[i]["business_images"].toString();
            modelAgentSearch.distance = jsonArray[i]["distance"].toString();
            modelAgentSearch.ratting = jsonArray[i]["ratting"].toString();
            modelAgentSearch.description =
                jsonArray[i]["description"].toString();
            modelAgentSearch.business_category =
                jsonArray[i]["business_category "].toString();
            modelAgentSearch.user_count = jsonArray[i]["user_count"].toString();
            modelAgentSearch.review_count =
                jsonArray[i]["review_count"].toString();
            modelAgentSearch.location = jsonArray[i]["location"].toString();
            modelAgentSearch.category_name =
                jsonArray[i]["category_name"].toString();
            modelAgentSearch.fav = jsonArray[i]["fav"].toString();
            modelAgentSearch.lat = jsonArray[i]["lat"].toString() == "null"|| jsonArray[i]["lat"].toString() == ""? "0.0": jsonArray[i]["lat"].toString();
            modelAgentSearch.long = jsonArray[i]["long"].toString() == "null" || jsonArray[i]["lat"].toString() == ""? "0.0": jsonArray[i]["long"].toString();
            modelAgentSearch.firecount = jsonArray[i]["firecount"];
            modelAgentSearch.notcool_count = jsonArray[i]["notcool_count"];
            modelAgentSearch.okcount = jsonArray[i]["okcount"];
            print("lat: " + modelAgentSearch.lat.toString());
            modelAgentSearch.totalReviewusers =
                jsonArray[i]["totalReviewusers"].toString();
            modelAgentSearch.avgratting = jsonArray[i]["avgratting"].toString();

            nearByRestaurantList.add(modelAgentSearch);
          }

          // business_name = jsonArray[i]["business_name"].toString();
          // avgratting = jsonArray[i]["avgratting"].toString();
          // firecount = jsonArray[i]["firecount"];
          // notcool_count = jsonArray[i]["notcool_count"];
          // user_count = jsonArray[i]["user_count"].toString();
          // review_count = jsonArray[i]["totalReviewusers"].toString();
          // business_images = jsonArray[i]["business_images"].toString();
          // id = jsonArray.last["id"].toString();

          // print("hmarai id..... "+id.toString());

          // print("rajat id "+jsonArray[i]["id"].toString());
                  
          // okcount = jsonArray[i]["okcount"];
/*          id = jsonArray[i]["id"].toString();
          business_name = jsonArray[i]["business_name"].toString();
          print("Bussiness: " + business_name.toString());
          latlong_position = jsonArray[i]["lat"].toString() +
              "," +
              " " +
              jsonArray[i]["long"].toString();
          print("lay: " + latlong_position.toString());

          nearByRestaurantList.add(modelAgentSearch);*/

          // print("lattttttt: " + lat.toString());


        }
        setState(() {});
        Map mapp = new Map();
        dataSet.clear();
        nearByRestaurantList.forEach((element) {
          mapp = element.toJson();
          dataSet.add(mapp);
        });
        print("DataSet "+dataSet.toString());
        var groupbyDate;
        map = dataSet.groupBy<String, Map>((item) =>
        item['lat'],
          valueTransform: (item) => item..remove('lat'),
        );
        print("New Map "+map.toString());
        print("Map length "+map.length.toString());

        setState(() {
          print("lengthis " + nearByRestaurantList.length.toString() + "^");
          newGoogleMapController!.setMapStyle("[]");
          initilize(nearByRestaurantList);
          isloading = false;
          viewVisible = false;
        });
      } else {
        nearByRestaurantList.clear();
        markers.clear();
        setState(() {
          newGoogleMapController!.setMapStyle("[]");
          locatePosition();
          isloading = false;
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(jsonRes["message"])));
        });
      }
    }

    searchText = mesageTextController.text;

  }

  Future<dynamic> nearBy() async {
    print("Run " + "GetAllbuisnessList");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getString("id");
    user_id = prefs.getString("id").toString();
    print("id Print: " + id.toString());
    setState(() {
      isloading = true;
      viewVisible = false;
    });

    var request = http.post(
        Uri.parse(
          RestDatasource.GETALLBUSINESSLIST_URL,
        ),
        body: {"id": id});
    String msg = "";
    var jsonArray;
    var jsonRes;
    var res;

    await request.then((http.Response response) {
      res = response;
      final JsonDecoder _decoder = new JsonDecoder();
      jsonRes = _decoder.convert(response.body.toString());
      print("Response: " + response.body.toString() + "_");
      print("ResponseJSON: " + jsonRes.toString() + "_");
      msg = jsonRes["message"].toString();
      jsonArray = jsonRes['data'];
    });

    print("JSON "+res.body.toString()+"^^");
    if (res.statusCode == 200) {
      print("Status "+jsonRes["status"].toString());

      if (jsonRes["status"].toString() == "true") {
        nearByRestaurantList.clear();
        markers.clear();
        for (var i = 0; i < jsonArray.length; i++) {
          if(jsonArray[i]["lat"].toString()!="null") {
            NearBy modelAgentSearch = new NearBy();
            modelAgentSearch.id = jsonArray[i]["id"].toString();
            modelAgentSearch.business_name =
                jsonArray[i]["business_name"].toString();
            modelAgentSearch.business_images =
                jsonArray[i]["business_images"].toString();
            modelAgentSearch.distance = jsonArray[i]["distance"].toString();
            modelAgentSearch.ratting = jsonArray[i]["ratting"].toString();
            modelAgentSearch.description =
                jsonArray[i]["description"].toString();
            modelAgentSearch.business_category =
                jsonArray[i]["business_category "].toString();
            modelAgentSearch.user_count = jsonArray[i]["user_count"].toString();
            modelAgentSearch.review_count =
                jsonArray[i]["review_count"].toString();
            modelAgentSearch.location = jsonArray[i]["location"].toString();
            modelAgentSearch.category_name =
                jsonArray[i]["category_name"].toString();
            modelAgentSearch.fav = jsonArray[i]["fav"].toString();
            modelAgentSearch.lat = jsonArray[i]["lat"].toString();
            modelAgentSearch.long = jsonArray[i]["long"].toString();
            modelAgentSearch.avgratting = jsonArray[i]["avgratting"].toString();
            modelAgentSearch.firecount = jsonArray[i]["firecount"];
            modelAgentSearch.notcool_count = jsonArray[i]["notcool_count"];
            modelAgentSearch.okcount = jsonArray[i]["okcount"];
            modelAgentSearch.totalReviewusers =
                jsonArray[i]["totalReviewusers"].toString();
            modelAgentSearch.avgratting = jsonArray[i]["avgratting"].toString();
            modelAgentSearch.opening_time =
                jsonArray[i]["opeing_hour"].toString();
            modelAgentSearch.closing_time =
                jsonArray[i]["closing_hour"].toString();


              nearByRestaurantList.add(modelAgentSearch);

            /*       id = jsonArray[i]["id"].toString();
          business_name = jsonArray[i]["business_name"].toString();
          print("Bussiness: " + business_name.toString());
          latlong_position = jsonArray[i]["lat"].toString() +
              "," +
              " " +
              jsonArray[i]["long"].toString();
          print("lay: " + latlong_position.toString());

          nearByRestaurantList.add(modelAgentSearch);*/

            // print("lattttttt: " + lat.toString());


          }

        }
       Map mapp = new Map();
        dataSet.clear();
        nearByRestaurantList.forEach((element) {
          mapp = element.toJson();
          dataSet.add(mapp);
        });
        print("DataSet "+dataSet.toString());
        var groupbyDate;
        map = dataSet.groupBy<String, Map>((item) =>
        item['lat'],
          valueTransform: (item) => item..remove('lat'),
        );
        print("New Map "+map.toString());


        setState(() {
          if (newGoogleMapController != null) {
            newGoogleMapController!.setMapStyle("[]");
          }
          print("length is " + nearByRestaurantList.length.toString());
          initilize2(nearByRestaurantList);
          locatePosition();
          isloading = false;
        });

      } else {
        setState(() {
          isloading = false;
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(jsonRes["message"].toString())));
        });
      }
    } else {
      setState(() {
        isloading = false;
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Please try later")));
      });
    }
  }

  Future<dynamic> checkInApi(String id, String check) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var user_id = prefs.getString("id");
    print("user_id Prinnt: " + user_id.toString());
    print("id Prinnt: " + id.toString().toString());
    setState(() {
      isloading = true;
    });

    var jsonRes;
    http.Response? res;
    var request = http.post(
        Uri.parse(
          RestDatasource.CHECKINAPI,
        ),
        body: {
          "id": id.toString(),
          "user_id": user_id.toString(),
          "type": "1"
        });

    await request.then((http.Response response) {
      res = response;
      final JsonDecoder _decoder = new JsonDecoder();
      jsonRes = _decoder.convert(response.body.toString());
      print("Response: " + response.body.toString() + "_");
      print("ResponseJSON: " + jsonRes.toString() + "_");
      print("status: " + jsonRes["status"].toString() + "_");
      print("message: " + jsonRes["message"].toString() + "_");
    });

    if (res?.statusCode == 200) {
      isCheckinClicked = false;

      if (jsonRes["status"].toString() == "true") {
        setState(() {
          isloading = false;
        });
        if (!jsonRes["message"].toString().contains("You are already")) {
          checkoutApi(id, check.toString());
        }
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(jsonRes["message"].toString())));
        //Navigator.push(context, MaterialPageRoute(builder: (context) => TotalUserList(customers: widget.customers)));

      } else {
        setState(() {
          isloading = false;
          // Navigator.of(context, rootNavigator: true).pop();
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(jsonRes["message"].toString())));
        });
      }
    } else {
      isCheckinClicked = false;
      setState(() {
        isloading = false;

        Navigator.of(context, rootNavigator: true).pop();
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Please try later")));
      });
    }
  }

  Future<dynamic> filterData(BuildContext context, List<LifeStyle> key, String business_type,
  String hablamos_espanol,
  String religious_spiritual,
  String current_promotion,

  ) async {
    print("Filter");

    print("business_type "+business_type.toString()+"^^");
    print("hablamos_espanol "+hablamos_espanol.toString()+"^^");
    print("religious_spiritual "+religious_spiritual.toString()+"^^");
    print("current_promotion " +current_promotion.toString()+"^^");

    List<String> list = [];
    key.forEach((element) {
      if (element.subLifeStyle != null) {
        if (element.subLifeStyle.length > 0) {
          for (var j = 0; j < element.subLifeStyle.length; j++) {
            if (element.subLifeStyle[j].isSelected) {
              list.add(element.subLifeStyle[j].id);
            }
          }
        }
      }
    });

    String s = list.join(', ');
    print("ssss " + s.toString());

      print("key Print: " + list.toString());
      setState(() {
        isloading = true;
      });

      var request = http.post(
          Uri.parse(
            RestDatasource.FILTER,
          ),
          body: {
            "key": list.toString(),
            "business_type": business_type.toString(),
            "hablamos_espanol": hablamos_espanol.toString(),
            "religious_spiritual": religious_spiritual.toString(),
            "current_promotion": current_promotion.toString(),
          });
      String msg = "";
      var jsonArray;
      var jsonRes;
      var res;

      await request.then((http.Response response) {
        res = response;
        final JsonDecoder _decoder = new JsonDecoder();
        jsonRes = _decoder.convert(response.body.toString());
        print("ResponseFilter: " + response.body.toString() + "_");
        print("ResponseJSON: " + jsonRes.toString() + "_");
        msg = jsonRes["message"].toString();
        jsonArray = jsonRes['data'];
      });

      if (res.statusCode == 200) {
        print(jsonRes["status"]);

        if (jsonRes["status"].toString() == "true") {
          nearByRestaurantList.clear();
          markers.clear();
          for (var i = 0; i < jsonArray.length; i++) {
            if(jsonArray[i]["lat"].toString()!="null") {
              NearBy modelAgentSearch = new NearBy();
              modelAgentSearch.id = jsonArray[i]["id"].toString();
              modelAgentSearch.business_name =
                  jsonArray[i]["business_name"].toString();
              modelAgentSearch.business_images =
                  jsonArray[i]["business_images"].toString();
              modelAgentSearch.distance = jsonArray[i]["distance"].toString();
              modelAgentSearch.ratting = jsonArray[i]["ratting"].toString();
              modelAgentSearch.avgratting =
                  jsonArray[i]["avgratting"].toString();
              modelAgentSearch.description =
                  jsonArray[i]["description"].toString();
              modelAgentSearch.business_category =
                  jsonArray[i]["business_category "].toString();
              modelAgentSearch.user_count =
                  jsonArray[i]["user_count"].toString();
              modelAgentSearch.review_count =
                  jsonArray[i]["review_count"].toString();
              modelAgentSearch.totalReviewusers =
                  jsonArray[i]["totalReviewusers"].toString();

              modelAgentSearch.location = jsonArray[i]["location"].toString();
              modelAgentSearch.category_name =
                  jsonArray[i]["category_name"].toString();
              modelAgentSearch.fav = jsonArray[i]["fav"].toString();
              modelAgentSearch.lat = jsonArray[i]["lat"].toString();
              modelAgentSearch.long = jsonArray[i]["long"].toString();
              modelAgentSearch.firecount = jsonArray[i]["firecount"];
              modelAgentSearch.notcool_count = jsonArray[i]["notcool_count"];
              modelAgentSearch.okcount = jsonArray[i]["okcount"];
              print("lat: " + modelAgentSearch.lat.toString());

              nearByRestaurantList.add(modelAgentSearch);
            }

          }

          Map mapp = new Map();
          dataSet.clear();
          nearByRestaurantList.forEach((element) {
            mapp = element.toJson();
            dataSet.add(mapp);
          });
          print("DataSet "+dataSet.toString());
          var groupbyDate;
          map = dataSet.groupBy<String, Map>((item) =>
          item['lat'],
            valueTransform: (item) => item..remove('lat'),
          );
          print("New Map "+map.toString());


          print("FilterListLength " +
              nearByRestaurantList.length.toString() +
              "^^");
          setState(() {
            initilize(nearByRestaurantList);
            isloading = false;
          });
        } else {
          setState(() {
            isloading = false;
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(jsonRes["message"].toString())));
          });
        }
      } else {
        setState(() {
          isloading = false;
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text("Please try later")));
        });
      }

  }

  Future<dynamic> checkoutApi(String buisnessid, String tag) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getString("id");
    print("id Print: " + id.toString());

    print("id " + id.toString() + "");
    print("review " + "review".toString() + "");

    var request = http.MultipartRequest(
      "POST",
      Uri.parse(
        RestDatasource.BUSINESSREVIEW_URL,
      ),
    );

    if (tag.toString() != "null" || tag.toString() != "") {
      request.fields["tag"] = tag;
      print("tag1: " + tag.toString());
    }
    request.fields["type"] = "CHECK_IN";
    request.fields["business_id"] = buisnessid.toString();
    request.fields["user_id"] = id.toString();

    var jsonRes;
    var res = await request.send();

    if (res.statusCode == 200) {
      check = "";

      var respone = await res.stream.bytesToString();
      final JsonDecoder _decoder = new JsonDecoder();

      jsonRes = _decoder.convert(respone.toString());
      print("Response: " + jsonRes.toString() + "_");
      print(jsonRes["statusReview"]);
    } else {
      setState(() {
        isloading = false;

        Navigator.of(context, rootNavigator: true).pop();
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Please try later")));
      });
    }
  }
}
