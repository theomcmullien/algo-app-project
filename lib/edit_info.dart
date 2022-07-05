import 'package:algo_app_proj/main.dart';
import 'package:flutter/material.dart';
import 'package:algo_app_proj/send_location.dart';

class EditInfo extends StatefulWidget {
  @override
  EditInfoState createState() => EditInfoState();
}

class EditInfoState extends State<EditInfo> {
  //initialise controllers
  var nameController = TextEditingController();
  var userIdController = TextEditingController();

  //sets the initial state of the name and userid controllers to the stored name and uderid
  @override
  void initState() {
    name == null ? name = "Not Set" : nameController.text = name!;
    userId == null ? userId = "Not Set" : userIdController.text = userId!;
    return super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //Container wrapped in SingleChildScrollView to prevent overflow when keyboard is displayed
    return Container(
      constraints: BoxConstraints.expand(),
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage("assets/images/background.png"),
            fit: BoxFit.cover),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.green[900],
        ),
        //Container wrapped in SingleChildScrollView to prevent overflow when keyboard is displayed
        body: SingleChildScrollView(
          child: Center(
            child: Container(
              child: Padding(
                padding: const EdgeInsets.all(28.0),
                child: Column(
                  children: [
                    Text(
                      "Name",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 12, bottom: 12),
                      width: MediaQuery.of(context).size.width / 1.5,
                      //TextField used for entering users name
                      child: TextField(
                        controller: nameController,
                        cursorColor: Colors.white,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: "Name",
                          hintStyle: TextStyle(color: Colors.grey),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.green.shade500, width: 2),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    Text(
                      "User ID",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 12, bottom: 12),
                      width: MediaQuery.of(context).size.width / 1.5,
                      //TextField used for entering the UserId
                      child: TextField(
                        controller: userIdController,
                        cursorColor: Colors.white,
                        style: TextStyle(color: Colors.white),
                        //changes keyboardtype to numbers
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: "UserID",
                          hintStyle: TextStyle(color: Colors.grey),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.green.shade500, width: 2),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.green[500], // Background color
                      ),
                      //onPressed function for applying the entered values of the textfields
                      //to their corresponding variables, then popping the screen, navigating
                      //back to the home screen
                      onPressed: () {
                        prefs.setString("name", nameController.text);
                        prefs.setString("userId", userIdController.text);
                        name = nameController.text;
                        userId = userIdController.text;
                        Navigator.pop(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8, bottom: 8),
                        child: Text(
                          "Save",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
