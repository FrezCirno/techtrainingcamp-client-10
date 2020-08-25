import 'dart:developer';

import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
class Location {
  static fetchLocation() async {
    var permissionHandler = PermissionHandler();
    var p =await permissionHandler.requestPermissions([PermissionGroup.locationWhenInUse]);
    log(p.toString());

    return await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.low);  
  }

}