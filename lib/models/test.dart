class Test {
  final String name;
  final String testid;
  final String contactMail;
  final String testName;
  final String testCode;
  final int isOpen;
  final String questionsCollectionId;
  final String scoreBoardCollectionId;
  final int completedCount;
  Test(
      {required this.completedCount,
      required this.contactMail,
      required this.isOpen,
      required this.name,
      required this.questionsCollectionId,
      required this.scoreBoardCollectionId,
      required this.testCode,
      required this.testName,
      required this.testid});
}
