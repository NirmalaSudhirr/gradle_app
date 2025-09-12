class CharacterStatus {
  final String operation;
  final String date;
  final String time;
  final String characterName;
  final String overallStatus;
  final String status;


  CharacterStatus({
    required this.operation,
    required this.date,
    required this.time,
    required this.characterName,
    required this.overallStatus,
    required this.status,
  });

  factory CharacterStatus.fromJson(Map<String, dynamic> json) {
    return CharacterStatus(
      operation: json['Operation']?.toString() ?? '',
      date: json['Date']?.toString() ?? '',
      time: json['Time']?.toString() ?? '',
      characterName: json['CharacterName']?.toString() ?? '',
      overallStatus: json['OverallStatus']?.toString() ?? '',
      status: json['Status']?.toString() ?? '',
    );
  }
}
