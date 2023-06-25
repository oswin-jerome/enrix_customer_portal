import 'dart:io';

import 'package:dio/dio.dart';
import 'package:customer_portal/Controllers/FileSystemController.dart';
import 'package:customer_portal/components/customLoader.dart';
import 'package:customer_portal/utils/Base.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class FileSystemPage extends StatefulWidget {
  int? propertyId;
  FileSystemPage({this.propertyId});
  // FileSystemPage() {
  //   controller.folderId.value = 0;
  //   controller.getRootFolder();
  // }

  @override
  State<FileSystemPage> createState() => _FileSystemPageState();
}

class _FileSystemPageState extends State<FileSystemPage> {
  int? propertyId;
  _FileSystemPageState({this.propertyId});
  var controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(FileSystemController(properyID: widget.propertyId!));
  }

  List<String> _downloading = [];
  List _subFolderStack = [];
  List breadCrums = [
    {
      "name": "Home",
      "id": 0,
    }
  ];

  _downloadFile(String filename) async {
    var fileUrl = Base.baseUrlWithoutApi + "storage/files/fs/" + filename;

    if (filename.contains("authletter")) {
      fileUrl =
          Base.baseUrlWithoutApi + filename.replaceAll("public", "storage");
    }
    Directory dir = await getApplicationDocumentsDirectory();

    File file = new File(dir.path + "/" + filename);
    if (file.existsSync()) {
      return OpenFile.open(dir.path + "/" + filename);
    }
    setState(() {
      _downloading.add(filename);
    });
    print("++++++++++++++++++++++++++++");
    print(filename);
    controller.downloading.add(filename);
    Dio().download(fileUrl, dir.path + "/" + filename,
        onReceiveProgress: (i, j) {
      //print(t(j.toString() + " " + i.toString());
    }).then((value) {
      controller.downloading.remove(filename);

      // setState(() {
      //   _downloading.remove(filename);
      // });
      //print(t(value.data);
      OpenFile.open(dir.path + "/" + filename);
    }).whenComplete(() {
      setState(() {
        _downloading.remove(filename);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        print("object");
        if (_subFolderStack.length > 0) {
          setState(() {
            controller.folderId.value = _subFolderStack.removeLast()['id'];
            breadCrums.removeLast();
          });
          if (controller.folderId.value == 0) {
            controller.getRootFolder();
            return false;
          }
          controller.getSubFolders();
          return false;
        }

        // if (_subFolderStack.length == 0) {
        //   controller.getRootFolder();
        //   return false;
        // }

        return true;
      },
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(90),
          child: AppBar(
            backgroundColor: Colors.grey[50],
            elevation: 0,
            title: Text("Docs"),
            bottom: PreferredSize(
                child: Container(
                  height: 30,
                  // color: Colors.red,
                  child: ListView.separated(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    separatorBuilder: (bc, i) {
                      return Container(
                          alignment: Alignment.topCenter,
                          // color: Colors.red,
                          child: Icon(
                            Icons.chevron_right,
                            color: Colors.grey,
                            size: 18,
                          ));
                    },
                    scrollDirection: Axis.horizontal,
                    itemCount: breadCrums.length,
                    itemBuilder: (bx, i) {
                      return GestureDetector(
                        onTap: () {
                          // setState(() {
                          // controller.folderId.value = breadCrums[i]['id'];
                          // breadCrums.removeRange(i, _subFolderStack.length);
                          // print(i);
                          // print(_subFolderStack[i]['id']);
                          // });
                          // if (controller.folderId.value == 0) {
                          //   controller.getRootFolder();
                          //   return false;
                          // } else {
                          //   controller.getSubFolders();
                          // }
                        },
                        child: Text(
                          breadCrums[i]['name'],
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[600]),
                        ),
                      );
                    },
                  ),
                ),
                preferredSize: Size.fromHeight(20)),
          ),
        ),
        body: GetX<FileSystemController>(builder: (bc) {
          // if (controller.isLoading.value) {
          //   return Center(child: CircularProgressIndicator());
          // }
          return ModalProgressHUD(
            inAsyncCall: controller.isLoading.value,
            opacity: 0.4,
            color: Colors.black,
            progressIndicator: CustomLoader(),
            child: ListView.separated(
                separatorBuilder: (context, index) {
                  return Divider(
                    color: Colors.grey[400],
                  );
                },
                padding: EdgeInsets.all(15),
                itemBuilder: (bc, i) {
                  return ListTile(
                    onTap: () {
                      if (controller.filesAndFolders[i]['type'] == 'folder') {
                        controller.propertyId.value = widget.propertyId;
                        setState(() {
                          _subFolderStack.add({
                            "id": controller.folderId.value,
                            "name": controller.folderName.value
                          });
                          breadCrums.add({
                            "id": controller.filesAndFolders[i]['id'],
                            "name": controller.filesAndFolders[i]['name']
                          });
                        });
                        // controller.folderId.value
                        controller.folderId.value =
                            controller.filesAndFolders[i]['id'];
                        controller.folderName.value =
                            controller.filesAndFolders[i]['name'];
                        controller.getSubFolders();
                      }

                      if (controller.filesAndFolders[i]['type'] == 'file') {
                        _downloadFile(
                            controller.filesAndFolders[i]['actual_file']);
                      }
                    },
                    leading: controller.filesAndFolders[i]['type'] == 'folder'
                        ? const Icon(
                            Icons.folder,
                            size: 45,
                          )
                        : _downloading.contains(
                                controller.filesAndFolders[i]['actual_file'])
                            ? Container(width: 40, child: CustomLoader())
                            : Image.asset("assets/pdf.png"),
                    title: Text(
                      controller.filesAndFolders[i]['name'],
                      maxLines: 1,
                      textWidthBasis: TextWidthBasis.longestLine,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(
                      "Last Updated on " +
                          Base.formaterr.format(
                            DateTime.parse(
                              controller.filesAndFolders[i]['updated_at'],
                            ),
                          ),
                      style: TextStyle(fontSize: 12),
                    ),
                  );
                },
                itemCount: controller.filesAndFolders.length),
          );
        }),
      ),
    );
  }
}
