import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoutout24/common/customAppbar.dart';
import 'package:shoutout24/services/recorder_provider.dart';
import 'package:shoutout24/utils/color.dart';
import 'package:shoutout24/view/audio_recordings/widgets/recorded_list_view.dart';
import 'package:shoutout24/widgets/verticalSpacing.dart';

class AudioRecordingPage extends StatefulWidget {
  @override
  _AudioRecordingPageState createState() => _AudioRecordingPageState();
}

class _AudioRecordingPageState extends State<AudioRecordingPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Consumer<AudioRecorderProvider>(
        builder: (_, recorder, child) => Scaffold(
            appBar: customAppBar(title: "My Audios"),
            body: Container(
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Column(
                children: [
                  VerticalSpacing(),
                  Text(
                    recorder.isRecording ? "Recording..." : "",
                    style: TextStyle(color: colorPrimary, fontSize: 16),
                  ),
                  Expanded(
                    child: RecordListView(
                      records: recorder.records,
                    ),
                  )
                ],
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () async {
                recorder.isRecording
                    ? await recorder.stopRecording()
                    : await recorder.startRecording();
              },
              child: Icon(
                recorder.isRecording ? Icons.fiber_manual_record : Icons.mic,
                color: Colors.white,
              ),
            )),
      ),
    );
  }
}
