import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:transparent_image/transparent_image.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Users List App',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text('Users List'),
        ),
        body: new Container(
          child: new FutureBuilder<List<User>>(
            future: fetchUsersFromGitHub(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return new ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {

                      return ListTile(
                        title: Text(
                          snapshot.data[index].name,
                          style: new TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 40.0,
                            height: 1.0,
                          ), textAlign: TextAlign.center,
                        ),
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => UserDetailsPage(user: snapshot.data[index],)));
                        },



                      );
                    }
                );
              } else if (snapshot.hasError) {
                return new Text("${snapshot.error}");
              }

              // By default, show a loading spinner
              return Container(
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[CircularProgressIndicator()]
                ),
              );

            },
          ),
        ),
      ),
    );
  }

  Future<List<User>> fetchUsersFromGitHub() async {
    final response = await http.get('https://api.github.com/users');
    print(response.body);
    List responseJson = json.decode(response.body.toString());
    List<User> userList = createUserList(responseJson);
    return userList;
  }


  List<User> createUserList(List data){
    List<User> list = new List();
    for (int i = 0; i < data.length; i++) {
      String title = data[i]["login"];
      String userImage = data[i]["avatar_url"];
      int id = data[i]["id"];
      User movie = new User(name: title,userImage: userImage, id: id);
      list.add(movie);
    }
    return list;
  }
}

class User {
  String name;
  String userImage;
  int id;
  User({this.name,this.userImage,this.id});
}

class UserDetailsPage extends StatelessWidget {
  final User user;

  UserDetailsPage({Key key, @required this.user}) : super(key: key);
  @override
  Widget build(BuildContext context) {

    print(user);
    return Scaffold(
      appBar: AppBar(
        title: Text(user.name),
      ),

      body: Stack(

        children: <Widget>[
          Container(
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[CircularProgressIndicator()]
            ),
          ),
          Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Center(
                    child: FadeInImage.memoryNetwork(
                      placeholder: kTransparentImage,
                      image: '${user.userImage}',
                    ),
                  ),

                  Container(
                    padding: const EdgeInsets.only(top:10, left: 24,right: 24),
                    child: Row(
                      children: [
                        Expanded(
                          /*1*/
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              /*2*/
                              Container(
                                padding: const EdgeInsets.only(top: 16,bottom: 8),
                                child: Text(
                                  'User Id = ${user.id}',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20
                                  ),
                                ),
                              ),
                              Text(
                                'User Name = ${user.name}',
                                style: TextStyle(
                                    color: Colors.grey[500],
                                    fontSize: 16
                                ),
                              ),
                            ],
                          ),
                        ),
                        /*3*/
                        Icon(
                          Icons.star,
                          color: Colors.red[500],
                        ),
                        Text('41'),
                      ],
                    ),
                  )
                ],
              )
          ),
        ],
      ),
    );
  }
}