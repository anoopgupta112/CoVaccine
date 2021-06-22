import 'dart:convert';
import 'dart:html';

import 'package:book_vaccine/slots.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(brightness: Brightness.light, primaryColor: Colors.teal),
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

// ----------------------------------------------

class _HomeState extends State<Home> {
  String dropdownValue = '01';
  List slots = [];
  TextEditingController pincodecontroller = TextEditingController();
  TextEditingController daycodecontroller = TextEditingController();
  // for validation
  final _formKey = GlobalKey<FormState>();
// ----------------------------------------------------------------
  fetchslots() async {
    if (_formKey.currentState.validate()) {
      await http
          .get(Uri.parse(
              'https://cdn-api.co-vin.in/api/v2/appointment/sessions/public/findByPin?pincode=' +
                  pincodecontroller.text +
                  '&date=' +
                  daycodecontroller.text +
                  '%2F' +
                  dropdownValue +
                  '%2F2021'))
          .then((value) {
        Map result = jsonDecode(value.body);

        setState(() {
          slots = result['sessions'];
          print(result);
        });

        Navigator.push(context,
            MaterialPageRoute(builder: (context) => Slot(slots: slots)));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Vaccine book"),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(10),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.zero,
                  width: MediaQuery.of(context).size.width,
                  height: 250,

                  // child: Image.asset("lib/assets/vaccine.png"),

                  // -------we want to use image from network------------
                  child: Image.network(
                    "https://images.rawpixel.com/image_png_800/czNmcy1wcml2YXRlL3Jhd3BpeGVsX2ltYWdlcy93ZWJzaXRlX2NvbnRlbnQvcGYtczc3LXRlZC0xMTk3LWV5ZS1qai5wbmc.png?s=nkxqirK_E13zHC3jJm3zN7nAqgNPOkco2iZf9OxeBkE",
                    fit: BoxFit.fill,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: pincodecontroller,
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  decoration: InputDecoration(hintText: "Enter PIN code"),
                  validator: (value) {
                    if (value.isEmpty) {
                      return "user name should be enter";
                    }
                    {
                      return null;
                    }
                  },
                ),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 60,
                        child: TextFormField(
                          controller: daycodecontroller,
                          decoration: InputDecoration(hintText: "Enter Date"),
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Please enter Date";
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 12,
                    ),
                    Expanded(
                        child: DropdownButton<String>(
                      value: dropdownValue,
                      iconSize: 24,
                      elevation: 16,
                      underline:
                          Container(height: 1, color: Colors.grey.shade400),
                      onChanged: (String newValue) {
                        setState(() {
                          dropdownValue = newValue;
                        });
                      },
                      items: <String>[
                        '01',
                        '02',
                        '03',
                        '04',
                        '05',
                        '06',
                        '07',
                        '08',
                        '09',
                        '10',
                        '11',
                        '12'
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ))
                  ],
                ),
                SizedBox(
                  height: 22,
                ),
                AnimatedContainer(
                  duration: Duration(seconds: 2),
                  height: 45,
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            Theme.of(context).primaryColor)),
                    onPressed: () {
                      fetchslots();
                    },
                    child: Text("find slots"),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
