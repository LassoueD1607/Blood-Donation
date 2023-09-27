import 'dart:convert';
import 'package:mobile/Screens/login.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile/Screens/dashboard.dart';
import 'package:mobile/Screens/settings.dart';
import '../Models/requete.dart';
import '../utilities/constants.dart';
import '../Services/LoginService.dart';
import '../Models/beneficaire.dart';
import 'package:http/http.dart';

import 'home.dart';

class RequestsScreen extends StatefulWidget {
  @override
  _RequestsScreenState createState() => _RequestsScreenState();
}

class _RequestsScreenState extends State<RequestsScreen> {
  Future fetchRequete() async {
    var res = await get(Uri.parse("http://10.0.2.2:8080/requete/"));
    var jsonData = jsonDecode(res.body);
    List<Requete> requetes = [];
    //List<Requete> requetes = Requete.getRequetes();
    for (var u in jsonData) {
      Requete requete = Requete(
        idRequete: u["idRequete"],
        adresse: u["adresse"],
        telephone: u["telephone"],
        description: u["description"],
        //date: u["date"],
        //sang: u["sang"],
        //beneficiaire: u["beneficaire"]
      );
      requetes.add(requete);
    }
    print(requetes.length);
    return (requetes);
  }

  //List<Requete> requetes = Requete.getRequetes();
  var list = ['Motez Lassoued', 'Ahmed Hammami'];
  var list2 = ['https://drive.google.com/uc?export=view&id=1GN3vlf7FJDqXDB5kzG3m5qjFYUk5rEae', 'https://drive.google.com/uc?export=view&id=1wzLlq2k_lVYeSUWgV4xfadJkXMsfgcBz'];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme
            .of(context)
            .scaffoldBackgroundColor,
        elevation: 1,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.red,
          ),
          onPressed: () {
            Navigator.of(context).pushReplacement(
              CupertinoPageRoute(
                builder: (_) => HomeScreen(),
              ),
            );
          },
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.menu,
              color: Colors.red,
            ),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => SettingsPage()));
            },
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 50.0,
          ),
          Image.asset('assets/quote.png',
              width: 400, alignment: Alignment.topCenter),
          SizedBox(
            height: 20.0,
          ),
          Text.rich(
            TextSpan(
              style: TextStyle(
                fontSize: 30,
                fontFamily: 'poppins',
              ),
              children: [
                WidgetSpan(
                  child: Icon(
                    Icons.bloodtype,
                    size: 35,
                    color: Color.fromARGB(255, 86, 76, 76),
                  ),
                ),
                TextSpan(
                  text: 'Requests                           ',
                )
              ],
            ),
          ),
          Container(
            height: 339,
            child: Card(
              child:
              FutureBuilder(
                  future: fetchRequete(),
                  builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.data == null) {
                      return Container(
                        child: Center(
                          child: Text("Loading..."),
                        ),
                      );
                    } else
                      return Container(
                        child: ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, i) {
                              final number=snapshot.data[i].telephone;
                              return ListTile(

                                leading: CircleAvatar(
                                    radius: 35.0,
                                    backgroundImage:
                                    NetworkImage(list2[i])),
                                title: Text(list[i]),
                                subtitle:
                                Text("Adresse: " + snapshot.data[i].adresse),
                                trailing: TextButton(
                                    style: TextButton.styleFrom(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 32, vertical: 12),
                                      shape:RoundedRectangleBorder(side:BorderSide(color:Colors.transparent))),
                                  child: Text(snapshot.data[i].telephone),
                                  onPressed:()async{
                                      //indirect phone call
                                    launch('tel:/$number');
                                    await FlutterPhoneDirectCaller.callNumber(number);
                                  } ,

                                    )
                                ,onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>LoginScreen(),
                                  ),
                                );
                              },


                              );
                            }),
                      );
                  }),
            ),
          ),
        ],
      ),
    );
  }
}
