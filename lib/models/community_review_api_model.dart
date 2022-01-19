import 'dart:io';

import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';



class CommunityReviewAPI{
  var ratting = "";
  var name = "";
  var image = "";
  var review = "";
  List<dynamic> business_review_image = [];
  var business_review_image_status = "";
  var total_like = "";
  var total_dislike = "";
  var report_status = "";
  var business_reviews_id = "";
  var messageText = "";
  var replies_count = "";
  var id = "";
  var like_status = "";
  var image_video_status = "";
  var reply_image_video_status = "0";
  File? replyfile ;
  var replyfileName = "";
  List<Asset> replyimages = [];
  List<File> replyfileList = [];
  TextEditingController messageTextController =
  new TextEditingController();
  

}