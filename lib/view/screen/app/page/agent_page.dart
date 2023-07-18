import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AgentPage extends StatelessWidget {
  const AgentPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SizedBox(
          height: 50,
          width: 130,
          child: SvgPicture.asset(
            "assets/images/logo.svg",
            alignment: Alignment.centerLeft,
            fit: BoxFit.contain,
          ),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Center(
          child: Image.asset('assets/images/coming_soon.gif'),
        ),
      ),
    );
  }
}
