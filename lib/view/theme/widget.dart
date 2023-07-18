import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

final AppBar kEmptyAppBar = AppBar(
  toolbarHeight: 0,
  elevation: 0,
  backgroundColor: Colors.transparent,
  systemOverlayStyle: SystemUiOverlayStyle.dark,
);

const List<BoxShadow> kBoxShadowList = [
  BoxShadow(color: Colors.grey, blurRadius: 1, offset: Offset(1, -1)),
  BoxShadow(color: Colors.grey, blurRadius: 1, offset: Offset(1, 1)),
  BoxShadow(color: Colors.grey, blurRadius: 1, offset: Offset(-1, 1)),
  BoxShadow(color: Colors.grey, blurRadius: 1, offset: Offset(-1, -1))
];
