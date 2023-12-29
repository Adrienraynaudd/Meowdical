import 'package:flutter/material.dart';

class modelPhoto {
  final int id;
  final String nomDeLaPhoto;
  final String description;
  final String lienPhoto;
  final String uid;

  modelPhoto({
    required this.id,
    required this.nomDeLaPhoto,
    required this.description,
    required this.lienPhoto,
    required this.uid,
  });
}