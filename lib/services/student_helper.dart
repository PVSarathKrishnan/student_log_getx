import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:student_log_getx/data/models/student_model.dart';

class StudentGetX extends GetxController {
  RxString? profileImage = ''.obs;
  RxString? dateOfBirth = DateTime.now().toString().obs;
  RxString? gender = ''.obs;
  RxString? domain = ''.obs;

  RxList studentList = [].obs;

  // int count = 0;

//to add image
  getImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      profileImage!.value = pickedImage.path.toString();
    }
  }

//to add dob
  getDOB(DateTime dob) {
    dateOfBirth?.value = dob.toString();
  }

//to add gender
  getGender(String g) {
    gender!.value = g;
  }

//to add domain
  getDomain(String d) {
    domain!.value = d;
  }

  searchStudent(List<StudentModel> newList) {
    studentList = newList as RxList;
    update();
  }
}
