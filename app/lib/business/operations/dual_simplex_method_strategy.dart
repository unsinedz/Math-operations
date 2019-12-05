import 'fraction.dart';
import 'simplex_table.dart';
import 'simplex_table_context.dart';
import 'simplex_table_transformation_context.dart';
import 'solution_status.dart';

class DualSimplexMethodStrategy {
  const DualSimplexMethodStrategy();

  bool canBeApplied(SimplexTableContext simplexTableContext) {
    if (simplexTableContext == null)
      throw Exception('Context can not be null.');

    if (!simplexTableContext.hasBasis) return false;

    Fraction zero = const Fraction.fromNumber(0);
    return simplexTableContext.simplexTable.estimations.variableEstimations
        .every((x) => x <= zero);
  }

  SolutionStatus solve(SimplexTableContext simplexTableContext) {
    if (simplexTableContext == null)
      throw Exception('Context can not be null.');

    if (!canBeApplied(simplexTableContext))
      throw Exception('Strategy can not be applied for context.');

    Fraction zero = const Fraction.fromNumber(0);
    var tableRows = simplexTableContext.simplexTable.rows;
    if (tableRows.every((x) => x.freeMember >= zero))
      return SolutionStatus.hasRoot;

    if (tableRows.any(
        (x) => x.freeMember < zero && x.coefficients.every((c) => c > zero)))
      return SolutionStatus.noRoots;

    return SolutionStatus.undefined;
  }

  SimplexTable getNextTable(SimplexTableContext simplexTableContext) {
    if (simplexTableContext == null)
      throw Exception('Context can not be null.');

    if (!canBeApplied(simplexTableContext))
      throw Exception('Strategy can not be applied for context.');

    if (solve(simplexTableContext) != SolutionStatus.undefined)
      throw Exception('Cannot get next table. The task is solved.');

    SimplexTable table = simplexTableContext.simplexTable;
    int solvingRowIndex = _findSolvingRowIndex(table);
    return new SimplexTableTransformationContext(
      simplexTable: table,
      solvingRowIndex: solvingRowIndex,
      solvingColumnIndex:
          _findSolvingColumnIndex(table, table.rows[solvingRowIndex]),
    ).transform();
  }

  int _findSolvingRowIndex(SimplexTable table) {
    Fraction minimumFreeMember = table.rows[0].freeMember;
    int minimumFreeMemberIndex = 0;
    for (int i = 1; i < table.rows.length; i++) {
      Fraction freeMember = table.rows[i].freeMember;
      if (freeMember < minimumFreeMember) {
        minimumFreeMemberIndex = i;
        minimumFreeMember = freeMember;
      }
    }

    return minimumFreeMemberIndex;
  }

  int _findSolvingColumnIndex(SimplexTable table, SimplexTableRow solvingRow) {
    const Fraction _0 = const Fraction.fromNumber(0);
    Fraction minimumQuotient;
    int minimumQuotientIndex = -1;
    for (int i = 0; i < solvingRow.coefficients.length; i++) {
      Fraction coefficient = solvingRow.coefficients[i];
      if (coefficient >= _0) continue;

      Fraction quotient =
          table.estimations.variableEstimations[i] / coefficient;
      if (minimumQuotient == null || quotient < minimumQuotient) {
        minimumQuotientIndex = i;
        minimumQuotient = quotient;
      }
    }

    return minimumQuotientIndex;
  }
}
