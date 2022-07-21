
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:online_booking_barber_barber_app/view/widget/alertdilog.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  var myEmail, myPassword;
  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  Future<UserCredential?> signIn() async {
    var formData = formstate.currentState;
    if (formData!.validate()) {
      formData.save();
      print(myEmail);
      print(myPassword);

      try {
        CustomAlertDialog.showLoading(context);
        final credential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: myEmail, password: myPassword);
        return credential;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          print('No user found for that email.');
          Navigator.of(context).pop();
          AwesomeDialog(
              context: context,
              title: 'Error',
              body: Text('لايوجد مستخدم مرتبط بهذا البريد الالكترني'))
            ..show();
        } else if (e.code == 'wrong-password') {
          print('Wrong password provided for that user.');
          Navigator.of(context).pop();
          AwesomeDialog(
              context: context, title: 'Error', body: Text('كلمة السر خاطئة'))
            ..show();
        }
      }
    }
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
            'تسجيل الدخول',
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
              height: MediaQuery.of(context).size.height * 0.20,
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
              height: 5,
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 30),
                  child: Text(
                    'ليس لديك حساب ',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed('signUp');
                    },
                    child: Text(
                      'انشاء حساب',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )),
              ],
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 35, vertical: 20),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: Color(0Xff1A5F7A),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20))),
                onPressed: () async {
                  var userCredential = await signIn();
                  if (userCredential != null) {
                    var usersref = await FirebaseFirestore.instance
                        .collection('users')
                        .get();
                    var userList = usersref.docs;

                    userList.forEach((element) {
                      if (element.data()['uid'] == userCredential.user!.uid) {
                        if (element.data()['type'] == 'حلاق') {
                          Navigator.of(context).pop();
                          Navigator.of(context)
                              .pushReplacementNamed('homePageBarber');
                        } else {
                          print('زبون');
                        }
                      }
                    });
                  }
                },
                child: Text(
                  'تسجيل الدخول',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
