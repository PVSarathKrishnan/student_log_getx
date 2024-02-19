import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:student_log_getx/data/models/student_model.dart';

class StudentGetX extends GetxController {
  RxString? profileImage = "".obs;
  RxString? dateOfBirth = DateTime.now().toString().obs;
  RxString? gender = "".obs;
  RxString? domain = "".obs;

  List<StudentModel> _studentList = [];
  List<StudentModel> get studentList => _studentList;

  getImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      profileImage!.value = pickedImage.path.toString();
    }
  }

  getDOB(DateTime dob) {
    dateOfBirth?.value = dob.toString();
  }

  getGender(String g) {
    gender!.value = g;
  }

  getDomain(String d) {
    domain!.value = d;
  }

  searchStudent(List<StudentModel> newList) {
    _studentList = newList;
    update();
  }
}
