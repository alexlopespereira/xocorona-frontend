import 'dart:isolate';
import 'dart:math';
import 'dart:ui';
import 'package:background_locator/background_locator.dart';
import 'package:background_locator/location_dto.dart';
import 'package:background_locator/location_settings.dart';
import 'package:flutter/material.dart';
import 'package:location_permissions/location_permissions.dart';
import 'package:xocorona/controller/acesso_controller.dart';
import 'package:xocorona/screens/home_out.dart';
import 'package:xocorona/screens/home_screen.dart';
import 'package:xocorona/screens/signup.dart';
import 'package:scoped_model/scoped_model.dart';
import 'charts/graficos_home.dart';
import 'file_manager.dart';
import 'themes/theme.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:xocorona/uteis/uteis.dart';


void main() => runApp(MaterialApp(
  home: Iniciar(),
  debugShowCheckedModeBanner: false,
));

class Iniciar extends StatefulWidget {
  @override
  _IniciarState createState() => _IniciarState();
}

class _IniciarState extends State<Iniciar> {
  ReceivePort port = ReceivePort();
  bool logado = false;
  String nome = "";
  bool _isAddingInviter = false;

  @override
  void initState() {
    super.initState();
    fetchLinkData();
    print("Teste de print");
    uteis.userLocalLogger().then((onValue) {
      setState(() {
        logged = onValue;
      });
    });


    IsolateNameServer.registerPortWithName(port.sendPort, 'LocatorIsolate');
    port.listen(
          (dynamic data) async {
        await setLog(data);
        await updateUI(data);
      },
      onError: (err) {
        print("Error log in dart: $err");
      },
      cancelOnError: false,
    );
    initPlatformState();
  }

  void fetchLinkData() async {
    // FirebaseDynamicLinks.getInitialLInk does a call to firebase to get us the real link because we have shortened it.
    var link = await FirebaseDynamicLinks.instance.getInitialLink();

    // This link may exist if the app was opened fresh so we'll want to handle it the same way onLink will.
    handleLinkData(link);

    // This will handle incoming links if the application is already opened
    FirebaseDynamicLinks.instance.onLink(onSuccess: (PendingDynamicLinkData dynamicLink) async {
      handleLinkData(dynamicLink);
    });
  }

  void handleLinkData(PendingDynamicLinkData data) {
    final Uri uri = data?.link;

    if(uri != null) {
      final queryParams = uri.queryParameters;
      if(queryParams.length > 0) {
        String inviterUID = queryParams["inviter"];
        // verify the inviter is parsed correctly
        print("#DEBUG My inviter UID is: $inviterUID");
        if (inviterUID != null && _isAddingInviter == false) {
          setState(() { _isAddingInviter = true; });
          confirmInviter(inviterUID);
//          setState(() { _isAddingInviter = false; });
        }
      }
    }
  }

  void confirmInviter(inviterUID) async {
    var userModel = UserModel();

    setState(() { _isAddingInviter = true; });
    if (await userModel.haveAnInviter() == false) {
      Map inviterData = await userModel.getUserDataByUID(inviterUID);
      if (inviterData != null) {
        var inviterNickName = inviterData['nickName'];
        var inviterEmail = inviterData['email'];
        print("#DEBUG inviterNickName: $inviterNickName / inviterEmail: $inviterEmail");

        _confirmInviterDialog(inviterNickName, inviterEmail);
//        setState(() { _isAddingInviter = false; });
      }
      else {
        print("ERROR Inviter or it's data not found");
      }
    }
    else {
      print("#DEBUG User already have an Inviter");
    }
    setState(() { _isAddingInviter = false; });
  }

  void _confirmInviterDialog(inviterNickName, inviterEmail) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ScopedModel<UserModel>(
            model: UserModel(),
            child: ScopedModelDescendant<UserModel>(builder: (context, child, model) {
              if (model.isLoading) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              return AlertDialog(
                  title: new Text("Convite"),
                  content: new Text(
                      "Você confirma que foi convidado por '$inviterNickName'?"),
                  actions: <Widget>[
                    FlatButton(child: Text('Não'), onPressed: () {
                      Navigator.of(context).pop();
                      setState(() { _isAddingInviter = false; });
                    }),
                    FlatButton(child: Text('Confirmar'), onPressed: () {
                      UserModel.of(context).setInviter(inviterEmail);
                      Navigator.of(context).pop();
                      setState(() { _isAddingInviter = false; });
                    }),
                  ],
                );
            }),
        );
      },
    );
  }

//  void initDynamicLinks() async {
//    final PendingDynamicLinkData data =
//    await FirebaseDynamicLinks.instance.getInitialLink();
//    final Uri deepLink = data?.link;
//
//    if (deepLink != null) {
//      Navigator.pushNamed(context, deepLink.path);
//    }
//
//    FirebaseDynamicLinks.instance.onLink(
//        onSuccess: (PendingDynamicLinkData dynamicLink) async {
//          final Uri deepLink = dynamicLink?.link;
//
//          if (deepLink != null) {
//            Navigator.pushNamed(context, deepLink.path);
//          }
//        }, onError: (OnLinkErrorException e) async {
//      print('onLinkError');
//      print(e.message);
//    });
//  }
//
//  Future<void> _createDynamicLink(bool short) async {
//    setState(() {
//      _isCreatingLink = true;
//    });
//
//    final DynamicLinkParameters parameters = DynamicLinkParameters(
//      uriPrefix: 'https://xocorona.com.br/',
//      link: Uri.parse('https://xocorona.page.link/'),
//      androidParameters: AndroidParameters(
//        packageName: 'br.xocorona',
//        minimumVersion: 0,
//      ),
//      dynamicLinkParametersOptions: DynamicLinkParametersOptions(
//        shortDynamicLinkPathLength: ShortDynamicLinkPathLength.short,
//      ),
//      iosParameters: IosParameters(
//        bundleId: 'br.nudgecovid19',
//        minimumVersion: '0',
//      ),
//    );
//
//    Uri url;
//    if (short) {
//      final ShortDynamicLink shortLink = await parameters.buildShortLink();
//      url = shortLink.shortUrl;
//    } else {
//      url = await parameters.buildUrl();
//    }
//
//    setState(() {
//      _linkMessage = url.toString();
//      _isCreatingLink = false;
//    });
//  }
  String logStr = '';

  bool isRunning = true;
  LocationDto lastLocation;
  DateTime lastTimeLocation;


  @override
  void dispose() {
    IsolateNameServer.removePortNameMapping('LocatorIsolate');
    super.dispose();
  }

  static double dp(double val, int places) {
    double mod = pow(10.0, places);
    return ((val * mod).round().toDouble() / mod);
  }

  static String formatDateLog(DateTime date) {
    return date.hour.toString() +
        ":" +
        date.minute.toString() +
        ":" +
        date.second.toString();
  }

  static String formatLog(LocationDto locationDto) {
    return dp(locationDto.latitude, 4).toString() +
        " " +
        dp(locationDto.longitude, 4).toString();
  }

  Future<void> setLog(LocationDto data) async {
    final date = DateTime.now();
    await FileManager.writeToLogFile(
        '${formatDateLog(date)} --> ${formatLog(data)}\n');
  }

  Future<void> updateUI(LocationDto data) async {
    final log = await FileManager.readLogFile();
    setState(() {
      lastLocation = data;
      lastTimeLocation = DateTime.now();
      logStr = log;
    });
  }

  Future<void> initPlatformState() async {
    print('Initializing...');
   await BackgroundLocator.initialize();
    logStr = await FileManager.readLogFile();
    print('Initialization done');
    final _isRunning = await BackgroundLocator.isRegisterLocationUpdate();
    setState(() {
      isRunning = _isRunning;
    });
    print('Running ${isRunning.toString()}');


  }

  static void callback(LocationDto locationDto) async {
    print('location in dart: ${locationDto.toString()}');
    final SendPort send = IsolateNameServer.lookupPortByName('LocatorIsolate');
    send?.send(locationDto);
  }

  static void notificationCallback() {
    print('notificationCallback');
  }
  Uteis uteis = new Uteis();
  bool logged = null;

  @override
  Widget build(BuildContext context) {
     _checkLocationPermission();
    return
            logged == null ? Container(
              width: 50,
              height: 50,
              child: CircularProgressIndicator(),
            ) :
            MaterialApp(
              title: 'Xô Corona!',
              theme: ThemaCovid().getThema(),
              debugShowCheckedModeBanner: false,
              home: logged ? HomeScreen(1) : SignUp(),
            );
  }

  void _checkLocationPermission() async {
    final access = await LocationPermissions().checkPermissionStatus();
    switch (access) {
      case PermissionStatus.unknown:
      case PermissionStatus.denied:
      case PermissionStatus.restricted:
        final permission = await LocationPermissions().requestPermissions(
          permissionLevel: LocationPermissionLevel.locationAlways,
        );
        if (permission == PermissionStatus.granted) {
          _startLocator();
        } else {
          // nao deu
        }
        break;
      case PermissionStatus.granted:
        _startLocator();
        break;
    }
  }

  // this must be called to start
  void _startLocator() {
    BackgroundLocator.registerLocationUpdate(
      callback,
      androidNotificationCallback: notificationCallback,
      settings: LocationSettings(
        notificationTitle: "Start Location Tracking example",
        notificationMsg: "Track location in background example",
        wakeLockTime: 20,
        autoStop: false,
      ),
    );
    setState(() {
      isRunning = true;
    });
  }
}