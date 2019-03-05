import 'dart:async';
import 'package:clash_royale_client/model/player.dart';
import 'package:clash_royale_client/store/redux.dart';
import 'package:clash_royale_client/views/home/main.dart';
import 'package:clash_royale_client/views/login/login.dart';
import 'package:flutter/material.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:redux/redux.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

final store = new Store<AppState>(appReducer,
    initialState: new AppState(
      player: Player.empty()
    ));

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
        store: store,
        child: new DynamicTheme(
            defaultBrightness: Brightness.light,
            data: (brightness) => new ThemeData(
                  primarySwatch: Colors.indigo,
                  brightness: brightness,
                ),
            themedWidgetBuilder: (context, theme) {
              return new MaterialApp(
                title: 'Flutter Demo',
                theme: theme,
                home: MainPage(),
              );
            }));
  }
}

class MainPage extends StatefulWidget {
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  var _result;

  Future<String> getUserTag() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('UserTag');
  }

  @override
  void initState() {
    super.initState();
    getUserTag().then((onValue) {
      setState(() {
        _result = onValue;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_result == null) {
      return LoginPage();
    }
    return HomeState();
  }
}
