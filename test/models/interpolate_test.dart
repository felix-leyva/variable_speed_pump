// void main() {
// //   var nodes = pumpCurve
// //       .map((e) => InterpolationNode(x: e.flow, y: e.pumpEndEff))
// //       .toList();
// //   var splineNodes = SplineInterpolation(nodes: nodes);
// //
// //   List<double> ranges = generateRanges(100);
// //
// //   var value = splineNodes.compute(300);
// //
// //   var values = ranges.map((e) => {e: splineNodes.compute(e)});
// //   print(splineNodes.compute(330));
// //
// //   var speeds = getSpeedAndPower(3600, 10, 0, 10);
// //   var percentages = getPowerAndPercent(56, 10);
// //
// //   var mPumpCurve = pumpCurve;
// //   var e = pumpCurve
// //       .map((e) =>
// //           percentages.map((per) => e.withLowerSpeed(per.percentage)).toList())
// //       .toList();
// //
// //   var f = percentages
// //       .map((per) =>
// //           pumpCurve.map((pcp) => pcp.withLowerSpeed(per.percentage)).toList())
// //       .toList();
// // }
// //
// // List<double> generateRanges(int steps) {
// //   var start = pumpCurve.first.flow;
// //   var end = pumpCurve.last.flow;
// //   var step = (end - start) / steps;
// //
// //   return List<double>.generate(100, (index) => start + index * step);
// }
