
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:student_log_getx/data/models/student_model.dart';

class DbFunctions extends GetxController{
  
RxList studentList = [].obs;

Future<void> addStudent(StudentModel value) async {
  final studentdb = await Hive.openBox<StudentModel>('student_db');
  final id = await studentdb.add(value);
  final data = studentdb.get(id);
  await studentdb.put(id, StudentModel(
    id: id,
    photo: data!.photo, 
    name: data.name, 
    gender: data.gender, 
    domain: data.domain, 
    dob: data.dob, 
    mobile: data.mobile, 
    email: data.email,
    ));
    // print(data.email);
    // print(studentdb.values);
}

Future<void> getStudents() async{
  final studentdb = await Hive.openBox<StudentModel>('student_db');
  studentList.value.clear();
  studentList.value.addAll(studentdb.values);
  studentList.value.sort((a,b)=>a.name.compareTo(b.name));
  studentList.refresh();
}

// Future<int> studentCount() async{
//   final studentdb = await Hive.openBox<StudentModel>('student_db');
//   final studentcount = studentdb.length;
//   print(studentcount);
//   return studentcount;
// }

Future<int> studentCount() async{
  final studentdb = await Hive.openBox<StudentModel>('student_db');
  final studentcount = studentdb.length;
  // print(studentcount);
  return studentcount;
}


Future<void> deleteStudent(int id)async{
  final studentdb = await Hive.openBox<StudentModel>('student_db');
  await studentdb.delete(id);
  getStudents();
}

Future<void> editStudent(
  int id,
  String updatedPhoto,
  String updatedName,
  String updatedGender,
  String updatedDomain,
  String updatedDob,
  String updatedMobile,
  String updatedEmail
)async{
  final studentdb = await Hive.openBox<StudentModel>('student_db');
  final existingStudent = studentdb.values.firstWhere((s) => s.id==id);
  if(existingStudent == null){
     print("student not found");
  }
  else{
    existingStudent.photo = updatedPhoto;
    existingStudent.name = updatedName;
    existingStudent.gender = updatedGender;
    existingStudent.domain = updatedDomain;
    existingStudent.dob = updatedDob;
    existingStudent.mobile = updatedMobile;
    existingStudent.email = updatedEmail;

    await studentdb.put(id, existingStudent);
   studentList.refresh();
   getStudents();
  }

}
}