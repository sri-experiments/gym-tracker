
class WorkoutModels {
  final int? id;
  final String workoutCategory;
  final String workoutName;
  final int weightLifted;
  final int reps;
  final int sets;
  final DateTime workoutDate;

  WorkoutModels({
    this.id,
    required this.workoutCategory,
    required this.workoutName,
    required this.weightLifted,
    required this.reps,
    required this.sets,
    required this.workoutDate,
});

  factory WorkoutModels.fromMap(Map<String, dynamic> json) => WorkoutModels(
    id: json['id'],
    workoutCategory: json['workoutCategory'],
    workoutName: json['workoutName'],
    weightLifted: json['weightLifted'],
    reps: json['reps'],
    sets: json['sets'],
    workoutDate: DateTime.parse(json['workoutDate']),
  );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'workoutCategory': workoutCategory,
      'workoutName': workoutName,
      'weightLifted': weightLifted,
      'reps': reps,
      'sets': sets,
      'workoutDate': workoutDate.toIso8601String(),
    };
  }
}