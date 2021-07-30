/// IPG Photonics Corporation
///
/// IPGScan TCP/IP API Commands
///
/// This section describes the TCP/IP API commands for controlling IPGScan externally.
/// The commands are ASCII based strings that are sent through a TCP/IP connection to IPGScan,
/// so the software can respond accordingly.
///
/// All commands should be followed by a carriage return (ASCII #13) and a line feed (ASCII #10).
/// ```dart
/// Example: JobOpen MyJob<CR><LF>
/// ```
/// Prior to sending any commands a connection between the computer running IPGScan and the device
/// trying to control it, must exist. In this case, IPGScan will behave as a Server while the external
/// device will be the Client requesting a connection to IPGScan.
///
/// To define the IP Address and Port Number in which the IPGScan server engine will be listening to incoming
/// connections follow the steps below:
///
/// 1. Open IPGScan
/// 2. Click on View -> Options
/// 3. On the tree to the left, click on Settings
/// 4. Scroll down to TCP/IP
/// 5. Select the Encoding type for the ASCII characters
/// 6. Select the IP Address (if more than one interface is installed in the computer) and Command Port number
/// for the Server engine.
/// 7. Restart IPGScan
///
///
/// ```dart
/// ## NOTE ##
/// ```
/// When a job is run using TCP commands, a message will appear in IPGScan showing remote session in progress:
///
/// ```dart
/// 'Remote Session In Progress'
///        STOP
/// 'Jobs in Session'
/// ```
///

/// `[IPGScanRemoteAPI]`'s `[JobOpen]` command
///
/// ```dart
/// Parameters: '$fileName'
/// Example: 'JobOpen MyJob\r\n', // MyJob is fileName
/// Description: 'Opens a job file in the IPGScan Jobs folder. Filename should not have the "wjb" extension.',
/// Troubleshooting: 'Job does not exist or cannot be opened. Check that spelling and case is correct. Weird symbols in job names may also cause this error.',
/// Error: 'Error: $fileName not found',
/// ```
///

List<String> errorList = [
  'Error: $parameterFileName not found', // JobOpen
  'Error: ScanController not connected', // JobStart
  'Error: Weld in progress', // JobStart
  'Error: $parameterFileName not opened', // JobStart
  'Error: No running Job found', // JobStart/Abort
  'Error: $parameterFileName not closed', // JobClose
  'Error: IPGScan directory not found', // JobList
  'Error: No TCP Connection', // ConnectionGetStatus
  ' ', // ScannerGetStatus - It should has one space in the string
  'Error: ScanController not connected', // ScannerGetEnableBit
  'Error: Not Connected', // ScannerGetStatus
];

const Map<commandEnums, String> commandList = {
  commandEnums.JobOpen: 'Job Open',
  commandEnums.JobStart: 'Job Start',
  commandEnums.JobStop: 'Job Stop',
  commandEnums.JobAbort: 'Job Abort',
  commandEnums.JobClose: 'Job Close',
  commandEnums.JobList: 'Job List',
  commandEnums.ConnectionGetStatus: 'Connection Get Status',
  commandEnums.ScannerGetStatus: 'Scanner Get Status',
  commandEnums.JobGetStatus: 'Job Get Status',
  commandEnums.GetEncoding: 'Get Encoding',
  commandEnums.ScannerGetStartBit: 'Scanner Get Start Bit',
  commandEnums.ScannerGetEnableBit: 'Scanner Get Enable Bit',
  commandEnums.ScannerGetPortA: 'Scanner Get Port A',
  commandEnums.ScannerLock: 'Scanner Lock',
  commandEnums.ScannerUnlock: 'Scanner Unlock',
  commandEnums.ScannerInit: 'Scanner Init',
  commandEnums.ScannerParkAt: 'Scanner Park At',
  commandEnums.ScannerGetWorkspacePosition: 'Scanner Get Workspace Position',
  commandEnums.ScannerGetList: 'Scanner Get List',
  commandEnums.ScannerGetConnectionStatus: 'Scanner Get Connection Status',
  commandEnums.SystemSetVariable: 'System Set Variable',
  commandEnums.SystemGetVariable: 'System Get Variable',
  commandEnums.JobGetStatus2: 'Job Get Status2', // currently executing group&object name
  commandEnums.JobLastRunSuccessful: 'Job Last Run Successful',
};

enum commandEnums {
  JobOpen,
  JobStart,
  JobStop,
  JobAbort,
  JobClose,
  JobList,
  ConnectionGetStatus,
  ScannerGetStatus,
  JobGetStatus,
  GetEncoding,
  ScannerGetStartBit,
  ScannerGetEnableBit,
  ScannerGetPortA,
  ScannerLock,
  ScannerUnlock,
  ScannerInit,
  ScannerParkAt,
  ScannerGetWorkspacePosition,
  ScannerGetList,
  ScannerGetConnectionStatus,
  SystemSetVariable,
  SystemGetVariable,
  JobGetStatus2,
  JobLastRunSuccessful,
}

// parameters
String parameterFileName = '210424_ipgweld'; // it will come from ListView - inside of IPGScan Jobs folder
String parameterNone = '';
String parameterScannerName = 'laser213fduhfu28s';
String parameterGalvoPositionSet = '5 5 5';
String parameterVariableNumber = '1';
String parameterVariableValue = 'IPG';
String parameterCommandName = 'JobOpen';

String setCommand(commandEnums command, String parameter) {
  if (command == commandEnums.JobOpen ||
      command == commandEnums.JobStart ||
      command == commandEnums.JobStop ||
      command == commandEnums.JobAbort ||
      command == commandEnums.JobClose ||
      command == commandEnums.ScannerLock ||
      command == commandEnums.ScannerUnlock ||
      command == commandEnums.ScannerParkAt ||
      command == commandEnums.ScannerGetConnectionStatus ||
      command == commandEnums.SystemSetVariable ||
      command == commandEnums.SystemGetVariable) {
    return '${commandList[command].replaceAll(' ', '')} $parameter\r\n';
  } else {
    return '${commandList[command].replaceAll(' ', '')}\r\n';
  }
}
