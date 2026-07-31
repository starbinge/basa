class OrdinaryNumberChecker {
  String generateOrdinaryNumber({required int number}) {
    final int dateNumber = DateTime.fromMillisecondsSinceEpoch(number).day;
    return _getOrdinalSuffix(dateNumber);
  }

  String _getOrdinalSuffix(int number) {
    if (number >= 11 && number <= 13) {
      return '${number}th';
    }

    switch (number % 10) {
      case 1:
        return '${number}st';
      case 2:
        return '${number}nd';
      case 3:
        return '${number}rd';
      default:
        return '${number}th';
    }
  }
}
