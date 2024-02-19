// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

import 'package:student_log_getx/data/models/student_model.dart';
import 'package:student_log_getx/presentation/add_student.dart';
import 'package:student_log_getx/presentation/home_page.dart';
import 'package:student_log_getx/services/db_functions.dart';

class StudentList extends StatefulWidget {
  const StudentList({super.key});

  @override
  State<StudentList> createState() => _StudentListState();
}

class _StudentListState extends State<StudentList> {
  @override
  void initState() {
    controller.getStudents();
    super.initState();
  }

  final SearchController = TextEditingController();
  String searchText = '';
  Timer? debouncer;

  final controller = Get.put(DbFunctions());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("student list"),
          leading: IconButton(
              onPressed: () {
                Get.off(HomePage());
              },
              icon: Icon(
                Icons.arrow_back,
              ))),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: TextFormField(
                controller: SearchController,
                onChanged: (value) {
                  onSearchChange(value);
                },
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    hintText: "Search name",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25))),
              ),
            ),
            SizedBox(
              height: 600,
              child: controller.studentList.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.network(
                            'https://assets-v2.lottiefiles.com/a/435a7e80-1153-11ee-a46f-7f1c0e4a511a/ePxvZATa5E.gif',
                            height: 200,
                          ),
                        ],
                      ),
                    )
                  : Obx(
                      () => ListView.separated(
                          itemBuilder: ((context, index) {
                            final data = controller.studentList[index];
                            return Slidable(
                              endActionPane: ActionPane(
                                motion: const DrawerMotion(),
                                children: [
                                  SlidableAction(
                                    onPressed: (context) {
                                      Get.to(AddStudentPage(
                                        isEdit: true,
                                        stu: data,
                                      ));
                                    },
                                    icon: Icons.edit,
                                    backgroundColor: Colors.lightBlue,
                                  ),
                                ],
                              ),
                              startActionPane: ActionPane(
                                  motion: const DrawerMotion(),
                                  children: [
                                    SlidableAction(
                                        onPressed: (context) {
                                          controller.deleteStudent(data.id!);
                                        },
                                        icon: Icons.delete,
                                        backgroundColor: Colors.red)
                                  ]),
                              child: ListTile(
                                onTap: () {
                                  //Navigator.push(context, MaterialPageRoute(builder: (context) => DetailsPage( id: index,),));
                                  detailsSheet(
                                      context,
                                      data.id!,
                                      data.photo,
                                      data.name,
                                      data.gender,
                                      data.domain,
                                      data.dob,
                                      data.mobile,
                                      data.email);
                                },
                                leading: CircleAvatar(
                                  radius: 40,
                                  backgroundImage: FileImage(File(data.photo)),
                                ),
                                title: Text(
                                  data.name,
                                  style: GoogleFonts.dmMono(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(
                                  data.domain,
                                  style: GoogleFonts.dmMono(
                                      fontSize: 18,
                                      fontWeight: FontWeight.normal),
                                  maxLines: 1,
                                ),
                              ),
                            );
                          }),
                          separatorBuilder: ((context, index) {
                            return Divider();
                          }),
                          itemCount: controller.studentList.length),
                    ),
            )
          ],
        ),
      ),
    );
  }

  void detailsSheet(BuildContext context, int id, String photo, String name,
      String gender, String domain, String dob, String mobile, String email) {
    Get.bottomSheet(Container(
      height: 350,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 40,
              backgroundImage: FileImage(File(photo)),
            ),
            const SizedBox(height: 10),
            Text(
              "Name: $name",
              style: textStyle(),
            ),
            Text(
              "Gender: $gender",
              style: textStyle(),
            ),
            Text(
              "Domain: $domain",
              style: textStyle(),
            ),
            Text(
              "Date of Birth: ${DateFormat('dd-MMM-yyyy').format(DateTime.parse(dob))}",
              style: textStyle(),
            ),
            Text(
              "Mobile: $mobile",
              style: textStyle(),
            ),
            Text(
              "Email: $email",
              style: textStyle(),
            ),
          ],
        ),
      ),
    ));
  }

  onSearchChange(String value) {
    final studendb = Hive.box<StudentModel>('student_db');
    final students = studendb.values.toList();
    value = SearchController.text;

    if (debouncer?.isActive ?? false) debouncer?.cancel();
    debouncer = Timer(const Duration(milliseconds: 250), () {
      if (this.searchText != SearchController) {
        final filteredStudents = students
            .where((students) =>
                students.name.toLowerCase().contains(value.toLowerCase()))
            .toList();
        controller.studentList.value = filteredStudents;
      }
    });
  }

  TextStyle textStyle() {
    return GoogleFonts.dmMono(fontSize: 22);
  }
}
