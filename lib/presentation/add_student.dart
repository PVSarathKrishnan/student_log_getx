// ignore_for_file: prefer_final_fields, prefer_const_constructors

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:student_log_getx/data/models/student_model.dart';
import 'package:student_log_getx/presentation/home_page.dart';
import 'package:student_log_getx/presentation/utilities/validators.dart';
import 'package:student_log_getx/presentation/student_list.dart';
import 'package:student_log_getx/services/db_functions.dart';
import 'package:student_log_getx/services/student_helper.dart';

class AddStudentPage extends StatefulWidget {
  AddStudentPage({super.key, required this.isEdit, this.stu});

  bool isEdit = false;
  StudentModel? stu;

  @override
  State<AddStudentPage> createState() => _AddStudentPageState();
}

class _AddStudentPageState extends State<AddStudentPage> {
  DbFunctions dbhelper = DbFunctions();
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _emailController = TextEditingController();
  final gender = ['male', 'female', 'others'];
  String selGender = '';
  final domainList = [
    'MERN - web development',
    'MEAN - web development',
    'Django and React',
    'Mobile development using Flutter',
    'Data Science',
    'Cyber security'
  ];
  String selDomain = '';
  DateTime dob = DateTime.now();
  String? d;
  DateTime? db;

  final controller = Get.put(StudentGetX());

  @override
  Widget build(BuildContext context) {
    if (widget.isEdit) {
      controller.profileImage?.value = widget.stu!.photo;
      _nameController.text = widget.stu!.name;
      controller.gender?.value = widget.stu!.gender;
      controller.domain?.value = widget.stu!.domain;
      db = DateTime.parse(widget.stu!.dob);
      _mobileController.text = widget.stu!.mobile;
      _emailController.text = widget.stu!.email;
    }
    return Scaffold(
      appBar: AppBar(
        title: widget.isEdit
            ? Text(
                'Edit Student',
                style: GoogleFonts.b612Mono(),
              )
            : Text(
                'Add Student',
                style: GoogleFonts.b612Mono(),
              ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Obx(() {
                return GestureDetector(
                  onTap: () async {
                    controller.getImage();
                  },
                  child: Container(
                      height: 180,
                      width: 180,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          border: Border.all(width: 1)),
                      child: ClipOval(
                        // ignore: unrelated_type_equality_checks
                        child: controller.profileImage != ""
                            ? Image.file(
                                File(controller.profileImage.toString()),
                                filterQuality: FilterQuality.high,
                                fit: BoxFit.contain,
                              )
                            : Icon(Icons.add_photo_alternate_outlined),
                      )),
                );
              }),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: _nameController,
                validator: Validators.validateFullName,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: InputDecoration(
                  labelText: 'Name',
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide:
                        BorderSide(color: Colors.grey.shade400, width: 1.0),
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              TextFormField(
                controller: _emailController,
                validator: Validators.validateEmail,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: InputDecoration(
                  labelText: 'Email',
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide:
                        BorderSide(color: Colors.grey.shade400, width: 1.0),
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              TextFormField(
                controller: _mobileController,
                validator: Validators.validateMobile,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: InputDecoration(
                  labelText: 'Mobile',
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide:
                        BorderSide(color: Colors.grey.shade400, width: 1.0),
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              Text(
                'Gender',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10.0),
              Obx(
                () => Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: gender.map((String value1) {
                          return Container(
                            margin: const EdgeInsets.only(right: 8.0),
                            child: Column(
                              children: [
                                Text(
                                  value1,
                                  style: const TextStyle(
                                    fontSize: 12,
                                  ),
                                ),
                                Radio(
                                  value: value1,
                                  groupValue: controller.gender!.value,
                                  onChanged: (selectedValue) {
                                    selGender = selectedValue.toString();
                                    controller.getGender(selGender);
                                  },
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              Text(
                'Domain:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10.0),
              DropdownButtonFormField(
                  // value: controller.domain?.value, // exception happening!!
                  validator: (value) {
                    if (value == null) {
                      return "select Domain";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                      hintText: 'Domain',
                      focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              width: 1,
                              color: Color.fromRGBO(117, 185, 237, 1)),
                          borderRadius: BorderRadius.circular(10.0)),
                      enabledBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(width: 1, color: Colors.black),
                          borderRadius: BorderRadius.circular(10.0))),
                  items: domainList.map((String domain) {
                    return DropdownMenuItem(value: domain, child: Text(domain));
                  }).toList(),
                  onChanged: (String? domain) {
                    controller.getDomain(domain!);
                  }),
              SizedBox(height: 20.0),
              Column(
                children: [
                  Text("Date Of Birth",
                      style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
                  SizedBox(height: 10.0),
                  Obx(
                    () => Container(
                      width: 180,
                      child: TextButton(
                        onPressed: () {
                          showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1973),
                            lastDate: DateTime(2025),
                          ).then((value) => controller.getDOB(value!));
                        },
                        style: ButtonStyle(
                          overlayColor: MaterialStateColor.resolveWith(
                            (states) =>
                                Colors.transparent, // Remove overlay color
                          ),
                          side: MaterialStateBorderSide.resolveWith(
                            (states) => const BorderSide(
                                color: Colors.grey), // Add outline border
                          ),
                          padding: MaterialStateProperty.resolveWith(
                            (states) => const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12), // Add padding
                          ),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  10.0), // Add rounded corners
                            ),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.calendar_today_outlined,
                              color: Colors.blue, // Customize icon color
                            ),
                            const SizedBox(
                                width:
                                    8), // Add some spacing between icon and text
                            Text(
                              DateFormat('dd-MM-yyyy').format(
                                DateTime.parse(
                                    controller.dateOfBirth.toString()),
                              ),
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black, // Customize text color
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              widget.isEdit
                  ? ElevatedButton.icon(
                      onPressed: () {
                        edit(db =
                            DateTime.parse(controller.dateOfBirth.toString()));
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.deepPurple),
                        elevation: MaterialStateProperty.all<double>(3),
                        shape: MaterialStateProperty.all<OutlinedBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                          EdgeInsets.symmetric(
                              vertical: 15.0, horizontal: 40.0),
                        ),
                      ),
                      icon: Icon(
                        Icons.update,
                        color: Colors.white,
                        size: 25,
                      ),
                      label: Text(
                        "Update",
                        style: GoogleFonts.poppins(
                            fontSize: 22,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ))
                  : ElevatedButton.icon(
                      onPressed: () {
                        submit(db =
                            DateTime.parse(controller.dateOfBirth.toString()));
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.deepPurple),
                        elevation: MaterialStateProperty.all<double>(3),
                        shape: MaterialStateProperty.all<OutlinedBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                          EdgeInsets.symmetric(
                              vertical: 15.0, horizontal: 40.0),
                        ),
                      ),
                      icon: Icon(
                        Icons.save,
                        color: Colors.white,
                        size: 25,
                      ),
                      label: Text("Register",
                          style: GoogleFonts.poppins(
                              fontSize: 22,
                              color: Colors.white,
                              fontWeight: FontWeight.bold)))
            ],
          ),
        ),
      ),
    );
  }

// ...
  Future<void> submit(DateTime? db) async {
    var imagePath = controller.profileImage!.value;
    final name = _nameController.text.trim();
    var gender = controller.gender!.value;
    final domain = controller.domain!.value;
    final dob = db?.toString();
    final mobile = _mobileController.text.trim();
    final email = _emailController.text.trim();

    if (_formKey.currentState?.validate() ?? false) {
      if (imagePath != null && dob != null) {
        final student = StudentModel(
          photo: imagePath,
          name: name,
          gender: gender,
          domain: domain!,
          dob: dob,
          mobile: mobile,
          email: email,
        );
        dbhelper.addStudent(student);
        controller.profileImage?.value = '';
        controller.gender?.value = '';
        Get.snackbar("Successful", "Student registered");
        Get.off(const HomePage());
      } else {
        Get.snackbar("Error", "Not registered");
      }
    } else {
      Get.snackbar("Error", "Not registered");
    }
  }

  Future<void> edit(DateTime? db) async {
    int? id = widget.stu!.id;
    final imagePath = controller.profileImage?.value;
    final name = _nameController.text.trim();
    final gender = controller.gender!.value;
    final domain = controller.domain!.value;
    final dob = db?.toString();
    final mobile = _mobileController.text.trim();
    final email = _emailController.text.trim();

    print('ImagePath: $imagePath');
    print('DOB: $domain');
    print('email: $email');
    print('name: $name');
    print('id: $id');
    print('g: $gender');
    print('dob: $dob');
    print('mob: $mobile');

    if (_formKey.currentState?.validate() ?? false) {
      if (imagePath != null &&
          name.isNotEmpty &&
          gender.isNotEmpty &&
          domain != null &&
          dob != null &&
          mobile.isNotEmpty &&
          email.isNotEmpty) {
        dbhelper.editStudent(
            id!, imagePath, name, gender, domain, dob, mobile, email);
        Get.off(const StudentList());
      } else {
        Get.snackbar("Error", "Enter all data");
      }
    } else {
      Get.snackbar("Error", "Add all data ");
    }
  }
}
