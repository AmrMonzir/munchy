class UnitConverter {
  String sourceUnit;
  String destinationUnit;
  static const List<String> namesOfWorthyUnits = [
    "cup",
    "c",
    "pound",
    "gram",
    "ounce",
    "pound",
    "lbs",
    "mg",
    "oz",
    "pint",
    "ml",
    ""
  ];

  static bool isUnitWorthy(String unit) {
    String lowCaseUnit = unit.toLowerCase();
    for (var un in namesOfWorthyUnits) {
      if (un == lowCaseUnit) {
        return true;
      }
    }
    return false;
  }

  static bool isConvertableToMg(String sourceUnit) {
    return sourceUnit == "mg" ||
        sourceUnit == "pound" ||
        sourceUnit == "lbs" ||
        sourceUnit == "gram";
  }

  static bool isConvertableToMl(String sourceUnit) {
    return sourceUnit == "cup" ||
        sourceUnit == "c" ||
        sourceUnit == "pint" ||
        sourceUnit == "oz" ||
        sourceUnit == "ml";
  }

  static double convertToMg(String sourceUnit, double amount) {
    String unitToLowerCase = sourceUnit.toLowerCase();
    switch (unitToLowerCase) {
      case "pound":
        return 454 * amount;
      case "lbs":
        return 454 * amount;
      case "mg":
        return amount;
      case "gram":
        return amount;
      default:
        return -1;
    }
  }

  static double convertToMl(String sourceUnit, double amount) {
    String unitToLowerCase = sourceUnit.toLowerCase();
    switch (unitToLowerCase) {
      case "cup":
        return 237 * amount;
      case "c":
        return 237 * amount;
      case "pint":
        return 473 * amount;
      case "oz":
        return 28 * amount;
      case "ml":
        return amount;
      default:
        return -1;
    }
  }
}
