import 'package:flutter/material.dart';
import 'bmi_lab.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BMI Calculator',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'BMI Calculator'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState(
      ) => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController bmiController = TextEditingController();

  List<bmi_lab> bmi = [];

  String _colStatus  = "";
  String _colGender  = "";

  _addBMI() async {
    if (_colGender  != "Male" && _colGender  != "Female") {
      Future.delayed(Duration.zero, () {
        ScaffoldMessenger.of(context as BuildContext).showSnackBar(
          SnackBar(
            content: Text('Invalid gender!'),
          ),
        );
      });
      return;
    }

    var bmi = bmi_lab(fullNameController.text, double.parse(heightController.text),
        double.parse(weightController.text), _colGender, "");

    double height = bmi.height / 100;

    var bmiMaleFemale = bmi.weight / (height * height);

    setState(() {
      bmiController.text = bmiMaleFemale.toString();

      if (bmi.gender == "Male") {
        if (bmiMaleFemale < 18.5) {
          _colStatus = "Underweight. Careful during strong wind!";
        } else if (bmiMaleFemale >= 18.5 && bmiMaleFemale < 25) {
          _colStatus = "That’s ideal! Please maintain";
        } else if (bmiMaleFemale >= 25 && bmiMaleFemale < 30) {
          _colStatus = "Overweight! Work out please";
        } else {
          _colStatus = "Whoa Obese! Dangerous mate!";
        }
      } else {
        if (bmiMaleFemale < 16) {
          _colStatus = "Underweight. Careful during strong wind!";
        } else if (bmiMaleFemale >= 16 && bmiMaleFemale < 22) {
          _colStatus = "That’s ideal! Please maintain";
        } else if (bmiMaleFemale >= 22 && bmiMaleFemale < 27) {
          _colStatus = "Overweight! Work out please";
        } else {
          _colStatus = "Whoa Obese! Dangerous mate!";
        }
      }
    });

    bmi.status = _colStatus;

    await bmi.save();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      bmi.addAll(await bmi_lab.loadAll());

      if (bmi.isNotEmpty) {
        var totalbmi = bmi[bmi.length - 1];
        fullNameController.text = totalbmi.username;
        heightController.text = totalbmi.height.toString();
        weightController.text = totalbmi.weight.toString();
        double height = totalbmi.height / 100;
        var bmiValue = totalbmi.weight / (height * height);
        bmiController.text = bmiValue.toString();
        setState(() {
          _colGender = totalbmi.gender;
          _colStatus = totalbmi.status;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),

        body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Column(
                children: [
                  TextField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10))
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.teal, width: 2.0),
                        ),
                        disabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey, width: 2.0),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.teal, width: 4.0),
                        ),
                        labelText: "Your Full Name"),
                    controller: fullNameController,
                  ),
                  SizedBox(
                    //Use of SizedBox
                    height: 30,
                  ),
                  TextField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10))
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.teal, width: 2.0),
                        ),
                        disabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey, width: 2.0),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.teal, width: 4.0),
                        ),
                        labelText: "Height in cm; 170"),

                    controller: heightController,
                  ),
                  SizedBox(
                    //Use of SizedBox
                    height: 30,
                  ),
                  TextField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10))
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.teal, width: 2.0),
                        ),
                        disabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey, width: 2.0),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.teal, width: 4.0),
                        ),
                        labelText: "Weight in KG"),
                    controller: weightController,
                  ),
                  SizedBox(
                    //Use of SizedBox
                    height: 30,
                  ),
                  TextField(
                    decoration: InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: "BMI value"),
                    controller: bmiController,
                    enabled: false,
                  ),
                  SizedBox(
                    //Use of SizedBox
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: RadioListTile<String>(
                          title: const Text('Male'),
                          value: 'Male',
                          groupValue: _colGender,
                          onChanged: (value) {
                            setState(() {
                              _colGender = value!;
                            });
                          },
                        ),
                      ),
                      Expanded(
                        child: RadioListTile<String>(
                          title: const Text('Female'),
                          value: 'Female',
                          groupValue: _colGender,
                          onChanged: (value) {
                            setState(() {
                              _colGender = value!;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    //Use of SizedBox
                    height: 30,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        _addBMI();
                      },
                      child: Text("Caculate BMI and Save")),
                  Text(
                    "$_colStatus",
                    style: TextStyle(fontSize: 20),
                  )
                ],
              ),
            ),
            ));
    }
}