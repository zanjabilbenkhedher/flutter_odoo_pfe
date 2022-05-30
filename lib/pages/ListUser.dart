import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:loadmore/loadmore.dart';
import 'package:odoo_api/odoo_api.dart';
import 'package:odoo_api/odoo_api_connector.dart';
import 'package:odoo_api/odoo_user_response.dart';
import 'image.dart';



class MyHomePage extends StatefulWidget {
  MyHomePage({Key key,  this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class Debouncer {
  final int milliseconds;
  VoidCallback action;
  Timer _timer;
  Debouncer({ this.milliseconds});
  run(VoidCallback action) {
    if (null != _timer) {
      _timer.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}

class _MyHomePageState extends State<MyHomePage> {
  var count = 10;
  bool check = true;
  List listdata = [];
  List data = [];
  var imageView;
  final _debouncer = Debouncer(milliseconds: 1000);
  TextEditingController searchButtonController = new TextEditingController();
  @override
  void initState() {
    super.initState();
    _getOrders();
  }

  var client = OdooClient("http://10.0.2.2:8014");
  Future<List> _getOrders() async {
    final domain = [];
    var fields = ["id", "name", "login"];
    AuthenticateCallback auth = await client.authenticate(
        "base", "base", "base");
    if (auth.isSuccess) {
      final user = auth.getUser();
      print("Hey ${user.username}");
    } else {
      print("Login failed");
    }
    OdooResponse result =
        await client.searchRead("res.users", domain, fields);
    if (!result.hasError()) {
      print("Successful");
      setState(() {
        check = false;
        var response = result.getResult();
        data = response['records'];
        listdata = data;
        print("CCC");
        print(listdata);
        print(listdata.length);
      });
    } else {
      print(result.getError());
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHight = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: TextField(
            style: TextStyle(
              fontSize: 15.0,
              color: Colors.black,
            ),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.all(10.0),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  borderSide: BorderSide.none),
              hintText: "Search..",
              prefixIcon: Icon(
                Icons.search,
                color: Colors.black,
              ),
              suffixIcon: Icon(
                Icons.filter_list,
                color: Colors.black,
              ),
              hintStyle: TextStyle(
                fontSize: 15.0,
                color: Colors.black,
              ),
            ),
            maxLines: 1,
            controller: searchButtonController,
            onChanged: (string) {
              _debouncer.run(() {
                setState(() {
                  listdata = data
                      .where((u) => (u['name']
                              .toString()
                              .toLowerCase()
                              .contains(string.toLowerCase()) ||
                          u['id']
                              .toString()
                              .toLowerCase()
                              .contains(string.toLowerCase())))
                      .toList();
                });
              });
            },
          ),
          flexibleSpace: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: <Color>[Colors.blue, Colors.blue])),
          ),
        ),
        body: check
            ? Center(
                child: CircularProgressIndicator(),
              )
            : listdata.length == 0
                ? Center(
                    child: Text("No Data Found"),
                  )
                : Container(
                    child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: listdata.length,
                        itemBuilder: (context, int index) {
                          return Container(
                            margin: EdgeInsets.all(4),
                            child: Card(
                              elevation: 2,
                              child: ListTile(
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                 
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      listdata[index]['name'].toString(),
                                      style: TextStyle(
                                        fontSize: 20,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Icon(Icons.monetization_on),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          listdata[index]['id']
                                              .toString(),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                  ));
  }
}
