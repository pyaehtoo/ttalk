import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:teatalk/view/theme/color.dart';

class CreatePostGallery extends StatefulWidget {
  final List<XFile> xFileList;
  final Function(int) onDelete;
  const CreatePostGallery(
      {Key? key, required this.xFileList, required this.onDelete})
      : super(key: key);

  @override
  State<CreatePostGallery> createState() => _CreatePostGalleryState();
}

class _CreatePostGalleryState extends State<CreatePostGallery> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(color: kThemeBgColor),
        height: double.infinity,
        width: double.infinity,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Container(
                constraints: const BoxConstraints(minWidth: double.infinity),
                child: Center(
                  child: PageView.builder(
                    itemCount: widget.xFileList.length,
                    itemBuilder: (context, index) {
                      return Center(
                        child: Stack(
                          children: [
                            Image.file(
                              File(widget.xFileList[index].path),
                            ),
                            Positioned(
                              right: 8,
                              //left: MediaQuery.of(context).size.width - 15,
                              child: IconButton(
                                onPressed: () {
                                  setState(() {
                                    widget.onDelete(index);
                                    if(widget.xFileList.isEmpty){
                                      Navigator.pop(context);
                                    }
                                  });
                                } ,
                                icon: SvgPicture.asset(
                                  'assets/images/ic_remove.svg',
                                  height: 25,
                                  width: 25,
                                ),
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            SafeArea(
              child: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: SvgPicture.asset(
                  'assets/images/ic_remove.svg',
                  height: 30,
                  width: 30,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
