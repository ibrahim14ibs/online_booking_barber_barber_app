import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:flutter/material.dart';
import 'package:online_booking_barber_barber_app/view/details.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  CollectionReference usersref = FirebaseFirestore.instance.collection('users');
  late QuerySnapshot querySnapshotForUser;
  //QuerySnapshot userInfo =  usersref.where('uid',isEqualTo: FirebaseAuth.instance.currentUser!.uid).get();

  getUserInfo() async {
    querySnapshotForUser = await usersref
        .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();
  }

  @override
  void initState() {
    getUserInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0XffEDEEF7),
      appBar: AppBar(
        toolbarHeight: 90,
        elevation: 0,
        backgroundColor: Color(0XffEDEEF7),
        title: Padding(
          padding: const EdgeInsets.only(left: 15),
          child: Text(
            'الملف الشخصي',
            style: TextStyle(
                color: Colors.black87,
                fontSize: 18,
                fontWeight: FontWeight.bold),
          ),
        ),
        actions: [
          StreamBuilder<QuerySnapshot>(
              stream: usersref
                  .where('uid',
                      isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container(
                    height: 25,
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                if (snapshot.hasData) {
                  return FlutterSwitch(
                    width: 125.0,
                    height: 35.0,
                    valueFontSize: 16.0,
                    toggleSize: 45.0,
                    value: snapshot.data!.docs[0].data()['isopen'],
                    borderRadius: 30.0,
                    padding: 8.0,
                    showOnOff: true,
                    onToggle: (val) async {
                      if (val) {
                        await usersref.doc(snapshot.data!.docs[0].id).update({
                          'isopen': true,
                        });
                      } else {
                        await usersref.doc(snapshot.data!.docs[0].id).update({
                          'isopen': false,
                        });
                      }
                    },
                  );
                }
                return Container();
              }),
          IconButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.of(context).pushReplacementNamed('login');
            },
            icon: Icon(
              Icons.exit_to_app,
              color: Colors.black87,
            ),
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: new BoxDecoration(
            //0Xff1A5F7A
            color: Color(0Xff1A5F7A),
            borderRadius: new BorderRadius.only(
                topLeft: const Radius.circular(30.0),
                topRight: const Radius.circular(30.0))),
        child: StreamBuilder<QuerySnapshot>(
          stream: usersref
              .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
              .snapshots(),
          builder: (context, snaphot) {
            if (snaphot.connectionState == ConnectionState.waiting) {
              return Container(
                height: 50,
                child: Center(child: CircularProgressIndicator()),
              );
            }
            if (snaphot.hasData) {
              return ListView.builder(
                  itemCount: snaphot.data!.docs.length,
                  itemBuilder: (context, i) {
                    return Container(
                      decoration: new BoxDecoration(
                          color: Color(0XffEDEEF7),
                          borderRadius:
                              new BorderRadius.all(Radius.circular(20.0))),
                      margin: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical:
                              MediaQuery.of(context).size.height / 4 - 20),
                      width: double.infinity,
                      height: 250,
                      child: InkWell(
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Positioned(
                              left: 15,
                              top: -15,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10.0),
                                child: Image.network(
                                  snaphot.data!.docs[i].data()['imageurl'],
                                  width: 150,
                                  height: 250,
                                  fit: BoxFit.fitHeight,
                                ),
                              ),
                            ),
                            Positioned(
                              left: 170,
                              top: 20,
                              child: Container(
                                width: 150,
                                child: Text(
                                  snaphot.data!.docs[i].data()['name'],
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              left: 170,
                              top: 80,
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.star,
                                    color: Color(0Xff1A5F7A),
                                  ),
                                  Container(
                                      width: 120,
                                      child: Text(
                                        snaphot.data!.docs[i]
                                            .data()['rate']
                                            .toString(),
                                        textAlign: TextAlign.center,
                                      )),
                                ],
                              ),
                            ),
                            Positioned(
                              left: 170,
                              top: 120,
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.location_pin,
                                    color: Color(0Xff1A5F7A),
                                  ),
                                  Container(
                                    width: 120,
                                    child: Text(
                                      snaphot.data!.docs[i].data()['address'],
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                              left: 180,
                              top: 173,
                              child:
                                  snaphot.data!.docs[i].data()['isopen'] == true
                                      ? Text(
                                          "مفتوح",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.green,
                                            fontSize: 18,
                                          ),
                                        )
                                      : Text(
                                          "مغلق",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.red,
                                            fontSize: 18,
                                          ),
                                        ),
                            ),
                          ],
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Details(
                                    imageurl: snaphot.data!.docs[i]
                                        .data()['imageurl'],
                                    id: snaphot.data!.docs[i].id)),
                          );
                        },
                      ),
                    );
                  });
            }
            if (snaphot.hasError) {
              return Center(
                child: Text('حدث خطأ'),
              );
            }

            return Container(child: Text('sdsdsdfsdfsd'));
          },
        ),
      ),
    );
  }
}
