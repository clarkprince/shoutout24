import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';
import 'package:shoutout24/common/customdialog.dart';
import 'package:shoutout24/services/recorder_provider.dart';
import 'package:shoutout24/utils/color.dart';
import 'package:shoutout24/view/audio_recordings/widgets/playing_screen.dart';

class RecordListView extends StatefulWidget {
  final List<String> records;
  const RecordListView({
    Key key,
    this.records,
  }) : super(key: key);

  @override
  _RecordListViewState createState() => _RecordListViewState();
}

class _RecordListViewState extends State<RecordListView> {
  @override
  Widget build(BuildContext context) {
    print({widget.records.toString()});

    return (widget.records?.length ?? 0) > 0
        ? ListView.separated(
            itemCount: widget.records?.length,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int i) {
              return ListTile(
                leading: CircleAvatar(
                    backgroundColor: colorPrimaryDark,
                    child: Text(
                      '${i + 1}',
                      style: TextStyle(color: Colors.white),
                    )),
                title: Text('Audio Clip ${i + 1}'),
                subtitle:
                    Text(_getDateFromFilePatah(filePath: widget.records[i])),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (dialogContext) => CustomDialog(
                              icon: FontAwesome5.question_circle,
                              title: "Confirmation",
                              description:
                                  "Are you sure you want to delete this Audio",
                              okayButtonText: "Yes",
                              cancelButtonText: "Cancel",
                              okayPress: () async {
                                Navigator.pop(dialogContext);
                                Provider.of<AudioRecorderProvider>(context,
                                        listen: false)
                                    .deleteAudio(File(widget.records[i]));
                              },
                            ));
                  },
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PlayClipPage(
                                audioNumber: i,
                                audioFile: widget.records.elementAt(i),
                              )));
                },
              );
            },
            separatorBuilder: (context, index) => Divider(),
          )
        : Center(child: Text('No Audio recording found'));
  }

  String _getDateFromFilePatah({@required String filePath}) {
    print('Path HERE :${filePath}');
    print('HERE :${filePath.lastIndexOf('/')}');
    String fromEpoch = filePath.substring(
        filePath.lastIndexOf('/') + 1, filePath.lastIndexOf('.'));

    DateTime recordedDate =
        DateTime.fromMillisecondsSinceEpoch(int.parse(fromEpoch));

    print(recordedDate);
    int year = recordedDate.year;
    int month = recordedDate.month;
    int day = recordedDate.day;
    int time = recordedDate.hour;
    int minutes = recordedDate.minute;

    return ('$year-$month-$day  $time:$minutes');
  }
}
