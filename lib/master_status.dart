class MasterStatus {
  int stageNumber;
  String stageTitle;
  String message;
  int percentage;
  late double additionalPercentage;

  MasterStatus(this.stageNumber, this.stageTitle, this.message, this.percentage,
      {additionalPercentage = 0});
}
