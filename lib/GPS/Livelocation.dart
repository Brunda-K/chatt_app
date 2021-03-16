import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:JustChat/staticVars.dart';

class Geolocation_page extends StatefulWidget {
  @override
  _Geolocation_pageState createState() => _Geolocation_pageState();
}

class _Geolocation_pageState extends State<Geolocation_page> {
  @override
  void setState(fn) {
    // TODO: implement setState
    super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    GoogleMapController _controller;
    var la;
    var lo;

    gpstrial() async {
      print("hii 1");
      Position position = await Geolocator.getCurrentPosition();
      la = position.latitude;
      lo = position.longitude;

      print(position);
      try {
        await staticVars.fsconnect
            .collection("user")
            .doc("ids")
            .collection("user-ids")
            .doc("${staticVars.username}")
            .update({"latitude": la, "longitude": lo});
        print(
            "##################################################DONE############################################################");
      } catch (e) {
        await staticVars.fsconnect
            .collection("user")
            .doc("ids")
            .collection("user-ids")
            .doc("${staticVars.username}")
            .update({"latitude": 0.00, "longitude": 0.00});
        print(
            "###############################################NOT DONE#####################################################");
      }
    }

    void _onMapCreated(GoogleMapController controller) {
      if (_controller == null) _controller = controller;
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () async {
              await FlutterStatusbarcolor.setStatusBarColor(staticVars.color);
              await FlutterStatusbarcolor.setStatusBarWhiteForeground(true);
              Navigator.pop(context);
            }),
        title: Text("GPS Location "),
        backgroundColor: Colors.blue.shade900,
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: LatLng(staticVars.lat, staticVars.long),
          zoom: 14.55,
          tilt: 50,
        ),
        mapType: MapType.normal,
      ),
      /*floatingActionButton: FloatingActionButton(
        onPressed: gpstrial,
        child: Icon(Icons.add),
      ),*/
    );
  }
}
