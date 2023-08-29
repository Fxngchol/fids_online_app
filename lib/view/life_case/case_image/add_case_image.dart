import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../../../Utils/color.dart';
import '../../../models/CaseImage.dart';
import '../../../widget/app_bar_widget.dart';
import '../../../widget/app_button.dart';
import '../../../widget/compress_util.dart';
import '../../../widget/text_field_widget.dart';

class AddCaseImage extends StatefulWidget {
  final int? caseID;
  final int? caseImageId;
  final bool isEdit;
  const AddCaseImage(
      {super.key, this.caseID, this.isEdit = false, this.caseImageId});

  @override
  AddCaseImageState createState() => AddCaseImageState();
}

class AddCaseImageState extends State<AddCaseImage> {
  bool isPhone = Device.get().isPhone;
  File? _image;
  final picker = ImagePicker();
  String? _base64Image;
  CaseImages? caseImage;
  TextEditingController descriptionController = TextEditingController();
  bool isLoading = false;
  bool isLandscape = false;

  @override
  void initState() {
    if (widget.isEdit) {
      setState(() {
        isLoading = true;
      });
      getData();
    }
    super.initState();
  }

  getData() async {
    Future.delayed(const Duration(milliseconds: 500), () async {
      await CaseImagesDao()
          .getCaseImagesById(widget.caseID ?? -1, widget.caseImageId ?? -1)
          .then((value) {
        setState(() {
          caseImage = value;
          setDefaultData(value);
          isLoading = false;
        });
      });
    });
  }

  setDefaultData(caseImage) {
    descriptionController.text = caseImage.imageDetail;
    _base64Image = caseImage.imageFile;
    _createFileFromString(
            caseImage.imageFile.replaceAll("data:image/png;base64,", ""))
        .then((value) {
      setState(() {
        _image = File(value);
      });
    });
  }

  Future<String> _createFileFromString(base64image) async {
    Uint8List bytes = base64.decode(base64image);
    var decodedImage = await decodeImageFromList(bytes);
    if (decodedImage.width > decodedImage.height) {
      isLandscape = true;
    }

    String? dir = (await getApplicationDocumentsDirectory()).path;
    File file = File("$dir/${DateTime.now().millisecondsSinceEpoch}.pdf");
    await file.writeAsBytes(bytes);
    return file.path;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBarWidget(
          title: 'รูปภาพ',
          actions: [
            Container(
              width: 50,
            )
          ],
        ),
        body: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("images/bgNew.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: SafeArea(
                child: isLoading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : Container(
                        margin: isPhone
                            ? const EdgeInsets.all(32)
                            : const EdgeInsets.only(
                                left: 32, right: 32, top: 32, bottom: 32),
                        child: contentView()))));
  }

  contentView() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: SingleChildScrollView(
        child: Column(
          children: [
            _image != null ? imageView() : blankImage(),
            const Divider(),
            addImageButton(),
            const Divider(),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: Text(
                'คำอธิบาย',
                textAlign: TextAlign.left,
                style: GoogleFonts.prompt(
                  textStyle: TextStyle(
                    color: Colors.white,
                    letterSpacing: 0.5,
                    fontSize: MediaQuery.of(context).size.height * 0.02,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: InputField(
                  controller: descriptionController,
                  hint: 'กรอกคำอธิบาย',
                  onChanged: (value) {
                    // _base64Image = value;
                  }),
            ),
            const Divider(),
            SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: saveButton())
          ],
        ),
      ),
    );
  }

  addImageButton() {
    return Container(
        width: MediaQuery.of(context).size.width * 0.8,
        decoration: BoxDecoration(
            color: pinkButton, borderRadius: BorderRadius.circular(12)),
        child: TextButton(
          onPressed: () {
            addImage();
          },
          child: Padding(
            padding:
                const EdgeInsets.only(left: 24, right: 24, top: 8, bottom: 8),
            child: Text(
              'เพิ่มรูปภาพ',
              style: GoogleFonts.prompt(
                textStyle: TextStyle(
                  color: Colors.white,
                  letterSpacing: 0.5,
                  fontSize: MediaQuery.of(context).size.height * 0.02,
                ),
              ),
            ),
          ),
        ));
  }

  addImage() {
    final action = CupertinoActionSheet(
      title: Text(
        'อัพโหลดรูปภาพ',
        textAlign: TextAlign.center,
        style: GoogleFonts.prompt(
          textStyle: TextStyle(
            color: textColor,
            letterSpacing: 0.5,
            fontSize: MediaQuery.of(context).size.height * 0.022,
          ),
        ),
      ),
      actions: <Widget>[
        CupertinoActionSheetAction(
          isDefaultAction: true,
          onPressed: () {
            getImage(false);
          },
          child: Text(
            'รูปถ่าย',
            textAlign: TextAlign.center,
            style: GoogleFonts.prompt(
              textStyle: TextStyle(
                color: textColor,
                letterSpacing: 0.5,
                fontSize: MediaQuery.of(context).size.height * 0.02,
              ),
            ),
          ),
        ),
        CupertinoActionSheetAction(
          isDefaultAction: true,
          onPressed: () {
            getImage(true);
          },
          child: Text(
            'อัลบั้ม',
            textAlign: TextAlign.center,
            style: GoogleFonts.prompt(
              textStyle: TextStyle(
                color: textColor,
                letterSpacing: 0.5,
                fontSize: MediaQuery.of(context).size.height * 0.02,
              ),
            ),
          ),
        )
      ],
      cancelButton: CupertinoActionSheetAction(
        isDestructiveAction: true,
        onPressed: () {
          Navigator.pop(context);
        },
        child: Text(
          'Cancel',
          textAlign: TextAlign.center,
          style: GoogleFonts.prompt(
            textStyle: TextStyle(
              color: Colors.red,
              letterSpacing: 0.5,
              fontSize: MediaQuery.of(context).size.height * 0.02,
            ),
          ),
        ),
      ),
    );
    showCupertinoModalPopup(context: context, builder: (context) => action);
  }

  void getImage(bool isFromGallery) async {
    Navigator.pop(context);

    final pickedFile = await picker.pickImage(
        source: isFromGallery ? ImageSource.gallery : ImageSource.camera,
        imageQuality: 20);
    if (kDebugMode) {
      print('pickedFile ${pickedFile?.path}');
    }
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      await compressFile(File(pickedFile.path)).then((value) {
        if (kDebugMode) {
          print('value ${value.toString()}');
        }
        List<int> imageBytes = _image?.readAsBytesSync() as List<int>;
        String? base64Image = base64Encode(imageBytes);
        _base64Image = base64Image;
      }).catchError((e) {
        if (kDebugMode) {
          print(e.toString());
        }
      });
    } else {
      if (kDebugMode) {
        print('else else else else else');
      }
    }
  }

  imageView() {
    return SizedBox(
      width: isLandscape
          ? MediaQuery.of(context).size.width * 0.8
          : MediaQuery.of(context).size.width * 0.5,
      child: Stack(
        children: [
          _image != null
              ? Image(image: FileImage(_image!), fit: BoxFit.cover)
              : const SizedBox(),
          Positioned(
              top: -MediaQuery.of(context).size.height * 0.032,
              right: -MediaQuery.of(context).size.height * 0.032,
              child: TextButton(
                style: TextButton.styleFrom(
                    padding: EdgeInsets.zero, alignment: Alignment.topRight),
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  width: MediaQuery.of(context).size.height * 0.06,
                  height: MediaQuery.of(context).size.height * 0.06,
                  child: Padding(
                    padding: EdgeInsets.only(
                        right: MediaQuery.of(context).size.height * 0.026,
                        top: MediaQuery.of(context).size.height * 0.026),
                    child: const Icon(Icons.close, color: Colors.white),
                  ),
                ),
                onPressed: () {
                  setState(() {
                    _image = null;
                    _base64Image = '';
                  });
                },
              )),
        ],
      ),
    );
  }

  blankImage() {
    return Container(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.3,
        decoration: BoxDecoration(
          color: whiteOpacity,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.photo_rounded,
              size: MediaQuery.of(context).size.height * 0.06,
              color: Colors.black.withOpacity(0.7),
            ),
            Text(
              'No image available',
              textAlign: TextAlign.center,
              style: GoogleFonts.prompt(
                textStyle: TextStyle(
                  color: textColor,
                  letterSpacing: 0.5,
                  fontSize: MediaQuery.of(context).size.height * 0.025,
                ),
              ),
            ),
          ],
        ));
  }

  Widget saveButton() {
    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02),
      child: AppButton(
          color: pinkButton,
          textColor: Colors.white,
          text: 'บันทึก',
          onPressed: () {
            if (widget.isEdit) {
              CaseImagesDao().updateCaseImages(
                  'data:image/png;base64,$_base64Image',
                  descriptionController.text,
                  int.parse(caseImage?.id ?? ''));
              Navigator.of(context).pop(true);
            } else {
              if (_base64Image != null) {
                CaseImagesDao().createCaseImages(
                    widget.caseID ?? -1,
                    'data:image/png;base64,$_base64Image',
                    descriptionController.text);
              } else {
                CaseImagesDao().createCaseImages(
                    widget.caseID ?? -1, '', descriptionController.text);
              }
              Navigator.of(context).pop(true);
            }
          }),
    );
  }
}
