import 'dart:ui';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart';
import 'package:riderapp/All%20widgets/configMaps.dart';
import 'package:riderapp/assistants/requestAssistant.dart';

class AssistantMethods
{
  static Future<String> searchCoordinateAddress(Position position) async
  {
    String placeAddress = "";
    String url = "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=AIzaSyBgPvTc1NDd8tByI0pobWI8W6Q8h40_csY";
    var response = await RequestAssistant.getRequest(url);
    if(response != "failed"){
      placeAddress = response["results"][0]["formatted_address"];
    }
    return placeAddress;
  }
}