import 'package:algo_app_proj/edit_info.dart';
import 'package:algo_app_proj/requests.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:algo_app_proj/main.dart';

/*

This is the SendLocation screen which allows the user to edit thier account information,
add a description and send the data to a supplied web service.
If the name, user ID, or description is not supplied or the data is entered in the
incorrect format an error pop-up will be displayed, informing the user that there
has been an error. If the sending of data is a success, a success pop-up will be displayed,
informing the user that the sending of data was a success and displaying the latitude
and longitude of the devices location.

*/

String latitude = "";
String longitude = "";

class SendLocation extends StatefulWidget {
  @override
  SendLocationState createState() => SendLocationState();
}

class SendLocationState extends State<SendLocation> {
  //initialise controllers
  var nameController = TextEditingController();
  var userIdController = TextEditingController();
  var descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    //dialog shown if the if the coordinates have been successfully sent
    Future success() => showDialog(
          context: context,
          builder: (context) => Dialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 150,
              decoration: BoxDecoration(
                color: Colors.white70,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                    "Data successfully sent.\n\nLatitude: $latitude\nLongitude: $longitude"),
              ),
            ),
          ),
        );
    //dialog shown if the if the coordinates were unable to be sent
    Future fail() => showDialog(
          context: context,
          builder: (context) => Dialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 150,
              decoration: BoxDecoration(
                color: Colors.white70,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text("Failed to send Coordinates"),
              ),
            ),
          ),
        );
    //Container wrapped in SingleChildScrollView to prevent overflow when keyboard is displayed
    return SingleChildScrollView(
      child: Container(
        child: Padding(
          padding: const EdgeInsets.all(28.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Name: $name",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "User ID: $userId",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 64),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green[500], // Background color
                  ),
                  onPressed: () async {
                    //await function used so the setState is run after the newly
                    //edited values have been applied in the EditInfo screen
                    await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => EditInfo()),
                    );
                    setState(() {});
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 8),
                    child: Text(
                      "Edit Info",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ),
              Text(
                "Description",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              Container(
                padding: EdgeInsets.only(top: 12, bottom: 12),
                width: MediaQuery.of(context).size.width / 1.5,
                //TextField used for entering the coordinate description
                child: TextField(
                  controller: descriptionController,
                  maxLines: 5,
                  cursorColor: Colors.white,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: "Description",
                    hintStyle: TextStyle(color: Colors.grey),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.green.shade500, width: 2),
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
                onPressed: () async {
                  await getLocation();
                  //tries to post all data
                  await postAllData(
                    name!,
                    userId!,
                    descriptionController.text,
                  );
                  //checks if post was a success or fail
                  //corresponding dialog will be shown for success or fail
                  if (code == "201")
                    success();
                  else
                    fail();
                },
                child: Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 8),
                  child: Text(
                    "Send Coordinates",
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
    );
  }
}

/*

The following method first asks the user for permission to access the devices location
settings, if the user agrees then it gets the location of the device and sets the
latitude and longitude variables to this.

*/

getLocation() async {
  //asks the device for permission to use its location
  LocationPermission permission;
  permission = await Geolocator.requestPermission();
  //gets device location
  var position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);
  //sets the latitude and longitude variable values to the devices current position
  latitude = position.latitude.toString();
  longitude = position.longitude.toString();
}
