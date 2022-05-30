import 'package:flutter/material.dart';
import 'package:odoo_api/odoo_api.dart';
import 'package:odoo_flutter/pages/profile_page.dart';
import 'package:odoo_api/odoo_api.dart';
import 'package:odoo_api/odoo_api_connector.dart';
import 'package:odoo_api/odoo_user_response.dart';


var client = new OdooClient("http://10.0.2.2:8014");

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() {
    return _LoginPageState();
  }
}
class _LoginPageState extends State<LoginPage> {
  

  String email;
  String password;
  String database;
  String name;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: ListView(
          children: <Widget>[
      
            Container(
              alignment: Alignment.center,
              child: Text(
                'Log In',
                style: TextStyle(
                  fontSize: 32.0,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 30.0),
              child: TextField(
             
                decoration: InputDecoration(
                    labelText: 'Database',
                ),
                onChanged: (value) {
                  this.database = value;
                },
               
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 30.0),
              child: TextField(
                decoration: InputDecoration(
                    labelText: 'E-mail',
                    hintText: 'example@site.com'
                ),
                onChanged: (value){
                  this.email = value;
                },
            
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 30.0),
              child: TextField(
                decoration: InputDecoration(
                    labelText: 'Password',
                ),
                onChanged: (value) {
                  this.password = value;
                },

              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(left: 20.0, right: 10.0),
                    height: 50.0,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: RaisedButton(
                      color: Colors.blue,
                      disabledColor: Colors.transparent,
                      onPressed: (){
                        client.authenticate(email, password, database).then((auth) {
                          if(auth.isSuccess) {
                            final user = auth.getUser();
                            name=user.name;
                            print("Hello ${user.name}");
                                  //After successful login we will redirect to profile page. Let's create profile page now
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage(login: name)));
                               
                          } else {
                            print("Login Gagal");
                          }
                        });

                      },
                         child: Padding(
                                  padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
                                  child: Text('Sign In'.toUpperCase(), style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),),
                                ),
                    ),
                  ),
                ),
             
              ],
            )


          ],
        ),
      ),
    );
  }
}

