import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:odoo_api/odoo_api.dart';
import 'package:odoo_api/odoo_user_response.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import 'ListUplaodInvoice.dart';
import 'login_page.dart';

void main() {
  runApp(const MaterialApp(
    home: UploadInvoice(),
  ));
}

class UploadInvoice extends StatefulWidget {
  const UploadInvoice({Key key}) : super(key: key);

  @override
  State<UploadInvoice> createState() => _UploadInvoiceState();
}

class _UploadInvoiceState extends State<UploadInvoice> {
  
  File imageFile;
  String base64string ;

     @override
  void initState() {
    super.initState();
    _getOrders();
  }

    var client = OdooClient("http://10.0.2.2:8014");
  Future<List> _getOrders() async {
    final domain = [];
    var fields = ["name_seq2", "last_date"];
    AuthenticateCallback auth = await client.authenticate(
        "base", "base", "base");
    if (auth.isSuccess) {
      final user = auth.getUser();
      print("Hey ${user.username}");
    } else {
      print("Login failed");
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(("Capturing Image"),
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        elevation: 0.5,
        iconTheme: IconThemeData(color: Colors.white),
        flexibleSpace:Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[Theme.of(context).primaryColor, Theme.of(context).accentColor,]
              )
          ),
        ),
         actions: [
           if(imageFile != null)
          Container(
            margin: EdgeInsets.only( top: 16, right: 16,),
            child: Stack(
              children: <Widget>[
               Expanded(
                 child: IconButton(
                 icon: const Icon(Icons.add_task_rounded),
            color: Colors.white,
           onPressed: (
           ) async => {await client.create("facture.model.activity",{"showImage":base64string}),
               Alert(
      context: context,
      type: AlertType.success,
      title: "SUCCESS",
      desc: "Invoice Created Successfully ",
      buttons: [
        DialogButton(
          child: Text(
            "OK",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => Navigator.pop(context),
          width: 120,
        )
      ],
    ).show()
           
           },
          ),
                ),
              ],
            ),
          )
        ],
      ),
      drawer: Drawer(
        child: Container(
          decoration:BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  stops: [0.0, 1.0],
                  colors: [
                    Theme.of(context).primaryColor.withOpacity(0.2),
                    Theme.of(context).accentColor.withOpacity(0.5),
                  ]
              )
          ) ,
          child: ListView(
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    stops: [0.0, 1.0],
                    colors: [ Theme.of(context).primaryColor,Theme.of(context).accentColor,],
                  ),
                ),
                child: Container(
                  alignment: Alignment.bottomLeft,
                  child: Text("INVOICE RECOGNITION",
                    style: TextStyle(fontSize: 25,color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ), 
              ListTile(
                leading: Icon(Icons.archive_outlined ,color: Theme.of(context).accentColor),
                title: Text('Upload your invoice',style: TextStyle(color: Theme.of(context).accentColor),),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => UploadInvoice()),);
                },
              ), 
              Divider(color: Theme.of(context).primaryColor, height: 1,),
              ListTile(
                leading: Icon(Icons.account_circle_outlined ,color: Theme.of(context).accentColor,),
                title: Text('List of uploaded invoices',style: TextStyle(color: Theme.of(context).accentColor),),
                onTap: () {
                   Navigator.push(context, MaterialPageRoute(builder: (context) => MyHomePage()),);
                },
              ),
                Divider(color: Theme.of(context).primaryColor, height: 1,),
                   ListTile(
                leading: Icon(Icons.logout_rounded, color: Theme.of(context).accentColor,),
                title: Text('Logout',style: TextStyle(color: Theme.of(context).accentColor),),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()),);
                },
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if(imageFile != null)
              Container(
                width: 640,
                height: 480,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 181, 41, 194),
                  image: DecorationImage(
                    image: FileImage(imageFile),
                    fit: BoxFit.cover
                  ),
                  border: Border.all(width: 8, color: Colors.grey),
                  borderRadius: BorderRadius.circular(12.0),
                ),
              )
            else
              Container(
                width: 640,
                height: 480,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(width: 8, color: Colors.black12),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: const Text('Image should appear here', style: TextStyle(fontSize: 26),),
              ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                      onPressed: ()=> getImage(source: ImageSource.camera),
                      child: const Text('Captured', style: TextStyle(fontSize: 18,color: Colors.white)),
                   style: ButtonStyle(
		backgroundColor: MaterialStateProperty.all(Color.fromARGB(255, 181, 41, 194))
	),
                  ),
                ),
                const SizedBox(width: 20,),
                Expanded(
                  child: ElevatedButton(
                      onPressed: ()=> getImage(source: ImageSource.gallery),
                      child: const Text(' Gallery', style: TextStyle(fontSize: 18,color: Colors.white)),
                      style: ButtonStyle(
		backgroundColor: MaterialStateProperty.all(Color.fromARGB(255, 181, 41, 194))
	),
                  ),
                ),
                       
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  void getImage({ ImageSource source}) async {
    
    final file = await ImagePicker.pickImage(
        source: source,
      maxWidth: 640,
      maxHeight: 480,
      imageQuality: 70 //0 - 100
    );
    
    if(file?.path != null){
      setState(() {
        imageFile = File(file.path);
      });
    }
     imageFile = File(file.path);
     print(imageFile); 
              //output /data/user/0/com.example.testapp/cache/image_picker7973898508152261600.jpg
        Uint8List imagebytes = await imageFile.readAsBytes(); //convert to bytes
         base64string = base64.encode(imagebytes);
        print(base64string);

  }


}