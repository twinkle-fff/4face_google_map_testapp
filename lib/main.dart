
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'location.dart' as locations;
void main() {
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}
class _MyHomePageState extends State<MyHomePage> {
  bool f = false;
  final Map<String,Marker> _markers = {};
  Map<String,BitmapDescriptor> _icons = {};
  late GoogleMapController mapController;
  final LatLng _center = const LatLng(35.66078134297374, 139.7073353749213);
  late LatLng now = _center;
  void _onMapCreated(GoogleMapController controller) async {
    setState(() {
      _markers.clear();
    });
    mapController = controller;
    final googleOffices = await locations.getGoogleOffices();
    for(final office in googleOffices.places) {
      _icons[office.name] = await createIcon(office.num);
    }

    setState (() {
      _markers.clear();
      for(final office in googleOffices.places){
        // final icon = createIcon(office.num);
        final marker = Marker(markerId: MarkerId(office.name),
            icon: _icons[office.name] ?? BitmapDescriptor.defaultMarker,
            position: LatLng(office.lat,office.lng),
            infoWindow: InfoWindow(
              title: office.name,
            ));
        _markers[office.name] = marker;
      }
    });
  }

  void redraw() async {
    if(now == _center){return;}
    setState(() {
      _markers.clear();
    });
    final googleOffices = await locations.redraw(lat: now.latitude,lng: now.longitude);
    for(final office in googleOffices.places) {
      _icons[office.name] = await createIcon(office.num);
    }

    setState (() {
      _markers.clear();
      for(final office in googleOffices.places){
        // final icon = createIcon(office.num);
        final marker = Marker(markerId: MarkerId(office.name),
            icon: _icons[office.name] ?? BitmapDescriptor.defaultMarker,
            position: LatLng(office.lat,office.lng),
            infoWindow: InfoWindow(
              title: office.name,
            ));
        _markers[office.name] = marker;
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "google_map",
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.0,
            fontWeight: FontWeight.w600
          ),
        ),
        backgroundColor: Colors.indigo,
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _center,
          zoom: 15.0,
        ),
        onCameraMove: (cameraPosition){
          now = cameraPosition.target;
        },
        onCameraIdle: redraw,
        myLocationButtonEnabled: true,
        markers: _markers.values.toSet(),
        minMaxZoomPreference: const MinMaxZoomPreference(12.0,19.0),
      ),
    );
  }


  Future<BitmapDescriptor> createIcon(int val) async{
    final PictureRecorder pictureRecorder = PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final m = MediaQuery.devicePixelRatioOf(context);
    canvas.scale(m,m);
    final paint = Paint();
    paint.color = (val == 0) ? const Color(0xFF828577) : const Color(0xFF373835);
    canvas.drawCircle(const Offset(20,20), 20, paint);
    canvas.drawRect(const Rect.fromLTWH(20, 0, 26, 40),paint);
    canvas.drawCircle(const Offset(46,20), 20, paint);
    //描画
    TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: val.toString(),
        style: TextStyle(
          color: (val == 0) ? const Color(0xFFACAFA4) : const Color(0xFFB5E825),
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout(minWidth: 0,maxWidth: 100);
    final size = textPainter.size;
    textPainter.paint(canvas, Offset(33-size.width/2, 20-size.height/2));



    final image = await pictureRecorder.endRecording().toImage((66*m).ceil(),(40*m).ceil());
    final data = await image.toByteData(format: ImageByteFormat.png);
    final Uint8List bytes = data!.buffer.asUint8List();
    return BitmapDescriptor.fromBytes(bytes);

  }

}
