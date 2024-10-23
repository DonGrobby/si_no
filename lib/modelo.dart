class Modelo {
  final String answer;
  final bool forced;
  final String image;

  Modelo({required this.answer, required this.forced, required this.image});

  factory Modelo.fromJson(Map<String, dynamic> json) {
    return Modelo(
        answer: json['answer'], forced: json['forced'], image: json['image']);
  }
}
