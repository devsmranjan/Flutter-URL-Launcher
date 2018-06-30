import 'dart:async';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'URL Launcher',
      theme: new ThemeData(
        primarySwatch: Colors.red,
      ),
      home: new MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  TextEditingController textEditingController =
  new TextEditingController(text: "https://");
  Future _launched;

  Future<Null> _launchInBrowser(String url) async {
    if (await canLaunch(url)) {
      await launch(url, forceSafariVC: false, forceWebView: false);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<Null> _launchInWebViewOrVC(String url) async {
    if (await canLaunch(url)) {
      await launch(url, forceSafariVC: true, forceWebView: true);
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget _launchStatus(BuildContext context, AsyncSnapshot<Null> snapshot) {
    if (snapshot.hasError) {
      return new Text('Error: ${snapshot.error}');
    } else {
      return const Text('');
    }
  }

  @override
  Widget build(BuildContext context) {
    String toLaunch;
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("URL Launcher"),
      ),
      body: new Center(
        child: Form(
          key: _formKey,
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Padding(
                padding: new EdgeInsets.all(16.0),
                child: new TextFormField(
                  controller: textEditingController,
//                  initialValue: 'https://',
                  textAlign: TextAlign.center,
                  decoration: new InputDecoration(
                    hintText: "Enter your url",
                  ),
                ),
              ),
              new RaisedButton(
                onPressed: () => setState(() {
                  if (_formKey.currentState.validate()) {
                    setState(() {
                      toLaunch = textEditingController.text;
                    });
                    _launched = _launchInBrowser(toLaunch);
                  }
                }),
                child: const Text('Launch in browser'),
              ),
              const Padding(padding: const EdgeInsets.all(16.0)),
              new RaisedButton(
                onPressed: () => setState(() {
                  if (_formKey.currentState.validate()) {
                    setState(() {
                      toLaunch = textEditingController.text;
                    });
                    _launched = _launchInWebViewOrVC(toLaunch);
                  }
                }),
                child: const Text('Launch in app'),
              ),
              const Padding(padding: const EdgeInsets.all(16.0)),
//            new FutureBuilder<Null>(future: _launched, builder: _launchStatus),
            ],
          ),
        ),
      ),
    );
  }
}
