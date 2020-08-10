import 'package:flutter/material.dart';
import 'package:vetwork_app/src/providers/preference_data_provider.dart';
import 'package:vetwork_app/src/screens/dev_settings.dart';
import 'package:vetwork_app/src/screens/my_profile.dart';
import '../fonts.dart';
import '../screens/change_language.dart';
import '../screens/my_pets.dart';

// contaiet drawer
Widget contentDrawer(context, String name) {

  PreferenceDataProvider prefsDataProvider = PreferenceDataProvider();
  Color home = Colors.blueGrey;
  Color profile = Colors.blueGrey;
  Color pets = Colors.blueGrey;
  Color history = Colors.blueGrey;
  Color offers = Colors.blueGrey;
  Color request = Colors.blueGrey;
  Color terms = Colors.blueGrey;
  Color help = Colors.blueGrey;
  Color contact = Colors.blueGrey;
  Color black = Colors.black;

  if (name == "home") {
    home = Colors.blueAccent;
  }
  if (name == "profile") {
    home = Colors.blueAccent;
  }
  if (name == "pets") {
    home = Colors.blueAccent;
  }
  if (name == "history") {
    home = Colors.blueAccent;
  }
  if (name == "offers") {
    home = Colors.blueAccent;
  }
  if (name == "request") {
    home = Colors.blueAccent;
  }
  if (name == "terms") {
    home = Colors.blueAccent;
  }
  if (name == "help") {
    home = Colors.blueAccent;
  }
  if (name == "contact") {
    home = Colors.blueAccent;
  }
//  if (name == "dev") {
//    home = Colors.blueAccent;
//  }blueAccent

  return SizedBox(
    width: MediaQuery.of(context).size.width / 1.5,
    child: Drawer(
      child: ListView(
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              IconButton(
                  icon: Icon(
                    Icons.close,
                    size: 40,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  }),

              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),

              ),
            ],
          ),
          ListTile(
            title: FutureBuilder(
              future: prefsDataProvider.getLabelFromKey("home"),
              builder: (context, snapshot) {
                if (snapshot.hasData)
                  return Text(
                    snapshot.data,
                    style: TextStyle(color: home),
                  );
                return Container();
              },
            ),
            leading: Icon(
              Icons.account_balance,
              color: black,
            ),
            onTap: () {},
          ),
          ListTile(
            title: FutureBuilder(
              future: prefsDataProvider.getLabelFromKey("my_profile"),
              builder: (context, snapshot) {
                if (snapshot.hasData)
                  return Text(
                    snapshot.data,
                    style: TextStyle(color: profile),
                  );
                return Container();
              },
            ),
            leading: Icon(
              Icons.person_pin,
              color: black,
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => MyProfile()));
            },
          ),
          ListTile(
            title: FutureBuilder(
              future: prefsDataProvider.getLabelFromKey("my_pets"),
              builder: (context, snapshot) {
                if (snapshot.hasData)
                  return Text(
                    snapshot.data,
                    style: TextStyle(color: pets),
                  );
                return Container();
              },
            ),
            leading: Icon(
              Icons.pets,
              color: black,
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => MyPets()));
            },
          ),
          ListTile(
            title: FutureBuilder(
              future: prefsDataProvider.getLabelFromKey("history"),
              builder: (context, snapshot) {
                if (snapshot.hasData)
                  return Text(
                    snapshot.data,
                    style: TextStyle(color: history),
                  );
                return Container();
              },
            ),
            leading: Icon(
              Icons.history,
              color: Colors.black,
            ),
            onTap: () {},
          ),
          ListTile(
            title: FutureBuilder(
              future: prefsDataProvider.getLabelFromKey("offers"),
              builder: (context, snapshot) {
                if (snapshot.hasData)
                  return Text(
                    snapshot.data,
                    style: TextStyle(color: offers),
                  );
                return Container();
              },
            ),
            leading: Icon(
              Icons.star_half,
              color: Colors.black,
            ),
            onTap: () {},
          ),
          ListTile(
            title: FutureBuilder(
              future: prefsDataProvider.getLabelFromKey("request_services"),
              builder: (context, snapshot) {
                if (snapshot.hasData)
                  return Text(
                    snapshot.data,
                    style: TextStyle(color: request),
                  );
                return Container();
              },
            ),
            leading: Icon(
              Icons.star_half,
              color: Colors.black,
            ),
            onTap: () {},
          ),
          Divider(
            color: Colors.grey.shade300,
            height: 1.0,
          ),
          ListTile(
            title: FutureBuilder(
              future: prefsDataProvider.getLabelFromKey("terms_and_conditions"),
              builder: (context, snapshot) {
                if (snapshot.hasData)
                  return Text(
                    snapshot.data,
                    style: TextStyle(color: terms),
                  );
                return Container();
              },
            ),
            leading: Icon(
              Icons.assignment,
              color: black,
            ),
            onTap: () {},
          ),
          ListTile(
            title:  FutureBuilder(
              future: prefsDataProvider.getLabelFromKey("help"),
              builder: (context, snapshot) {
                if (snapshot.hasData)
                  return Text(
                    snapshot.data,
                    style: TextStyle(color: help),
                  );
                return Container();
              },
            ),
            leading: Icon(
              Icons.help,
              color: Colors.black,
            ),
            onTap: () {},
          ),
          ListTile(
            title:  FutureBuilder(
              future: prefsDataProvider.getLabelFromKey("change_laungueg"),
              builder: (context, snapshot) {
                if (snapshot.hasData)
                  return Text(
                    snapshot.data,
                    style: TextStyle(color: black),
                  );
                return Container();
              },
            ),
            leading: Icon(
              Icons.translate,
              color: Colors.black,
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ChangeLanguage()));
            },
          ),
          ListTile(
            title: FutureBuilder(
              future: prefsDataProvider.getLabelFromKey("contact_us"),
              builder: (context, snapshot) {
                if (snapshot.hasData)
                  return Text(
                    snapshot.data,
                    style: TextStyle(color: contact),
                  );
                return Container();
              },
            ),
            leading: Icon(
              Icons.markunread,
              color: Colors.black,
            ),
            onTap: () {},
          ),
//          ListTile(
//            title:FutureBuilder(
//              future: prefsDataProvider.getLabelFromKey("dev_setting"),
//              builder: (context, snapshot) {
//                if (snapshot.hasData)
//                  return Text(
//                    snapshot.data,
//                    style: TextStyle(color: black),
//                  );
//                return Container();
//              },
//            ),
//            leading: Icon(
//              Icons.markunread,
//              color: Colors.black,
//            ),
//            onTap: () {
////              Navigator.pop(context);
////              Navigator.push(context,
////                  MaterialPageRoute(builder: (context) => DevSettings()));
//            },
//          ),
        ],
      ),
    ),
  );
}
