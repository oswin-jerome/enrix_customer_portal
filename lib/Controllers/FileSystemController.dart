import 'package:customer_portal/utils/ApiHelper.dart';
import 'package:get/get.dart';

class FileSystemController extends GetxController {
  var filesAndFolders = [].obs;
  RxInt folderId = 0.obs;
  RxString folderName = "Root".obs;
  var propertyId = 0.obs;
  RxBool isLoading = false.obs;
  var downloading = [].obs;
  FileSystemController({properyID}) {
    this.propertyId.value = properyID;
    getRootFolder();
  }
  getRootFolder() async {
    isLoading.value = true;
    ApiHelper()
        .dio
        .get("/filesystems/property/$propertyId/folder")
        .then((value) {
      filesAndFolders.value = value.data['data'];
      print(filesAndFolders);
      isLoading.value = false;
    });
  }

  getSubFolders() async {
    isLoading.value = true;
    ApiHelper()
        .dio
        .get("/filesystems/property/$propertyId/folder/$folderId")
        .then((value) {
      filesAndFolders.value = value.data['data'];
      // print(filesAndFolders);
      isLoading.value = false;
    });
  }
}
