import 'package:flutter/material.dart';
import 'package:teatalk/view/theme/color.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator(color: kThemeColor));
  }
}
