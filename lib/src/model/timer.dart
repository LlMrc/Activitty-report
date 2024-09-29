class TimerModel {
  int? hour;
  int minut;
  int month;
  bool isReset;

  TimerModel({
    this.hour,
    required this.minut,
    required this.month,
    required this.isReset,
  });
 
  
  // copyWith method
  TimerModel copyWith({
    int? hour,
    int? minut,
    int? month,
    bool? isReset,
  }) {
    return TimerModel(
      hour: hour ?? this.hour,
      minut: minut ?? this.minut,
      month: month ?? this.month,
      isReset: isReset ?? this.isReset,
    );
  }

  // Convert TimerModel to Map
  Map<String, dynamic> toMap() {
    return {
      'hour': hour,
      'minut': minut,
      'month': month,
      'isReset': isReset,
    };
  }

  // Create TimerModel from Map
  factory TimerModel.fromMap(Map<String, dynamic> map) {
    return TimerModel(
      hour: map['hour'],
      minut: map['minut'],
      month: map['month'],
      isReset: map['isReset'],
    );
  }

   // Timer method returning '${hour} ${minut}'
  String timer() {
    return '${hour ?? 0.toDouble()} ${minut.toDouble()}';
  }
}
