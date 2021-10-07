import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:typed_data';
import 'package:flutter_tcp_client/tcp/tcp_client.dart';

final serverAddressProvider = StateProvider<String>((ref) => '127.0.0.1');
final serverPortProvider = StateProvider<int>((ref) => 88);

final tcpClientProvider = ChangeNotifierProvider<TCPClient>(
  (ref) => TCPClient(
    serverAddress: ref.read(serverAddressProvider).state,
    serverPort: ref.read(serverPortProvider).state,
  ),
);

final streamProvider = StreamProvider.autoDispose<Uint8List>(
  (ref) => ref.watch(tcpClientProvider).socket,
);

class JobListNotifier extends ChangeNotifier {
  String ipgJobs = '';
  List<String> jobList = [];

  void jobListParser(String jobListFromIPGScan) {
    jobList = jobListFromIPGScan.split('\n');
    print(jobList);
    jobList.removeLast();
    print(jobList.length);

    notifyListeners();
  }
}

final selectedJobIndexProvider = StateProvider<int>((ref) => 0);

final jobListProvider = ChangeNotifierProvider<JobListNotifier>(
  (ref) {
    return JobListNotifier();
  },
);

String sampleJobList = 'first_job\nfocus_run\npoint_and_shoot_example\n';

final socketListenProvider = StreamProvider.autoDispose<Uint8List>(
  (ref) {
    final tcpClient = ref.watch(tcpClientProvider);

    tcpClient.socket
      ..listen(
        (event) {
          tcpClient.receivedData = String.fromCharCodes(event);
          if (!tcpClient.dataReceivedState) {
            tcpClient.changeDataReceivedState();
          }
        },
      ).onDone(
        () {
          tcpClient
            ..changeConnectionState()
            ..streamDone();
          print('socket is closed');
        },
      );

    return tcpClient.socket;
  },
);