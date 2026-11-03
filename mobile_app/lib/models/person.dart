class Person {
  final int? id;
  final String fullName;
  final String department;
  final String photoUrl;
  final String birthPlace;
  final DateTime birthDate;
  final String email;
  final String phone;

  const Person({
    this.id,
    required this.fullName,
    required this.department,
    required this.photoUrl,
    required this.birthPlace,
    required this.birthDate,
    required this.email,
    required this.phone,
  });

  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      id: json['id'] as int?,
      fullName: json['fullName'] as String,
      department: json['department'] as String,
      photoUrl: json['photoUrl'] as String,
      birthPlace: json['birthPlace'] as String,
      birthDate: DateTime.parse(json['birthDate'] as String),
      email: json['email'] as String,
      phone: json['phone'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'fullName': fullName,
      'department': department,
      'photoUrl': photoUrl,
      'birthPlace': birthPlace,
      'birthDate': '${birthDate.year.toString().padLeft(4, '0')}-'
          '${birthDate.month.toString().padLeft(2, '0')}-'
          '${birthDate.day.toString().padLeft(2, '0')}',
      'email': email,
      'phone': phone,
    };
    if (id != null) map['id'] = id;
    return map;
  }

  Person copyWith({
    int? id,
    String? fullName,
    String? department,
    String? photoUrl,
    String? birthPlace,
    DateTime? birthDate,
    String? email,
    String? phone,
  }) {
    return Person(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      department: department ?? this.department,
      photoUrl: photoUrl ?? this.photoUrl,
      birthPlace: birthPlace ?? this.birthPlace,
      birthDate: birthDate ?? this.birthDate,
      email: email ?? this.email,
      phone: phone ?? this.phone,
    );
  }

  @override
  String toString() =>
      'Person(id:$id, fullName:$fullName, department:$department)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Person && other.id == id && other.email == email;

  @override
  int get hashCode => Object.hash(id, email);
}
