// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:student_log_getx/presentation/add_student.dart';
import 'package:student_log_getx/presentation/student_list.dart';
import 'package:student_log_getx/services/db_functions.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    controller.getStudents();
    super.initState();
  }

  final controller = Get.put(DbFunctions());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Student Log - GetX"),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(children: [
            SizedBox(
              height: 200,
            ),
            Image.network(
              "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQmaCk6Pf7Z8CdhodYhpnehiGNGnbm18bGeBVKlEXGJqMGjQirBlkn7y_fqtMdzlRQazOU&usqp=CAU",
              height: 85,
              width: 150,
              fit: BoxFit.fill,
            ),
            SizedBox(
              height: 20,
            ),
            Container(
                width: 250,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddStudentPage(
                            isEdit: false,
                          ),
                        ));
                  },
                  style: ButtonTheme(),
                  child: Text(
                    'Add Student',
                    style: GoogleFonts.ptMono(
                      fontSize: 25,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )),
            SizedBox(
              height: 20,
            ),
            Container(
                width: 250,
                child: ElevatedButton(
                  onPressed: () {
                    Get.to(const StudentList());
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        const Color.fromARGB(255, 0, 0, 0)),
                    elevation: MaterialStateProperty.all<double>(8),
                    shape: MaterialStateProperty.all<OutlinedBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                    ),
                    padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                      EdgeInsets.symmetric(vertical: 15.0, horizontal: 40.0),
                    ),
                  ),
                  child: Text(
                    'View Database',
                    style: GoogleFonts.ptMono(
                      fontSize: 25,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ))
          ]),
        ),
      ),
    );
  }

  ButtonStyle ButtonTheme() {
    return ButtonStyle(
      backgroundColor:
          MaterialStateProperty.all<Color>(const Color.fromARGB(255, 0, 0, 0)),
      elevation: MaterialStateProperty.all<double>(8),
      shape: MaterialStateProperty.all<OutlinedBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0),
        ),
      ),
      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
        EdgeInsets.symmetric(vertical: 15.0, horizontal: 40.0),
      ),
    );
  }
}
