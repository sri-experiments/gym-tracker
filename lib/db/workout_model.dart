final String tableWorkout = 'workout';

class WorkoutFields {
  static final List<String> values = [
    id, workoutCategory, workoutName, weightLifted, reps, sets, workedOutOn
  ];
  static final String id = '_id';
   static final String workoutCategory = 'workoutCategory';
   static final String workoutName = 'workoutName';
   static final String weightLifted = 'weightLifted';
   static final String reps = 'reps';
   static final String sets = 'sets';
   static final String workedOutOn = 'workedOutOn';
}

class WorkoutModel {
  final int? id;
  final String workoutCategory;
  final String workoutName;
  final int weightLifted;
  final int reps;
  final int sets;
  final DateTime workedOutOn;

  const WorkoutModel({
    this.id,
    required this.workoutCategory,
    required this.workoutName,
    required this.weightLifted,
    required this.reps,
    required this.sets,
    required this.workedOutOn
  });

  WorkoutModel copy({
    int? id,
    String? workoutCategory,
    String? workoutName,
    int? weightLifted,
    int? reps,
    int? sets,
    DateTime? workedOutOn,
  }) => WorkoutModel(
    id: id ?? this.id,
    workoutCategory: workoutCategory ?? this.workoutCategory,
    workoutName: workoutName ?? this.workoutName,
    weightLifted: weightLifted ?? this.weightLifted,
    reps: reps ?? this.reps,
    sets: sets ?? this.sets,
    workedOutOn: workedOutOn ?? this.workedOutOn,
  );

  Map<String, Object?> toJson() => {
    WorkoutFields.id: id,
    WorkoutFields.workoutCategory: workoutCategory,
    WorkoutFields.workoutName: workoutName,
    WorkoutFields.weightLifted: weightLifted,
    WorkoutFields.reps: reps,
    WorkoutFields.sets: sets,
    WorkoutFields.workedOutOn: workedOutOn.toIso8601String(),
  };

  static WorkoutModel fromJson(Map<String, Object?> json) => WorkoutModel(
    id: json[WorkoutFields.id] as int?,
      workoutCategory: json[WorkoutFields.workoutCategory] as String,
      workoutName: json[WorkoutFields.workoutName] as String,
      weightLifted: json[WorkoutFields.weightLifted] as int,
      reps: json[WorkoutFields.reps] as int,
      sets: json[WorkoutFields.sets] as int,
      workedOutOn: DateTime.parse(json[WorkoutFields.workedOutOn] as String),
  );
}