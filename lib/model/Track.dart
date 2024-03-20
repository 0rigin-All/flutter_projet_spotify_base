class Track {
  final String name;
  final String id;
  Track({required this.id, required this.name });

  factory Track.fromJson(Map<String, dynamic> data) {
    return Track(
        name: data['name'].toString() ?? "",
        id: data['id'].toString() ?? "",);
  }
}
