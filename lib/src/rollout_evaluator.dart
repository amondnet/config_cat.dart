import 'package:config_cat/src/model/config.dart';
import 'package:config_cat/src/model/rule.dart';
import 'package:config_cat/src/model/user.dart';
import 'package:quiver/strings.dart';

class RolloutEvaluator {
  dynamic evaluate(Config config, String key, User user) {
    if (user == null) {
      return config.value;
    }

    for (var rule in config.rolloutRules) {
      String comparisonAttribute = rule.comparisonAttribute;
      String comparisonValue = rule.comparisonValue;
      Comparator comparator = rule.comparator;
      dynamic value = rule.value;
      String userValue = user.getAttribute(comparisonAttribute);

      if (isEmpty(comparisonValue) || isEmpty(userValue)) {
        continue;
      }

      switch (comparator) {
        case Comparator.IS_IN:
          List<String> inValues =
              comparisonValue.split(",").map((s) => s.trim()).toList();
          if (inValues.contains(userValue)) {
            return value;
          }
          break;
        case Comparator.IS_NOT_IN:
          List<String> notInValues =
              comparisonValue.split(",").map((s) => s.trim()).toList();
          if (notInValues.contains(userValue)) {
            return value;
          }
          break;
        case Comparator.CONTAINS:
          if (userValue.contains(comparisonValue)) return value;
          break;
        case Comparator.NOT_CONTAINS:
          if (!userValue.contains(comparisonValue)) return value;
          break;
      }
    }

    if (config.rolloutPercentageItems.isNotEmpty) {
      String hashCandidate = key + user.identifier;
      int scale = 100;
      // TODO
    }
    return config.value;
  }
}
