import 'package:flutter/material.dart';
import 'package:litethreads/components/fetch.dart';
import 'package:litethreads/globals/variables.dart';
import 'package:litethreads/models/post.dart';
import 'package:litethreads/views/group_specific.dart';
import 'package:litethreads/views/user_specifik.dart';

String formatDuration(Duration duration) {
  List<String> parts = [];

  if (duration.inDays > 0) {
    if (duration.inDays == 1) {
      parts.add('${duration.inDays} day ago');
    } else {
      parts.add('${duration.inDays} days ago');
    }
    duration = duration - Duration(days: duration.inDays);
  } else {
    parts.add('${duration.inHours}h');
    duration = duration - Duration(hours: duration.inHours);
  }

  return parts.join(' ');
}
