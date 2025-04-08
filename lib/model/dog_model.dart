class DogModel {
  final int? id;
  final String name;
  final int age;

  const DogModel({this.id, required this.name, required this.age});

  Map<String, Object?> toMap() {
    return {'id': id, 'name': name, 'age': age};
  }
  @override
  String toString() {
    return 'Dog{id: $id, name: $name, age: $age}';
  }
}
