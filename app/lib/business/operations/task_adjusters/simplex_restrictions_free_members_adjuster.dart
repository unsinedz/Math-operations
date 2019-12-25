import 'package:app/business/operations/fraction.dart';
import 'package:app/business/operations/linear_task_context.dart';
import 'package:app/business/operations/task_adjusters/linear_task_adjuster.dart';
import 'package:app/business/operations/restriction.dart';

class SimplexRestrictionsFreeMemberAdjuster implements LinearTaskAdjuster {
  @override
  List<LinearTaskContext> getAdjustmentSteps(LinearTaskContext context) {
    Fraction zero = const Fraction.fromNumber(0);
    Fraction minusOne = const Fraction.fromNumber(-1);

    var restrictions = context.linearTask.restrictions;
    if (restrictions.every((x) => x.freeMember >= zero)) return [];

    var adjustedTask = context.linearTask.changeRestrictions(
      context.linearTask.restrictions.map(
        (x) => x
            .changeFreeMember(x.freeMember * minusOne)
            .changeComparison(x.comparison.invert()),
      ),
    );
    return [
      context.changeLinearTask(adjustedTask),
    ];
  }
}