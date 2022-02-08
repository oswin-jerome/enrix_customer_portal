import 'dart:io';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart';

class GenerateAuthLetter {
  makeAndSave({String customerName = "", String address = ""}) async {
    var box = Hive.box("store");

    final pdf = Document();
    var image;
    Directory tempdir = await getApplicationDocumentsDirectory();
    FileSystemEntity? sign;
    Directory signatures = new Directory(tempdir.path + "/signatires");
    sign = signatures.listSync().elementAt(0);
    if (sign.existsSync()) {
      image = MemoryImage(
        File(sign.path).readAsBytesSync(),
      );
    }

    pdf.addPage(
      Page(
        build: (bc) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "Authorization letter",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 60),
              Paragraph(
                style: TextStyle(fontSize: 16, lineSpacing: 15),
                text:
                    "         I ${box.get("user")["name"]}, here authorize Mr. Jebin Asir Jose, CEO, ENRIX Property Management and his team to access and inspect the property owned by me at $address",
              ),
              Row(children: [
                Spacer(flex: 6),
                Expanded(
                  flex: 4,
                  child: Column(
                    children: [
                      Text(
                        "Your Sincierly,",
                        style: TextStyle(fontSize: 18, lineSpacing: 15),
                      ),
                      image != null ? Image(image) : Text("No signature")
                    ],
                  ),
                )
              ])
            ],
          );
        },
      ),
    );
    // Directory tempdir2 = await getApplicationDocumentsDirectory();
    final file = File(tempdir.path + "/authletter.pdf");
    await file.writeAsBytes(await pdf.save());

    // OpenFile.open(file.path);
  }
}
