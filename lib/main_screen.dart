import 'dart:io';
import 'package:Allergy_Crosser/forget_password_screen.dart';
import 'package:Allergy_Crosser/text_addition.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io' as io;

import 'package:image_picker/image_picker.dart';

class MainScreenMyAllergies extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final name;
  const MainScreenMyAllergies({Key? key, required this.name}) : super(key: key);

  @override
  _MainScreenMyAllergiesState createState() => _MainScreenMyAllergiesState();
}

class _MainScreenMyAllergiesState extends State<MainScreenMyAllergies> {
  var myallergies = [];
  var newallergy = '';
  bool alergyfound = false;
  String allergyfoundname = '';
  final picker = ImagePicker();
  InputImage? inputImage;
  var isLoading = false;
  Rx<File> imageFile = File('').obs;
  late io.File cameraImage;
  var allergyMatching = '';
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

            result.add(str);
          }
        }
      }
    });
    for (int k = 0; k < result.length; k++) {
      if (isPresent(result[k], myallergies)) {
        setState(() {
          alergyfound = true;
          allergyfoundname = result[k];
        });
      }
    }
    if (alergyfound) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text("Not safe to Buy it contains  $allergyfoundname"),
            actions: <Widget>[
              TextButton(
                child: Text("OK"),
                onPressed: () {
                  setState(() {
                    allergyfoundname = '';
                    alergyfound = false;
                  });
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
                  setState(() {
                    allergyfoundname = '';
                    alergyfound = false;
                  });
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
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
          widget.name) {
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

  showAlertDialog(BuildContext context) {
    // set up the button
    Widget okButton = TextButton(
      child: Text("Save"),
      onPressed: () {
        if (newallergy != (null)) {
          myallergies.add(newallergy);
          FirebaseFirestore.instance
              .collection("users")
              .doc(widget.name)
              .update({
            'Allergies': myallergies,
          }).then((value) {
            usernameFinding();
            setState(() {
              newallergy = '';
            });
            Navigator.of(context).pop();
          });
        }
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Add New"),
      content: TextFormField(
        controller: null,
        decoration: InputDecoration(
          labelText: 'Add New Allergy',
          labelStyle: TextStyle(color: Colors.grey),
        ),
        onChanged: (String value) {
          setState(() {
            newallergy = value;
          });
        },
      ),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Center(
          child: Text(
            "My Allergies",
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ),
        actions: [
          Row(
            children: [
              IconButton(
                icon: Icon(
                  Icons.text_fields,
                  color: Colors.black,
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              TextAddition(nameused: widget.name)));
                },
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
                                nameofusermatching: widget.name,
                              )));
                },
              ),
            ],
          ),
        ],
        leading: GestureDetector(
          onTap: upload,
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
                  "Scan",
                  style: TextStyle(
                    color: Color(0XFF3a67d7),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: Get.height * 0.5,
            child: ListView.builder(
              itemCount: myallergies.length,
              itemBuilder: (context, position) {
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      myallergies != (null) ? myallergies[position] : "1",
                      style: TextStyle(fontSize: 22.0),
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(
            height: Get.height * 0.1,
          ),
          GestureDetector(
            onTap: () {
              showAlertDialog(context);
              // Navigator.push(context,
              //     MaterialPageRoute(builder: (context) => LoginScreen()));
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3),
                color: Color(0XFF3a67d7),
              ),
              width: Get.width * 0.6,
              height: 45,
              child: Center(
                child: Text(
                  'Add New Allergy',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: Get.height * 0.02,
          ),
          GestureDetector(
            onTap: () {
              Widget okButton = TextButton(
                child: Text("Edit"),
                onPressed: () {
                  var newAllergyList = [];
                  for (int k = 0; k < myallergies.length; k++) {
                    if (allergyMatching != myallergies[k]) {
                      newAllergyList.add(myallergies[k]);
                    }
                  }
                  if (newAllergyList != (null)) {
                    newAllergyList.add(newallergy);
                    FirebaseFirestore.instance
                        .collection("users")
                        .doc(widget.name)
                        .update({
                      'Allergies': newAllergyList,
                    }).then((value) {
                      setState(() {
                        allergyMatching = '';
                        newallergy = '';
                      });
                      usernameFinding();
                      Navigator.of(context).pop();
                    });
                  }
                },
              );

              // set up the AlertDialog
              AlertDialog alert = AlertDialog(
                title: Text("Edit"),
                // ignore: sized_box_for_whitespace
                content: Container(
                  height: Get.height * 0.2,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: null,
                        decoration: InputDecoration(
                          labelText: 'Add Previous Allergy',
                          labelStyle: TextStyle(color: Colors.grey),
                        ),
                        onChanged: (String value) {
                          setState(() {
                            allergyMatching = value;
                          });
                        },
                      ),
                      TextFormField(
                        controller: null,
                        decoration: InputDecoration(
                          labelText: 'Add New Allergy',
                          labelStyle: TextStyle(color: Colors.grey),
                        ),
                        onChanged: (String value) {
                          setState(() {
                            newallergy = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                actions: [
                  okButton,
                ],
              );

              // show the dialog
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return alert;
                },
              );
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3),
                color: Color(0XFF3a67d7),
              ),
              width: Get.width * 0.6,
              height: 45,
              child: Center(
                child: Text(
                  'Edit Allergy',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: Get.height * 0.02,
          ),
          GestureDetector(
            onTap: () {
              Widget okButton = TextButton(
                child: Text("Delete"),
                onPressed: () {
                  var newAllergyList = [];
                  for (int k = 0; k < myallergies.length; k++) {
                    if (allergyMatching != myallergies[k]) {
                      newAllergyList.add(myallergies[k]);
                    }
                  }
                  if (newAllergyList != (null)) {
                    FirebaseFirestore.instance
                        .collection("users")
                        .doc(widget.name)
                        .update({
                      'Allergies': newAllergyList,
                    }).then((value) {
                      setState(() {
                        allergyMatching = "";
                      });
                      usernameFinding();
                      Navigator.of(context).pop();
                    });
                  }
                },
              );

              // set up the AlertDialog
              AlertDialog alert = AlertDialog(
                title: Text("Delete"),
                // ignore: sized_box_for_whitespace
                content: Container(
                  height: Get.height * 0.15,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: null,
                        decoration: InputDecoration(
                          labelText: 'Select Allergy',
                          labelStyle: TextStyle(color: Colors.grey),
                        ),
                        onChanged: (String value) {
                          setState(() {
                            allergyMatching = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                actions: [
                  okButton,
                ],
              );

              // show the dialog
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return alert;
                },
              );
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3),
                color: Color(0XFF3a67d7),
              ),
              width: Get.width * 0.6,
              height: 45,
              child: Center(
                child: Text(
                  'Delete Allergy',
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
