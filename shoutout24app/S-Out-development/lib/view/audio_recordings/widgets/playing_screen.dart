import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:shoutout24/common/customAppbar.dart';
import 'package:shoutout24/utils/color.dart';
import 'package:shoutout24/widgets/verticalSpacing.dart';

class PlayClipPage extends StatefulWidget {
  final String audioFile;
  final int audioNumber;

  const PlayClipPage({Key key, this.audioFile, this.audioNumber})
      : super(key: key);

  @override
  _PlayClipPageState createState() => _PlayClipPageState();
}

class _PlayClipPageState extends State<PlayClipPage> {
  AudioPlayer _audioPlayer = AudioPlayer();
  Duration _totalDuration;
  Duration _playDuration;
  String _audioState;
  @override
  void initState() {
    _initAudio();
    super.initState();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  _initAudio() {
    _audioPlayer.onDurationChanged.listen((updatedDuration) {
      setState(() {
        _totalDuration = updatedDuration;
      });
    });
    _audioPlayer.onAudioPositionChanged.listen((updatePosition) {
      setState(() {
        _playDuration = updatePosition;
      });
    });

    _audioPlayer.onPlayerStateChanged.listen((audioState) {
      if (audioState == AudioPlayerState.PLAYING) _audioState = "Playing";

      if (audioState == AudioPlayerState.PAUSED) _audioState = "Paused";

      if (audioState == AudioPlayerState.STOPPED) _audioState = "Stopped";

      if (audioState == AudioPlayerState.COMPLETED) _audioState = "Completed";

      setState(() {});
    });
  }

  _startPlaying() {
    _audioPlayer.play(widget.audioFile, isLocal: true);
  }

  _pausePlay() {
    _audioPlayer.pause();
  }

  _seekAudio(Duration duration) {
    _audioPlayer.seek(duration);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // backgroundColor: colorAccent,
        appBar: customAppBar(title: 'Playing'),
        body: Container(
          margin: EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SliderTheme(
                  data: SliderThemeData(
                      trackHeight: 5,
                      thumbShape:
                          RoundSliderThumbShape(enabledThumbRadius: 5.0)),
                  child: Slider(
                    max: _totalDuration == null
                        ? 20
                        : _totalDuration.inMilliseconds.toDouble(),
                    value: _playDuration == null
                        ? 0
                        : _playDuration.inMilliseconds.toDouble(),
                    activeColor: colorOrange,
                    inactiveColor: Colors.grey,
                    onChanged: (value) {
                      _seekAudio(Duration(milliseconds: value.toInt()));
                    },
                  )),
              VerticalSpacing(),
              _playDuration != null
                  ? Text(
                      '${_playDuration.toString().split('.').first} / ${_totalDuration.toString().split('.').first}')
                  : Text(''),
              VerticalSpacing(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // playControl(icon: Icons.repeat),
                  playControl(
                    icon: Icons.fast_rewind,
                    onPress: () {
                      print("Rewinding");
                    },
                  ),
                  playControl(
                    icon: _audioState == "Playing"
                        ? Icons.pause
                        : Icons.play_arrow,
                    onPress: () {
                      // print('play');
                      setState(() {
                        _audioState == "Playing"
                            ? _pausePlay()
                            : _startPlaying();
                      });
                    },
                  ),
                  playControl(
                    icon: Icons.fast_forward,
                    onPress: () {
                      print('fast forward');
                    },
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class playControl extends StatelessWidget {
  final IconData icon;
  final Function onPress;
  const playControl({
    this.icon,
    Key key,
    this.onPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPress,
      child: Container(
        height: 80,
        width: 80,
        decoration: BoxDecoration(
          color: colorAccent,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
                color: colorPrimaryDark.withOpacity(0.5),
                offset: Offset(5, 10),
                spreadRadius: 3,
                blurRadius: 10),
            BoxShadow(
                color: Colors.white,
                offset: Offset(-3, -4),
                spreadRadius: -2,
                blurRadius: 20)
          ],
        ),
        child: Stack(
          children: [
            Center(
              child: Container(
                margin: EdgeInsets.all(6),
                decoration: BoxDecoration(
                    color: colorAccent,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.white,
                          offset: Offset(5, 10),
                          spreadRadius: 3,
                          blurRadius: 10),
                      BoxShadow(
                          color: Colors.white,
                          offset: Offset(-5, -4),
                          spreadRadius: -2,
                          blurRadius: 20),
                    ]),
              ),
            ),
            Center(
              child: Container(
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: colorPrimaryDark, shape: BoxShape.circle),
                  child:
                      Center(child: Icon(icon, size: 30, color: colorOrange))),
            )
          ],
        ),
      ),
    );
  }
}
