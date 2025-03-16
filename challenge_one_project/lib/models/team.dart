class TeamModel {
  final int teamId;
  final String teamName;

  TeamModel({
    required this.teamId,
    required this.teamName,
  });

  // Factory method to create a User from JSON                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           
  factory TeamModel.fromJson(Map<String, dynamic> json) {
    return TeamModel(
      teamId: json['team_id'],
      teamName: json['team_name'],
    );
  }
}