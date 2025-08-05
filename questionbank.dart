class Bank{
  final String question;
  final List<String> options;
  final int answer;

  Bank({
    required this.question,
    required this.options,
    required this.answer,
});
}

class UserResponse {
  final String question;
  final String category;

  UserResponse({
    required this.question,
    required this.category,
  });


final List<Bank> part= [
  //Malware
  Bank(
  question:'dummy',
  options:['a','b','c','d'],
  answer: 3,
  ),
  
];

final List<Bank> fullQuestionBank = part;
