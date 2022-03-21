import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_audio_recorder/flutter_audio_recorder.dart';
import 'package:path_provider/path_provider.dart';

class AudioRecorderProvider extends ChangeNotifier {
  FlutterAudioRecorder audioRecorder;
  bool isRecording = false;
  Directory appDirectory;
  List<String> records;

  AudioRecorderProvider() {
    print("hello record Provider");
    this.getAllRecording();
  }
  _initializeRecorder() async {
    Directory appDirectory = await getApplicationDocumentsDirectory();
    String filePath = appDirectory.path +
        '/' +
        DateTime.now().millisecondsSinceEpoch.toString() +
        '.aac';

    audioRecorder =
        FlutterAudioRecorder(filePath, audioFormat: AudioFormat.AAC);
    await audioRecorder.initialized;
  }

  Future<void> startRecording() async {
    bool hasPermission = await FlutterAudioRecorder.hasPermissions;
    if (hasPermission) {
      await _initializeRecorder();
      await audioRecorder.start();

      isRecording = true;
      notifyListeners();
    } else {}
  }

  stopRecording() async {
    await audioRecorder.stop();
    isRecording = false;
    notifyListeners();
    this.getAllRecording();
  }

  void killRecording() {
    audioRecorder = null;
    appDirectory = null;
    records = null;
    notifyListeners();
  }

  getAllRecording() {
    print('getting recording');
    records = [];
    getApplicationDocumentsDirectory().then((value) {
      appDirectory = value;
      appDirectory.list().listen((onData) {
        if (onData.path.endsWith(".aac")) {
          records.add(onData.path);
        }
      }).onDone(() {
        records = records.reversed.toList();
        notifyListeners();
      });
    });
  }

  Future<void> deleteAudio(File file) async {
    try {
      if (await file.exists()) {
        await file.delete();
        notifyListeners();
        getAllRecording();
      }
    } catch (e) {
      // Error in getting access to the file.
      print("deleting audio error $e");
    }
  }
}
