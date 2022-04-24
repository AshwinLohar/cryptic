import 'GoogleAuthClient.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/io_client.dart';
import 'package:http/http.dart' as http;
import 'package:googleapis/drive/v3.dart' as ga;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:document_file_save_plus/document_file_save_plus.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'NotoSans',
        canvasColor: const Color.fromARGB(255, 242, 232, 207),
        appBarTheme: const AppBarTheme(
          toolbarHeight: 100,
        ),
      ),
      home: const MyHomePage(title: 'Cryptic'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var appState = 0;
  final pwdController1 = TextEditingController();
  final pwdController2 = TextEditingController();
  bool pwdCheck = false;
  var fileProcess = 0;
  static const platformMethodChannel =
      const MethodChannel('com.example.cryptic/native');
  var signedIn = false;
  final storage = new FlutterSecureStorage();
  // final googleSignIn = GoogleSignIn.standard(scopes: [
  //   ga.DriveApi.driveFileScope,
  // ]);
  final googleSignIn = GoogleSignIn.standard(scopes: [
    ga.DriveApi.driveScope,
  ]);
  late GoogleSignInAccount googleSignInAccount;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  ga.FileList? list = null;
  bool visibility = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.title,
          style: const TextStyle(
            fontSize: 34,
            letterSpacing: 1.5,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 188, 71, 73),
        leading: (appState == 0
            ? ElevatedButton(
                onPressed: () {},
                child: const Icon(
                  Icons.settings,
                  size: 34,
                ),
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  primary: const Color.fromARGB(255, 188, 71, 73),
                ),
              )
            : ElevatedButton(
                onPressed: () {
                  setState(() {
                    appState = 0;
                    visibility = true;
                  });
                  fileProcess = 0;
                },
                child: const Icon(
                  Icons.home,
                  size: 34,
                ),
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  primary: const Color.fromARGB(255, 188, 71, 73),
                ),
              )),
      ),
      body: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Center(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(30),
                  child: (appState == 0
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            const Text(
                              '\n',
                              style: TextStyle(
                                fontSize: 36,
                              ),
                            ),
                            const SizedBox(
                              height: 50,
                            ),
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  appState = 1;
                                });
                                fileProcess = 1;
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    'Encrypt',
                                    style: buttonFontStyle(),
                                  ),
                                  const Icon(
                                    Icons.lock_outlined,
                                    size: 30,
                                  ),
                                ],
                              ),
                              style: buttonstyle0(),
                            ),
                            const SizedBox(
                              height: 50,
                            ),
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  appState = 1;
                                });
                                fileProcess = 2;
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    'Decrypt',
                                    style: buttonFontStyle(),
                                  ),
                                  const Icon(
                                    Icons.lock_open_outlined,
                                    size: 30,
                                  ),
                                ],
                              ),
                              style: buttonstyle0(),
                            ),
                          ],
                        )
                      : appState == 1
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                const Text(
                                  'Where is the File Located?',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 36,
                                  ),
                                ),
                                const SizedBox(
                                  height: 50,
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      appState = 2;
                                    });
                                    if (fileProcess == 1) {
                                      fileProcess = 11;
                                    } else {
                                      fileProcess = 21;
                                    }
                                  },
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        'Local Storage',
                                        style: buttonFontStyle(),
                                      ),
                                      const Icon(
                                        Icons.folder_outlined,
                                        size: 30,
                                      ),
                                    ],
                                  ),
                                  style: buttonstyle1(),
                                ),
                                const SizedBox(
                                  height: 50,
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    _loginWithGoogle();
                                    if (fileProcess == 1) {
                                      setState(() {
                                        fileProcess = 12;
                                      });
                                    } else {
                                      setState(() {
                                        fileProcess = 22;
                                      });
                                    }
                                    setState(() {
                                      appState = 2;
                                    });
                                  },
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        'Google Drive',
                                        style: buttonFontStyle(),
                                      ),
                                      const Icon(
                                        Icons.cloud_download_outlined,
                                        size: 30,
                                      ),
                                    ],
                                  ),
                                  style: buttonstyle1(),
                                ),
                              ],
                            )
                          : appState == 2
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    const Text(
                                      'Where to Save the File?',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 36,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 50,
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          appState = 3;
                                        });
                                        if (fileProcess == 11) {
                                          fileProcess = 111;
                                        } else if (fileProcess == 12) {
                                          fileProcess = 121;
                                        } else if (fileProcess == 21) {
                                          fileProcess = 211;
                                        } else {
                                          fileProcess = 221;
                                        }
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text(
                                            'Local Storage',
                                            style: buttonFontStyle(),
                                          ),
                                          const Icon(
                                            Icons.folder_outlined,
                                            size: 30,
                                          ),
                                        ],
                                      ),
                                      style: buttonstyle1(),
                                    ),
                                    const SizedBox(
                                      height: 50,
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        _loginWithGoogle();
                                        if (fileProcess == 11) {
                                          setState(() {
                                            fileProcess = 112;
                                          });
                                        } else if (fileProcess == 12) {
                                          setState(() {
                                            fileProcess = 122;
                                          });
                                        } else if (fileProcess == 21) {
                                          setState(() {
                                            fileProcess = 212;
                                          });
                                        } else {
                                          setState(() {
                                            fileProcess = 222;
                                          });
                                        }
                                        setState(() {
                                          appState = 3;
                                        });
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text(
                                            'Google Drive',
                                            style: buttonFontStyle(),
                                          ),
                                          const Icon(
                                            Icons.cloud_upload_outlined,
                                            size: 30,
                                          ),
                                        ],
                                      ),
                                      style: buttonstyle1(),
                                    ),
                                  ],
                                )
                              : appState == 3
                                  ? SingleChildScrollView(
                                      scrollDirection: Axis.vertical,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          const Text(
                                            'Enter Password',
                                            style: TextStyle(
                                              fontSize: 20,
                                            ),
                                          ),
                                          TextField(
                                            controller: pwdController1,
                                            obscureText: true,
                                          ),
                                          const SizedBox(
                                            height: 40,
                                          ),
                                          const Text(
                                            'Re-Enter Password',
                                            style: TextStyle(
                                              fontSize: 20,
                                            ),
                                          ),
                                          TextField(
                                            controller: pwdController2,
                                            obscureText: true,
                                          ),
                                          const SizedBox(
                                            height: 40,
                                          ),
                                          (signedIn
                                              ? SingleChildScrollView(
                                                  scrollDirection:
                                                      Axis.vertical,
                                                  child: Column(
                                                    children:
                                                        generateFilesWidget(),
                                                  ),
                                                )
                                              : Container()),
                                          (pwdCheck
                                              ? const Text(
                                                  'Passwords do not match!',
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                    color: Colors.red,
                                                  ),
                                                )
                                              : const Text('')),
                                          const SizedBox(
                                            height: 40,
                                          ),
                                          (visibility
                                              ? ElevatedButton(
                                                  onPressed: fileExecute,
                                                  child: const Text(
                                                    'Select File And Execute',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontSize: 25,
                                                    ),
                                                  ),
                                                  style: buttonstyle2(),
                                                )
                                              : Container())
                                        ],
                                      ),
                                    )
                                  : appState == 4
                                      ? Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: const <Widget>[
                                            SpinKitPouringHourGlassRefined(
                                              color: Color.fromARGB(
                                                  255, 56, 102, 65),
                                              size: 100,
                                            ),
                                            SizedBox(
                                              height: 30,
                                            ),
                                            Text(
                                              'Please wait while the file is being processed...',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 30,
                                              ),
                                            ),
                                          ],
                                        )
                                      : Column()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  TextStyle? buttonFontStyle() {
    return const TextStyle(
      fontSize: 27,
    );
  }

  ButtonStyle? buttonstyle0() {
    return ElevatedButton.styleFrom(
      primary: const Color.fromARGB(255, 56, 102, 65),
      fixedSize: const Size(300, 150),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      padding: const EdgeInsets.all(50),
    );
  }

  ButtonStyle? buttonstyle1() {
    return ElevatedButton.styleFrom(
      primary: const Color.fromARGB(255, 56, 102, 65),
      fixedSize: const Size(300, 150),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      padding: const EdgeInsets.all(30),
    );
  }

  ButtonStyle? buttonstyle2() {
    return ElevatedButton.styleFrom(
      primary: const Color.fromARGB(255, 56, 102, 65),
      fixedSize: const Size(300, 130),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      padding: const EdgeInsets.all(30),
    );
  }

  Future<void> fileExecute() async {
    bool result = false;
    print(fileProcess);
    if (pwdController1.text != pwdController2.text) {
      setState(() {
        pwdCheck = true;
      });
    } else {
      setState(() {
        pwdCheck = false;
        appState = 4;
      });
      if (fileProcess == 111) {
        result =
            await EncryptLocalLocal(pwdController1.text, platformMethodChannel);
      } else if (fileProcess == 112) {
        result =
            await EncryptLocalDrive(pwdController1.text, platformMethodChannel);
      } else if (fileProcess == 211) {
        result =
            await DecryptLocalLocal(pwdController1.text, platformMethodChannel);
      } else if (fileProcess == 212) {
        result =
            await DecryptLocalDrive(pwdController1.text, platformMethodChannel);
      }
      if (result) {
        setState(() {
          fileProcess = 0;
          appState = 0;
        });
      }
    }
  }

  Future<bool> EncryptLocalLocal(
      String password, var platformMethodChannel) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    Uint8List fileContent;
    if (result != null) {
      File file = File(result.files.single.path.toString());
      String filename = result.files.single.name;
      fileContent = file.readAsBytesSync();
      await file.delete();
      final List<int> codeUnits = password.codeUnits;
      final Uint8List transferPacket = Uint8List.fromList(codeUnits);
      var data = <String, Uint8List>{
        'data': fileContent,
        'pwd': transferPacket,
      };
      try {
        Uint8List processedData =
            await platformMethodChannel.invokeMethod('encrypt', data);
        if (filename.contains('.txt')) {
          await DocumentFileSavePlus.saveMultipleFiles([processedData],
              [filename.replaceAll('.txt', '.enc')], ["text/plain"]);
        } else if (filename.contains('.jpg')) {
          await DocumentFileSavePlus.saveMultipleFiles(
              [processedData], [filename + '.enc'], ["image/jpg"]);
        } else if (filename.contains('.jpeg')) {
          await DocumentFileSavePlus.saveMultipleFiles(
              [processedData], [filename + '.enc'], ["image/jpeg"]);
        } else if (filename.contains('.mp4')) {
          await DocumentFileSavePlus.saveMultipleFiles([processedData],
              [filename.replaceAll('.mp4', '.enc')], ["video/mp4"]);
        }
        return true;
      } catch (e) {
        print(e);
        return false;
      }
    } else {
      // User canceled the picker
      return false;
    }
  }

  Future<bool> EncryptLocalDrive(
      String password, var platformMethodChannel) async {
    Uint8List fileContent;
    bool temp = await _loginWithGoogle();
    var client = GoogleHttpClient(await googleSignInAccount.authHeaders);
    var drive = ga.DriveApi(client);
    var fileToUpload = new ga.File();
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    File file = File(result!.files.single.path as String);

    fileContent = file.readAsBytesSync();
    final List<int> codeUnits = password.codeUnits;
    final Uint8List transferPacket = Uint8List.fromList(codeUnits);
    var data = <String, Uint8List>{
      'data': fileContent,
      'pwd': transferPacket,
    };
    try {
      Uint8List processedData =
          await platformMethodChannel.invokeMethod('encrypt', data);
      file.writeAsBytesSync(processedData);
      fileToUpload.name = result.files.single.name + '.enc';
      var response = await drive.files.create(fileToUpload,
          uploadMedia: ga.Media(file.openRead(), file.lengthSync()));
      await file.delete();
      print(response);
    } catch (e) {
      print(e);
    }
    await _logoutFromGoogle();
    return true;
  }

  void encryptDriveLocal(String fName, String gdID, String password) async {
    var client = GoogleHttpClient(await googleSignInAccount.authHeaders);
    var drive = ga.DriveApi(client);
    ga.Media file = await drive.files
        .get(gdID, downloadOptions: ga.DownloadOptions.fullMedia) as ga.Media;
    print(file.stream);

    final directory = await getTemporaryDirectory();
    print(directory.path);

    final saveFile = File('${directory.path}/file_picker/$fName');
    List<int> dataStore = [];
    file.stream.listen((data) {
      print('DataReceived: ${data.length}');
      dataStore.insertAll(dataStore.length, data);
    }, onDone: () async {
      print('Task Done');
      print('1');
      saveFile.writeAsBytes(dataStore);
      print('2');
      print('File saved at ${saveFile.path}');
      print('3');
      print(fileProcess);
      print('4');
      // if (fileProcess == 121) {

      // }
      print('5');
      // encryptDriveLocal(saveFile, password);

      // File file = saveFile;
      print('6');
      Uint8List fileContent;
      print(file.toString() + ' 7');
      String filename = saveFile.path.split('/').last;
      print(filename + ' 8');
      fileContent = await saveFile.readAsBytes();
      await saveFile.delete();
      print(fileContent);
      print('9');
      final List<int> codeUnits = password.codeUnits;
      print('10');
      final Uint8List transferPacket = Uint8List.fromList(codeUnits);
      print('11');
      var data = <String, Uint8List>{
        'data': fileContent,
        'pwd': transferPacket,
      };
      print(data);
      print('12');
      try {
        print('13');
        Uint8List processedData =
            await platformMethodChannel.invokeMethod('encrypt', data);
        print(processedData);
        print('14');
        if (filename.contains('.txt')) {
          await DocumentFileSavePlus.saveMultipleFiles([processedData],
              [filename.replaceAll('.txt', '.enc')], ["text/plain"]);
        } else if (filename.contains('.jpg')) {
          await DocumentFileSavePlus.saveMultipleFiles(
              [processedData], [filename + '.enc'], ["image/jpg"]);
        } else if (filename.contains('.jpeg')) {
          await DocumentFileSavePlus.saveMultipleFiles(
              [processedData], [filename + '.enc'], ["image/jpeg"]);
        } else if (filename.contains('.mp4')) {
          await DocumentFileSavePlus.saveMultipleFiles([processedData],
              [filename.replaceAll('.mp4', '.enc')], ["video/mp4"]);
        }
        print('15');
        await _logoutFromGoogle();
        setState(() {
          appState = 0;
        });
      } catch (e) {
        print(e);
        setState(() {
          appState = 0;
        });
      }
    }, onError: (error) {
      print('Some Error');
    });

    // Uint8List fileContent;
    // print(file.toString() + '1');
    // String filename = file.path.split('/').last;
    // print(filename + '2');
    // fileContent = await file.readAsBytes();
    // print('3');
    // print('4');
    // final List<int> codeUnits = password.codeUnits;
    // print('5');
    // final Uint8List transferPacket = Uint8List.fromList(codeUnits);
    // print('5');
    // var data = <String, Uint8List>{
    //   'data': fileContent,
    //   'pwd': transferPacket,
    // };
    // print('7');
    // try {
    //   Uint8List processedData =
    //       await platformMethodChannel.invokeMethod('encrypt', data);
    //   if (filename.contains('.txt')) {
    //     await DocumentFileSavePlus.saveMultipleFiles([processedData],
    //         [filename.replaceAll('.txt', '.enc')], ["text/plain"]);
    //   } else if (filename.contains('.jpg')) {
    //     await DocumentFileSavePlus.saveMultipleFiles(
    //         [processedData], [filename + '.enc'], ["image/jpg"]);
    //   } else if (filename.contains('.jpeg')) {
    //     await DocumentFileSavePlus.saveMultipleFiles(
    //         [processedData], [filename + '.enc'], ["image/jpeg"]);
    //   } else if (filename.contains('.mp4')) {
    //     await DocumentFileSavePlus.saveMultipleFiles([processedData],
    //         [filename.replaceAll('.mp4', '.enc')], ["video/mp4"]);
    //   }
    //   print('8');
    //   setState(() {
    //     appState = 0;
    //   });
    // } catch (e) {
    //   print(e);
    //   setState(() {
    //     appState = 0;
    //   });
    // }
  }

  void encryptDriveDrive(String fName, String gdID, String password) async {
    var client = GoogleHttpClient(await googleSignInAccount.authHeaders);
    var drive = ga.DriveApi(client);
    ga.Media file = await drive.files
        .get(gdID, downloadOptions: ga.DownloadOptions.fullMedia) as ga.Media;
    print(file.stream);
    var fileToUpload = new ga.File();

    final directory = await getTemporaryDirectory();
    print(directory.path);

    final saveFile = File('${directory.path}/file_picker/$fName');
    List<int> dataStore = [];
    file.stream.listen((data) {
      print('DataReceived: ${data.length}');
      dataStore.insertAll(dataStore.length, data);
    }, onDone: () async {
      print('Task Done');
      print('1');
      saveFile.writeAsBytes(dataStore);
      print('2');
      print('File saved at ${saveFile.path}');
      print('3');
      print(fileProcess);
      print('4');
      // if (fileProcess == 121) {

      // }
      print('5');
      // encryptDriveLocal(saveFile, password);

      // File file = saveFile;
      print('6');
      Uint8List fileContent;
      print(file.toString() + ' 7');
      String filename = saveFile.path.split('/').last;
      print(filename + ' 8');
      fileContent = await saveFile.readAsBytes();
      await saveFile.delete();
      print(fileContent);
      print('9');
      final List<int> codeUnits = password.codeUnits;
      print('10');
      final Uint8List transferPacket = Uint8List.fromList(codeUnits);
      print('11');
      var data = <String, Uint8List>{
        'data': fileContent,
        'pwd': transferPacket,
      };
      print(data);
      print('12');
      try {
        Uint8List processedData =
            await platformMethodChannel.invokeMethod('encrypt', data);
        await saveFile.writeAsBytes(processedData);
        fileToUpload.name = filename + '.enc';
        var response = await drive.files.create(fileToUpload,
            uploadMedia: ga.Media(saveFile.openRead(), saveFile.lengthSync()));
        await saveFile.delete();
        print('15');
        await _logoutFromGoogle();
        setState(() {
          appState = 0;
        });
      } catch (e) {
        print(e);
        setState(() {
          appState = 0;
        });
      }
    }, onError: (error) {
      print('Some Error');
    });
  }

  Future<bool> DecryptLocalLocal(
      String password, var platformMethodChannel) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    Uint8List fileContent;
    if (result != null) {
      File file = File(result.files.single.path.toString());
      String filename = result.files.single.name;
      fileContent = file.readAsBytesSync();
      await file.delete();
      final List<int> codeUnits = password.codeUnits;
      final Uint8List transferPacket = Uint8List.fromList(codeUnits);
      var data = <String, Uint8List>{
        'data': fileContent,
        'pwd': transferPacket,
      };
      try {
        Uint8List processedData =
            await platformMethodChannel.invokeMethod('decrypt', data);
        if (filename.contains('.txt')) {
          await DocumentFileSavePlus.saveMultipleFiles([processedData],
              [filename.replaceAll('.enc', '')], ["text/plain"]);
        } else if (filename.contains('.jpg')) {
          await DocumentFileSavePlus.saveMultipleFiles([processedData],
              [filename.replaceAll('.enc', '')], ["image/jpg"]);
        } else if (filename.contains('.jpeg')) {
          await DocumentFileSavePlus.saveMultipleFiles([processedData],
              [filename.replaceAll('.enc', '')], ["image/jpeg"]);
        } else if (filename.contains('.mp4')) {
          await DocumentFileSavePlus.saveMultipleFiles([processedData],
              [filename.replaceAll('.enc.mp4', '')], ["video/mp4"]);
        }
        return true;
      } catch (e) {
        print(e);
        return false;
      }
    } else {
      // User canceled the picker
      return false;
    }
  }

  Future<bool> DecryptLocalDrive(
      String password, var platformMethodChannel) async {
    Uint8List fileContent;
    bool temp = await _loginWithGoogle();
    var client = GoogleHttpClient(await googleSignInAccount.authHeaders);
    var drive = ga.DriveApi(client);
    var fileToUpload = new ga.File();
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    File file = File(result!.files.single.path as String);

    fileContent = file.readAsBytesSync();
    final List<int> codeUnits = password.codeUnits;
    final Uint8List transferPacket = Uint8List.fromList(codeUnits);
    var data = <String, Uint8List>{
      'data': fileContent,
      'pwd': transferPacket,
    };
    try {
      Uint8List processedData =
          await platformMethodChannel.invokeMethod('decrypt', data);
      file.writeAsBytesSync(processedData);
      fileToUpload.name = result.files.single.name.replaceAll('.enc', '');
      var response = await drive.files.create(fileToUpload,
          uploadMedia: ga.Media(file.openRead(), file.lengthSync()));
      await file.delete();
      print(response);
    } catch (e) {
      print(e);
    }
    await _logoutFromGoogle();
    await storage.deleteAll();
    return true;
  }

  void decryptDriveLocal(String fName, String gdID, String password) async {
    var client = GoogleHttpClient(await googleSignInAccount.authHeaders);
    var drive = ga.DriveApi(client);
    ga.Media file = await drive.files
        .get(gdID, downloadOptions: ga.DownloadOptions.fullMedia) as ga.Media;
    print(file.stream);

    final directory = await getTemporaryDirectory();
    print(directory.path);

    final saveFile = File('${directory.path}/file_picker/$fName');
    List<int> dataStore = [];
    file.stream.listen((data) {
      print('DataReceived: ${data.length}');
      dataStore.insertAll(dataStore.length, data);
    }, onDone: () async {
      print('Task Done');
      print('1');
      saveFile.writeAsBytes(dataStore);
      print('2');
      print('File saved at ${saveFile.path}');
      print('3');
      print(fileProcess);
      print('4');
      // if (fileProcess == 121) {

      // }
      print('5');
      // encryptDriveLocal(saveFile, password);

      // File file = saveFile;
      print('6');
      Uint8List fileContent;
      print(file.toString() + ' 7');
      String filename = saveFile.path.split('/').last;
      print(filename + ' 8');
      fileContent = await saveFile.readAsBytes();
      await saveFile.delete();
      print(fileContent);
      print('9');
      final List<int> codeUnits = password.codeUnits;
      print('10');
      final Uint8List transferPacket = Uint8List.fromList(codeUnits);
      print('11');
      var data = <String, Uint8List>{
        'data': fileContent,
        'pwd': transferPacket,
      };
      print(data);
      print('12');
      try {
        Uint8List processedData =
            await platformMethodChannel.invokeMethod('decrypt', data);
        if (filename.contains('.txt')) {
          await DocumentFileSavePlus.saveMultipleFiles([processedData],
              [filename.replaceAll('.enc', '')], ["text/plain"]);
        } else if (filename.contains('.jpg')) {
          await DocumentFileSavePlus.saveMultipleFiles([processedData],
              [filename.replaceAll('.enc', '')], ["image/jpg"]);
        } else if (filename.contains('.jpeg')) {
          await DocumentFileSavePlus.saveMultipleFiles([processedData],
              [filename.replaceAll('.enc', '')], ["image/jpeg"]);
        } else if (filename.contains('.mp4')) {
          await DocumentFileSavePlus.saveMultipleFiles([processedData],
              [filename.replaceAll('.enc.mp4', '')], ["video/mp4"]);
        }
        print('15');
        await _logoutFromGoogle();
        setState(() {
          appState = 0;
        });
      } catch (e) {
        print(e);
        setState(() {
          appState = 0;
        });
      }
    }, onError: (error) {
      print('Some Error');
    });
  }

  void DecryptDriveDrive(String fName, String gdID, String password) async {
    var client = GoogleHttpClient(await googleSignInAccount.authHeaders);
    var drive = ga.DriveApi(client);
    ga.Media file = await drive.files
        .get(gdID, downloadOptions: ga.DownloadOptions.fullMedia) as ga.Media;
    print(file.stream);
    var fileToUpload = new ga.File();

    final directory = await getTemporaryDirectory();
    print(directory.path);

    final saveFile = File('${directory.path}/file_picker/$fName');
    List<int> dataStore = [];
    file.stream.listen((data) {
      print('DataReceived: ${data.length}');
      dataStore.insertAll(dataStore.length, data);
    }, onDone: () async {
      print('Task Done');
      print('1');
      saveFile.writeAsBytes(dataStore);
      print('2');
      print('File saved at ${saveFile.path}');
      print('3');
      print(fileProcess);
      print('4');
      // if (fileProcess == 121) {

      // }
      print('5');
      // encryptDriveLocal(saveFile, password);

      // File file = saveFile;
      print('6');
      Uint8List fileContent;
      print(file.toString() + ' 7');
      String filename = saveFile.path.split('/').last;
      print(filename + ' 8');
      fileContent = await saveFile.readAsBytes();
      await saveFile.delete();
      print(fileContent);
      print('9');
      final List<int> codeUnits = password.codeUnits;
      print('10');
      final Uint8List transferPacket = Uint8List.fromList(codeUnits);
      print('11');
      var data = <String, Uint8List>{
        'data': fileContent,
        'pwd': transferPacket,
      };
      print(data);
      print('12');
      try {
        Uint8List processedData =
            await platformMethodChannel.invokeMethod('decrypt', data);
        await saveFile.writeAsBytes(processedData);
        fileToUpload.name = filename.replaceAll('.enc', '');
        var response = await drive.files.create(fileToUpload,
            uploadMedia: ga.Media(saveFile.openRead(), saveFile.lengthSync()));
        await saveFile.delete();
        print('15');
        await _logoutFromGoogle();
        setState(() {
          appState = 0;
        });
      } catch (e) {
        print(e);
        setState(() {
          appState = 0;
        });
      }
    }, onError: (error) {
      print('Some Error');
    });
  }

  Future<bool> listInConsole() async {
    bool temp = await _loginWithGoogle();

    var client = GoogleHttpClient(await googleSignInAccount.authHeaders);
    var drive = ga.DriveApi(client);
    drive.files.list().then((value) {
      // setState(() {
      list = value;
      // });
      for (var i = 0; i < list!.files!.length; i++) {
        print('Id: ${list!.files![i].id} File Name:${list!.files![i].name}');
      }
    });

    bool test2 = await _logoutFromGoogle();
    await storage.deleteAll();
    return true;
  }

  Future<bool> _loginWithGoogle() async {
    signedIn = await storage.read(key: 'signedIn') == 'true' ? true : false;
    googleSignIn.onCurrentUserChanged
        .listen((GoogleSignInAccount? googleSignInAccount) async {
      if (googleSignInAccount != null) {
        bool test = await _afterGoogleLogin(googleSignInAccount);
      }
    });
    if (signedIn) {
      try {
        googleSignIn.signInSilently().whenComplete(() => () {});
      } catch (e) {
        storage.write(key: 'signedIn', value: 'false').then((value) {
          setState(() {
            signedIn = false;
          });
        });
      }
    } else {
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();
      bool test = await _afterGoogleLogin(googleSignInAccount!);
    }
    return true;
  }

  Future<bool> _afterGoogleLogin(GoogleSignInAccount gSA) async {
    googleSignInAccount = gSA;
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final UserCredential authResult =
        await _auth.signInWithCredential(credential);

    final User? user = authResult.user;

    assert(!user!.isAnonymous);
    assert(await user?.getIdToken() != null);

    final User? currentUser = await _auth.currentUser;
    assert(user!.uid == currentUser!.uid);

    print('signInWithGoogle succeeded: $user');

    storage.write(key: 'signed', value: 'true').then((value) {
      setState(() {
        signedIn = true;
      });
    });
    return true;
  }

  Future<bool> _logoutFromGoogle() async {
    googleSignIn.signIn().then((value) {
      print('User Sign Out');
      storage.write(key: 'signedIn', value: 'false').then((value) {
        setState(() {
          signedIn = false;
        });
      });
    });
    return true;
  }

  _uploadFileToGoogleDrive() async {
    var client = GoogleHttpClient(await googleSignInAccount.authHeaders);
    var drive = ga.DriveApi(client);
    var fileToUpload = new ga.File();
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    File file = File(result!.files.single.path as String);
    fileToUpload.name = result.files.single.name;
    var response = await drive.files.create(fileToUpload,
        uploadMedia: ga.Media(file.openRead(), file.lengthSync()));
    print(response);
    _listGoogleDriveFiles();
  }

  Future<bool> _listGoogleDriveFiles() async {
    var client = GoogleHttpClient(await googleSignInAccount.authHeaders);
    var drive = ga.DriveApi(client);
    drive.files.list().then((value) {
      setState(() {
        list = value;
      });
      for (var i = 0; i < list!.files!.length; i++) {
        print('Id: ${list!.files![i].id} File Name:${list!.files![i].name}');
      }
    });
    return true;
  }

  List<Widget> generateFilesWidget() {
    List<Widget> listItem = <Widget>[];
    if (fileProcess == 121 ||
        fileProcess == 122 ||
        fileProcess == 221 ||
        fileProcess == 222) {
      setState(() {
        visibility = false;
      });
      Future<bool> temp = _listGoogleDriveFiles();
      List<Widget> listItem = <Widget>[];
      if (list != null) {
        for (var i = 0; i < list!.files!.length; i++) {
          listItem.add(Row(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width * 0.05,
                child: Text('${i + 1}'),
              ),
              Expanded(
                child: Text(list!.files![i].name as String),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.3,
                child: ElevatedButton(
                  child: const Text(
                    'Select File',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: const Color.fromARGB(255, 56, 102, 65),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                  ),
                  onPressed: () {
                    if (pwdController1.text != pwdController2.text) {
                      setState(() {
                        pwdCheck = true;
                      });
                    } else {
                      setState(() {
                        pwdCheck = false;
                        appState = 4;
                      });
                      if (fileProcess == 121) {
                        encryptDriveLocal(list!.files![i].name as String,
                            list!.files![i].id as String, pwdController1.text);
                      } else if (fileProcess == 221) {
                        decryptDriveLocal(list!.files![i].name as String,
                            list!.files![i].id as String, pwdController1.text);
                      } else if (fileProcess == 122) {
                        encryptDriveDrive(list!.files![i].name as String,
                            list!.files![i].id as String, pwdController1.text);
                      } else if (fileProcess == 222) {
                        DecryptDriveDrive(list!.files![i].name as String,
                            list!.files![i].id as String, pwdController1.text);
                      }
                      // _downloadGoogleDriveFile(list!.files![i].name as String,
                      //     list!.files![i].id as String, pwdController1.text);

                    }
                  },
                ),
              ),
            ],
          ));
        }
      }
      return listItem;
    }
    return listItem;
  }

  Future<void> _downloadGoogleDriveFile(
      String fName, String gdID, String password) async {
    var client = GoogleHttpClient(await googleSignInAccount.authHeaders);
    var drive = ga.DriveApi(client);
    ga.Media file = await drive.files
        .get(gdID, downloadOptions: ga.DownloadOptions.fullMedia) as ga.Media;
    print(file.stream);

    // final directory = await getDownloadsDirectory();
    final directory = await getTemporaryDirectory();
    print(directory.path);
    // final saveFile = File(
    //     '${directory.path}/${new DateTime.now().millisecondsSinceEpoch}$fName');
    final saveFile = File('${directory.path}/file_picker/$fName');
    List<int> dataStore = [];
    file.stream.listen((data) {
      print('DataReceived: ${data.length}');
      dataStore.insertAll(dataStore.length, data);
    }, onDone: () {
      print('Task Done');
      saveFile.writeAsBytes(dataStore);
      print('File saved at ${saveFile.path}');
      print('1');
      if (fileProcess == 121) {
        print('2');
        // encryptDriveLocal(saveFile, password);
      }
    }, onError: (error) {
      print('Some Error');
    });
  }
}

class GoogleHttpClient extends IOClient {
  Map<String, String> _headers;

  GoogleHttpClient(this._headers) : super();

  @override
  Future<IOStreamedResponse> send(http.BaseRequest request) =>
      super.send(request..headers.addAll(_headers));

  @override
  Future<http.Response> head(Object url, {Map<String, String>? headers}) =>
      super.head(url as Uri, headers: headers!..addAll(_headers));
}
