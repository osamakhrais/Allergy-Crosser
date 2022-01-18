import 'dart:io' as io;

import 'dart:io';

import 'package:Allergy_Crosser/forget_password_screen.dart';
import 'package:Allergy_Crosser/main_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';

class TextAddition extends StatefulWidget {
  final String nameused;
  const TextAddition({Key? key, required this.nameused}) : super(key: key);

  @override
  _TextAdditionState createState() => _TextAdditionState();
}

class _TextAdditionState extends State<TextAddition> {
  final picker = ImagePicker();
  var myallergies = [];
  var newallergy = '';
  bool alergyfound = false;
  String ingredient = '';
  InputImage? inputImage;
  var isLoading = false;
  Rx<File> imageFile = File('').obs;
  late io.File cameraImage;
  late String str;
  var result = [];
  Future pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        imageFile.value = File(pickedFile.path);
        inputImage = InputImage.fromFilePath(pickedFile.path);
        imageToText(inputImage);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('No image selected.'),
        ));
      }
    });
  }

  Future<void> upload() async {
    pickImage();
  }

  Future imageToText(inputImage) async {
    result = [];

    final textDetector = GoogleMlKit.vision.textDetector();
    final RecognisedText recognisedText =
        await textDetector.processImage(inputImage);

    setState(() {
      for (TextBlock block in recognisedText.blocks) {
        for (TextLine line in block.lines) {
          for (TextElement element in line.elements) {
            setState(() {
              str = element.text.replaceAll(',', "");
              str = str.replaceAll('.', "");
              str = str.replaceAll(':', "");
              str = str.replaceAll(';', "");
              str = str.replaceAll('(', "");
              str = str.replaceAll(')', "");
              str = str.replaceAll('[', "");
              str = str.replaceAll(']', "");
              str = str.replaceAll('{', "");
              str = str.replaceAll('}', "");
            });
            print(str);
            result.add(str);
          }
        }
      }
    });
    for (int k = 0; k < result.length; k++) {
      if (isPresent(result[k], myallergies)) {
        setState(() {
          alergyfound = true;
        });
      }
    }
    if (alergyfound) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Not Safe to Eat"),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Safe to Eat"),
      ));
    }
  }

  bool isPresent(String fruitName, List listadded) {
    return listadded.contains(fruitName);
  }

  Future<void> usernameFinding() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection("users").get();
    for (int i = 0; i < querySnapshot.docs.length; i++) {
      if ((querySnapshot.docs[i].data() as dynamic)['First Name'] ==
          widget.nameused) {
        if ((querySnapshot.docs[i].data() as dynamic)['Allergies'] != null) {
          setState(() {
            myallergies =
                (querySnapshot.docs[i].data() as dynamic)['Allergies'];
          });
        }
      }
    }
  }

  @override
  void initState() {
    usernameFinding();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Text",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        actions: [
          Row(
            children: [
              IconButton(
                icon: Icon(
                  Icons.camera,
                  color: Colors.black,
                ),
                onPressed: upload,
              ),
              IconButton(
                icon: Icon(
                  Icons.person,
                  color: Colors.black,
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ForgetPassword(
                                nameofusermatching: widget.nameused,
                              )));
                },
              ),
            ],
          ),
        ],
        leadingWidth: 120,
        leading: GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        MainScreenMyAllergies(name: widget.nameused)));
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Row(
              children: const [
                Icon(
                  Icons.arrow_back_ios,
                  size: 15,

                  color: Color(0XFF3a67d7), // add custom icons also
                ),
                Text(
                  "My Allergies",
                  style: TextStyle(
                    color: Color(0XFF3a67d7),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextFormField(
            controller: null,
            decoration: InputDecoration(
              prefixIcon: Icon(
                Icons.text_fields,
                color: Color(0XFF3a67d7),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              labelText: 'Write Ingredient',
              labelStyle: TextStyle(color: Colors.grey),
            ),
            onChanged: (String value) {
              setState(() {
                ingredient = value;
              });
            },
          ),
          SizedBox(
            height: 20,
          ),
          GestureDetector(
            onTap: () async {
              if (isPresent(ingredient, myallergies)) {
                setState(() {
                  alergyfound = true;
                });
              }
              if (alergyfound) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      content: Text("Not safe to Buy it contains  $ingredient"),
                      actions: <Widget>[
                        TextButton(
                          child: Text("OK"),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              } else {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      content: Text("Safe to Eat"),
                      actions: <Widget>[
                        TextButton(
                          child: Text("OK"),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              }
            },
            child: Container(
              decoration: BoxDecoration(
                color: Color(0XFF3a67d7),
                borderRadius: BorderRadius.circular(20),
              ),
              width: Get.width * 0.9,
              height: 50,
              child: Center(
                child: Text(
                  'Check',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
