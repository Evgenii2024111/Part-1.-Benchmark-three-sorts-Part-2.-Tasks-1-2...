void main() {
  Map<String, int> people = {
    'Alice': 25,
    'Bob': 22,
    'Charlie': 30,
    'Diana': 28,
    'Eve': 35,
  };

  for (String name in people.keys) {
    int age = people[name]!;
    print('$name is $age years old.');
  }
}
