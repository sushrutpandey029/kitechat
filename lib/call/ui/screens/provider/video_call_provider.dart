import 'package:agora_uikit/agora_uikit.dart';
import 'package:flutter/widgets.dart';

class VideoCallProvider extends ChangeNotifier {
  AgoraClient? agoraClient;
  Future<void> connectCall(BuildContext context, String usernumber) async {
    // await agoraClient.initialize();
    AgoraClient agoraClient = AgoraClient(
      agoraConnectionData: AgoraConnectionData(
        // uid: int.parse(authusermodel.id),
        appId: 'a0999c11fe3b4b1a988fe04850510fb9',
        channelName: usernumber,
      ),
      enabledPermission: [Permission.camera, Permission.microphone],
    );
    agoraClient.initialize();
    this.agoraClient = agoraClient;
    // notifyListeners();
  }
}
