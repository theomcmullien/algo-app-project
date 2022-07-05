import 'dart:convert';
import 'dart:io';
import 'package:algo_app_proj/send_location.dart';

/*

The following Future method is used to send a post request to the following server/ip:
http://developer.kensnz.com/api/addlocdata
All data sent to the server is first put into a map which will comprise of the
following:
userid - this is the userid set my the user on the edit_info screen.
latitude - this is generated using the location of the device in the getLocation method.
longitude - this is generated using the location of the device in the getLocation method.
description - this is supplied by the user to give a description to the specific coord being sent.

*/

HttpClient client = new HttpClient();
var ip = "http://developer.kensnz.com/api/addlocdata";
String code = "";

Future postAllData(String name, String userid, String description) async {
  //checks if name textfield is empty, if empty returns
  if (name == "") {
    code = "";
    return;
  }
  //initialising map values
  Map map = {
    "userid": "$userid",
    "latitude": "$latitude",
    "longitude": "$longitude",
    "description": "$description",
  };
  //badCertificateCallback set to true to allow the request from the given ip
  client.badCertificateCallback =
      ((X509Certificate cert, String host, int port) => true);
  HttpClientRequest request =
      await client.postUrl(Uri.parse(ip)); //posts to the API
  request.headers.add("Content-Type", "application/json");
  request.headers.add("Accept", "*/*");
  request.add(utf8.encode(jsonEncode(
      map))); //endcodes the above map into json to be sent to the API
  HttpClientResponse result = await request.close();
  print(result.statusCode); //test/check status
  code = result.statusCode.toString();
  print(code); //test/check status
}
