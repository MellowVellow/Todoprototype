class DashboardItemData {
  final String title;
  final String description;
  final Duration duration;
  final String category;
  final int priority;

  const DashboardItemData({
    required this.title,
    required this.description,
    required this.duration,
    required this.category,
    required this.priority,
  });

  Map<String, dynamic> toJson() => {
        'title': title,
        'description': description,
        'duration': duration.inMilliseconds,
        'category': category,
        'priority': priority,
      };

  factory DashboardItemData.fromJson(Map<String, dynamic> json) =>
      DashboardItemData(
        title: json['title'] as String,
        description: json['description'] as String,
        duration: Duration(milliseconds: json['duration'] as int),
        category: json['category'] as String,
        priority: json['priority'] as int,
      );
}
