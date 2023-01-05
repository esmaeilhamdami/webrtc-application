class MeetingDetail {
  String? hostId , hostName , id;

  MeetingDetail({this.hostId, this.hostName, this.id});


  factory MeetingDetail.fromJson(json){
    return MeetingDetail(
      id: json['id'],
      hostId: json['hostId'],
      hostName: json['hostName']
    );
  }
}