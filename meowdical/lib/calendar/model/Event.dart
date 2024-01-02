class Event {
  final String? id;
  String title;
  String uid;
  String time;
  
  Event({this.id, required this.title, required this.uid, required this.time});

  @override
  String toString() => "$title of $uid";
}