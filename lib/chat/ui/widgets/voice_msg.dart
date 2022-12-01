import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

import 'package:responsive_sizer/responsive_sizer.dart';

class PlayVoiceMsg extends StatefulWidget {
  const PlayVoiceMsg({required this.audioUrl, super.key, required this.time});
  final String audioUrl;
  final String time;

  @override
  State<PlayVoiceMsg> createState() => _PlayVoiceMsgState();
}

class _PlayVoiceMsgState extends State<PlayVoiceMsg> {
  bool isPlaying = false;
  bool isloading = false;
  // AudioPlayer player = AudioPlayer();
  final player = AudioPlayer();
  Duration? duration;

  Duration pos = Duration.zero;
  void getduration() async {
    if (mounted) {
      setState(() {
        isloading = true;
      });
    }

    duration = await player.setUrl(widget.audioUrl);
    if (mounted) {
      setState(() {
        isloading = false;
      });
    }
  }

  String formatTime(Duration duration) {
    String twoDigits(int n) {
      if (n >= 10) return "$n";
      return "0$n";
    }

    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  void initState() {
    getduration();
    player.playingStream.listen((state) {
      if (mounted) {
        setState(() {
          isPlaying = state;
        });
      }
    });
    player.durationStream.listen((newduration) {
      if (mounted) {
        setState(() {
          duration = newduration;
        });
      }
    });

    player.createPositionStream().listen((newpos) {
      if (mounted) {
        setState(() {
          pos = newpos;
        });
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return isloading
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              SizedBox(
                  height: 25, width: 25, child: CircularProgressIndicator())
            ],
          )
        : Column(
            children: [
              Row(
                children: [
                  IconButton(
                      onPressed: () async {
                        if (isPlaying) {
                          await player.pause();
                        } else {
                          await player.play();
                        }
                      },
                      icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow)),
                  Expanded(
                    child: Slider(
                      value: pos.inSeconds.toDouble(),
                      min: 0,
                      max: duration!.inSeconds.toDouble(),
                      onChanged: (value) async {
                        final position = Duration(seconds: value.toInt());
                        await player.seek(position);
                        // await player.resume();
                      },
                    ),
                  ),
                  const CircleAvatar(
                    radius: 20,
                    child: Icon(Icons.person),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    formatTime(duration!),
                    style: TextStyle(fontSize: 14.sp),
                  ),
                  Text(
                    widget.time,
                    style: TextStyle(fontSize: 14.sp),
                  ),
                ],
              )
            ],
          );
  }
}
