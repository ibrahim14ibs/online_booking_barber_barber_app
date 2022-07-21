import 'dart:io';
import 'dart:math';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:online_booking_barber_barber_app/view/widget/alertdilog.dart';
import 'package:path/path.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}
// try {
//   var credential = await FirebaseAuth.instance
//       .createUserWithEmailAndPassword(
//     email: 'ibrahim@gmail.com',
//     password: '11ibra00',
//   );

//   print(credential);
// } on FirebaseAuthException catch (e) {
//   if (e.code == 'weak-password') {
//     print('The password provided is too weak.');
//   } else if (e.code == 'email-already-in-use') {
//     print('The account already exists for that email.');
//   }
// } catch (e) {
//   print(e);
// }

class _SignUpState extends State<SignUp> {
  static const String userType = 'حلاق';
  CollectionReference usersref = FirebaseFirestore.instance.collection('users');

  var ref;
  File? file;
  var myName, myEmail, myPassword, imageurl, myAddress;
  bool isOpen = false;
  int rate = 0;
  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  Future<User?> signUpUser(context) async {
    try {
      CustomAlertDialog.showLoading(context);

      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: myEmail,
        password: myPassword,
      );
      return credential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
        Navigator.of(context).pop();
        AwesomeDialog(
            context: context,
            title: 'Error',
            body: Text('كلمة السر التي ادخلتها ضعيفة جدا'))
          ..show();
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
        Navigator.of(context).pop();
        AwesomeDialog(
            context: context,
            title: 'Error',
            body: Text('البريد الالكنروني الذي ادخلته مستخدم بالفعل'))
          ..show();
      }
    } catch (e) {
      print(e);
    }
  }

  addUser(String uid) async {
    await usersref.add({
      'name': myName,
      'email': myEmail,
      'type': userType,
      'isopen':isOpen,
      'rate':rate,
      'imageurl': imageurl,
      'address': myAddress,
      'uid': uid
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0Xff1A5F7A),
      appBar: AppBar(
        toolbarHeight: 150,
        elevation: 0,
        backgroundColor: Color(0Xff1A5F7A),
        title: Padding(
          padding: const EdgeInsets.only(left: 15),
          child: Text(
            'انشاء حساب',
            style: TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: new BoxDecoration(
            //0Xff1A5F7A
            color: Color(0XffEDEEF7),
            borderRadius: new BorderRadius.only(
                topLeft: const Radius.circular(30.0),
                topRight: const Radius.circular(30.0))),
        child: ListView(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.10,
            ),
            Container(
              margin: EdgeInsets.only(bottom: 10),
              child: InkWell(
                onTap: () {
                  showBottomSheet(context);
                },
                child: imageurl == null
                    ? CircleAvatar(
                        backgroundColor: Color(0Xff1A5F7A),
                        // backgroundImage: AssetImage('assets/person.png'),
                        radius: 60,
                        child: Icon(
                          Icons.person_rounded,
                          size: 115,
                          color: Colors.white,
                        ),
                      )
                    : CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.transparent,
                        child: ClipOval(
                          child: Image.network(
                            imageurl,
                            width: 120,
                            height: 120,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
              ),
            ),
            Form(
                key: formstate,
                child: Column(
                  children: [
                    Container(
                      margin:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                      child: TextFormField(
                        onSaved: (value) {
                          myName = value;
                        },
                        validator: (value) {
                          print(value);
                          if (value == '') {
                            return 'الرجاء ادخال الاسم ';
                          }
                          if (value!.length < 10) {
                            return ' الرجاء ادخال الاسم الثلاثي  ';
                          }
                        },
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 25),
                            labelText: 'الاسم الثلاثي',
                            labelStyle: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.bold),
                            hintStyle: TextStyle(fontSize: 14),
                            suffixIcon: Icon(
                              Icons.person,
                              color: Color(0Xff1A5F7A),
                            ),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25))),
                      ),
                    ),
                    Container(
                      margin:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                      child: TextFormField(
                        onSaved: (value) {
                          myAddress = value;
                        },
                        validator: (value) {
                          print(value);
                          if (value == '') {
                            return 'الرجاء ادخال عنوان الصالون ';
                          }
                        },
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 25),
                            labelText: 'عنوان الصالون',
                            labelStyle: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.bold),
                            hintStyle: TextStyle(fontSize: 14),
                            suffixIcon: Icon(
                              Icons.location_on,
                              color: Color(0Xff1A5F7A),
                            ),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25))),
                      ),
                    ),
                    Container(
                      margin:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                      child: TextFormField(
                        onSaved: (value) {
                          myEmail = value;
                        },
                        validator: (value) {
                          print(value);
                          if (value == '') {
                            return 'الرجاء ادخال البريد الالكتروني';
                          }
                          if (!value!.contains('@') || !value.contains('com')) {
                            return ' الرجاء ادخال بريد الكتروني صحيح';
                          }
                        },
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 25),
                            labelText: 'البريد الالكتروني',
                            labelStyle: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.bold),
                            hintStyle: TextStyle(fontSize: 14),
                            suffixIcon: Icon(
                              Icons.email,
                              color: Color(0Xff1A5F7A),
                            ),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25))),
                      ),
                    ),
                    Container(
                      margin:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                      child: TextFormField(
                        obscureText: true,
                        onSaved: (value) {
                          myPassword = value;
                        },
                        validator: (value) {
                          print(value);
                          if (value == '') {
                            return 'الرجاء ادخال  كلمة السر';
                          }
                        },
                        decoration: InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 25),
                            labelText: 'كلمة السر',
                            labelStyle: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.bold),
                            hintStyle: TextStyle(fontSize: 14),
                            suffixIcon: Icon(
                              Icons.lock,
                              color: Color(0Xff1A5F7A),
                            ),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25))),
                      ),
                    ),
                  ],
                )),
            SizedBox(
              height: 10,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 35, vertical: 20),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: Color(0Xff1A5F7A),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20))),
                onPressed: () async {
                  var formData = formstate.currentState;
                  if (formData!.validate()) {
                    formData.save();
                    var user = await signUpUser(context);
                    if (user != null) {
                      await addUser(user.uid);
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                      Navigator.of(context)
                          .pushReplacementNamed('homePageBarber');
                    }
                  }
                },
                child: Text(
                  'انشاء حساب',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  showBottomSheet(context) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            padding: EdgeInsets.all(20),
            height: 180,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'الصورة الشخصية',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                InkWell(
                  onTap: () async {
                    print("imageUrl $imageurl");
                    var _picker = await ImagePicker()
                        .pickImage(source: ImageSource.gallery);
                    if (_picker != null) {
                      CustomAlertDialog.showLoading(context);
                      print('object');
                      file = File(_picker.path);
                      var rand = Random().nextInt(10000000);
                      var imageName = "$rand" + basename(_picker.path);

                      ref = FirebaseStorage.instance
                          .ref('images')
                          .child('$imageName');

                      await ref!.putFile(file!);
                      imageurl = await ref!.getDownloadURL();
                      print("imageUrl $imageurl");
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    }
                    setState(() {});
                  },
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Icon(
                          Icons.photo_album_outlined,
                          size: 30,
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Text('المعرض'),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () async {
                    var _picker = await ImagePicker()
                        .pickImage(source: ImageSource.camera);
                    if (_picker != null) {
                      file = File(_picker.path);
                      print(_picker.path);
                      var rand = Random().nextInt(10000000);
                      var imageName = "$rand" + basename(_picker.path);

                      ref = FirebaseStorage.instance
                          .ref('images')
                          .child('$imageName');

                      Navigator.of(context).pop();
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Icon(
                          Icons.photo_camera,
                          size: 30,
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Text('الكاميرا'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }
}
