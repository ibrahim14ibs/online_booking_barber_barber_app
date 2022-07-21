import 'dart:async';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:online_booking_barber_barber_app/view/widget/alertdilog.dart';

class Details extends StatefulWidget {
  final String id;
  final String imageurl;
  Details({
    Key? key,
    required this.id,
    required this.imageurl,
  }) : super(key: key);

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  var myName;
  CollectionReference customersref =
      FirebaseFirestore.instance.collection('customers');

  addCustomer() async {
    CustomAlertDialog.showLoading(context);
    await customersref.add({
      'name': myName,
      'imageurl': 'null',
      'barber_ID': widget.id,
      'order': DateTime.now().millisecondsSinceEpoch,
    });
    Navigator.of(context).pop();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      floatingActionButton: Container(
        width: 130,
        child: FloatingActionButton(
          backgroundColor: Color(0Xff1A5F7A),
          onPressed: () async {
            var formData = formstate.currentState;
            if (formData!.validate()) {
              formData.save();
              await addCustomer();
            }
          },
          child: Text('اضافة زبون يدوي'),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15.0))),
        ),
      ),
      body: Container(
        color: Color(0XffEDEEF7),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 175,
              child: Stack(clipBehavior: Clip.none, children: [
                Positioned(
                  child: Image.network(
                    widget.imageurl,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  left: width / 2 - 60,
                  top: 125,
                  child: CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.transparent,
                    child: ClipOval(
                      child: Image.network(
                        widget.imageurl,
                        width: 120,
                        height: 120,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ]),
            ),
            SizedBox(
              height: 70,
            ),
            Form(
              key: formstate,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                child: TextFormField(
                  onSaved: (value) {
                    myName = value;
                  },
                  validator: (value) {
                    print(value);
                    if (value == '') {
                      return 'الرجاء ادخال الاسم ';
                    }
                  },
                  decoration: InputDecoration(
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                      hintText: 'ادخل اسم الزبون لأضافته يدويا',
                      labelText: 'اسم الزبون',
                      labelStyle:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                      hintStyle: TextStyle(fontSize: 14),
                      suffixIcon: Icon(
                        Icons.person,
                        color: Color(0Xff1A5F7A),
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25))),
                ),
              ),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: customersref
                    .where('barber_ID', isEqualTo: widget.id)
                    .orderBy('order', descending: false)
                    .snapshots(),
                builder: (context, snaphot) {
                  if (snaphot.connectionState == ConnectionState.waiting) {
                    return Container(
                      height: 50,
                      child: Center(child: CircularProgressIndicator()),
                    );
                  } else if (snaphot.hasData) {
                    return ListView.builder(
                        itemCount: snaphot.data!.docs.length,
                        itemBuilder: (context, i) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 15),
                            child: ListTile(
                                leading:
                                    snaphot.data!.docs[i].data()['imageurl'] ==
                                            'null'
                                        ? Icon(
                                            Icons.person_rounded,
                                            size: 60,
                                            color: Color(0Xff1A5F7A),
                                          )
                                        : ClipOval(
                                            child: Image.network(
                                              snaphot.data!.docs[i]
                                                  .data()['imageurl'],
                                              fit: BoxFit.cover,
                                              width: 60,
                                            ),
                                          ),
                                title: Text(
                                  snaphot.data!.docs[i].data()['name'],
                                ),
                                trailing: IconButton(
                                    onPressed: () async {
                                      await customersref
                                          .doc(snaphot.data!.docs[i].id)
                                          .delete();
                                    },
                                    icon: Icon(
                                      Icons.delete,
                                      color: Color(0Xff1A5F7A),
                                    ))),
                          );
                        });
                  } else if (snaphot.hasError) {
                    print(snaphot.error);
                    return Center(
                      child: Text(snaphot.error.toString()),
                    );
                  } else
                    return Center(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(child: Text('لاتوجد بيانات')),
                      ],
                    ));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
