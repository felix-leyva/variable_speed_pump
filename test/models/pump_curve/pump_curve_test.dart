import 'package:flutter_test/flutter_test.dart';
import 'package:variable_speed_pump/models/pump_curve/pump_curve.dart';
import 'package:variable_speed_pump/utils/constants.dart';
import 'package:variable_speed_pump/utils/functions.dart';

void main() {
  test_get_point_with_head();
  test_creating_pump_curve_with_lower_speed();
  test_creating_various_pump_curves_with_lower_speed();
  test_generatingPowerPumpCurve();
}

void test_generatingPowerPumpCurve() {
  test("test power curve point with H:30", () {
    var pumpCurves = PumpCurve(rpm: 3600, points: pumpCurve);
    var head = 20.0;
    var powerPumpCurve = pumpCurves.powerPumpCurveWithHead(head: head);
    if (powerPumpCurve.points.isEmpty) throw ("Empty power pump curve");

    expect(powerPumpCurve.head, head);
  });
}

void test_get_point_with_head() {
  test("test getting point with H:50", () {
    var pumpCurves = PumpCurve(rpm: 3600, points: pumpCurve);
    var head = 50.2;
    var pumpCurvePoint = pumpCurves.getPointWithHead(head);
    if (pumpCurvePoint == null) throw ("Null value returned");

    expect(pumpCurvePoint.head, head);
    expect(pumpCurvePoint.flow.roundD(0), 342);
    expect(pumpCurvePoint.pumpEndEff, .86);
  });
  test("test getting point with H:10 returns null", () {
    var pumpCurves = PumpCurve(rpm: 3600, points: pumpCurve);
    var head = 10.2;
    var pumpCurvePoint = pumpCurves.getPointWithHead(head);

    expect(pumpCurvePoint, null);
  });
  test("test getting point with H:90 returns null", () {
    var pumpCurves = PumpCurve(rpm: 3600, points: pumpCurve);
    var head = 90.2;
    var pumpCurvePoint = pumpCurves.getPointWithHead(head);

    expect(pumpCurvePoint, null);
  });
}

void test_creating_pump_curve_with_lower_speed() {
  test("test creating a pump curve with 59Hz less speed", () {
    double newSpeedPercentage = 59 / 60;
    var pumpCurves = PumpCurve(rpm: 3600, points: pumpCurve);
    var newPumpCurve = pumpCurves.pumpCurveWithSpeed(newSpeedPercentage);
    if (newPumpCurve == null) throw ("Null value returned");
    expect(newPumpCurve.points[0].flow.roundD(1), 111.7);
    expect(newPumpCurve.points[0].head.roundD(1), 58.9);
    expect(newPumpCurve.points[7].flow.roundD(1), 502.6);
    expect(newPumpCurve.points[7].head.roundD(1), 29.5);
  });

  test("test creating a pump curve with 45Hz less speed", () {
    double newSpeedPercentage = 45 / 60;
    var pumpCurves = PumpCurve(rpm: 3600, points: pumpCurve);
    var newPumpCurve = pumpCurves.pumpCurveWithSpeed(newSpeedPercentage);
    if (newPumpCurve == null) throw ("Null value returned");
    expect(newPumpCurve.points[7].flow.roundD(1), 383.3);
    expect(newPumpCurve.points[7].head.roundD(1), 17.1);
    expect(newPumpCurve.points[0].flow.roundD(1), 85.2);
    expect(newPumpCurve.points[0].head.roundD(1), 34.3);
  });
}

void test_creating_various_pump_curves_with_lower_speed() {
  test("test creating 60 pump curves with less speed", () async {
    final myPumpCurve = PumpCurve(rpm: 3600, points: pumpCurve);

    final variousPumpCurves = await myPumpCurve.pumpCurvesWithSpeedRanges();
    if (variousPumpCurves == null) throw ("Null value returned");
    final pcp1 = variousPumpCurves[59];
    final pcp2 = variousPumpCurves[29];

    expect(pcp1.points[0].flow.roundD(1), 56.8);
    expect(pcp1.points[0].head.roundD(1), 15.2);
    expect(pcp2.points[3].flow.roundD(1), 213);
    expect(pcp2.points[3].head.roundD(1), 30.5);
  });

  test("test creating a pump curve with 45Hz less speed", () {
    double newSpeedPercentage = 45 / 60;
    var pumpCurves = PumpCurve(rpm: 3600, points: pumpCurve);
    var newPumpCurve = pumpCurves.pumpCurveWithSpeed(newSpeedPercentage);
    if (newPumpCurve == null) throw ("Null value returned");
    expect(newPumpCurve.points[7].flow.roundD(1), 383.3);
    expect(newPumpCurve.points[7].head.roundD(1), 17.1);
    expect(newPumpCurve.points[0].flow.roundD(1), 85.2);
    expect(newPumpCurve.points[0].head.roundD(1), 34.3);
  });
}

/**
 * Model for the tests:
    FLOW								HEAD
    60%	72%	80%	84%	86%	86%	83%	74%	60%	72%	80%	84%	86%	86%	83%	74%
    60	113,58	170,38	227,17	283,96	340,75	397,55	454,34	511,13	60,96	59,44	57,00	54,25	50,29	45,11	38,10	30,48
    59	111,69	167,54	223,38	279,23	335,07	390,92	446,77	502,61	58,94	57,47	55,11	52,46	48,63	43,62	36,84	29,47
    58	109,80	164,70	219,60	274,50	329,40	384,30	439,19	494,09	56,96	55,54	53,26	50,70	47,00	42,15	35,60	28,48
    57	107,91	161,86	215,81	269,76	323,72	377,67	431,62	485,57	55,02	53,64	51,44	48,96	45,39	40,71	34,39	27,51
    56	106,01	159,02	212,02	265,03	318,04	371,04	424,05	477,06	53,10	51,78	49,65	47,26	43,81	39,30	33,19	26,55
    55	104,12	156,18	208,24	260,30	312,36	364,42	416,48	468,54	51,22	49,94	47,89	45,59	42,26	37,91	32,01	25,61
    54	102,23	153,34	204,45	255,57	306,68	357,79	408,91	460,02	49,38	48,14	46,17	43,95	40,74	36,54	30,86	24,69
    53	100,33	150,50	200,67	250,83	301,00	351,17	401,33	451,50	47,57	46,38	44,47	42,33	39,24	35,20	29,73	23,78
    52	98,44	147,66	196,88	246,10	295,32	344,54	393,76	442,98	45,79	44,64	42,81	40,75	37,77	33,88	28,62	22,89
    51	96,55	144,82	193,09	241,37	289,64	337,91	386,19	434,46	44,04	42,94	41,18	39,20	36,34	32,59	27,53	22,02
    50	94,65	141,98	189,31	236,63	283,96	331,29	378,62	425,94	42,33	41,27	39,58	37,68	34,92	31,33	26,46	21,17
    49	92,76	139,14	185,52	231,90	278,28	324,66	371,04	417,42	40,66	39,64	38,01	36,18	33,54	30,09	25,41	20,33
    48	90,87	136,30	181,74	227,17	272,60	318,04	363,47	408,91	39,01	38,04	36,48	34,72	32,19	28,87	24,38	19,51
    47	88,97	133,46	177,95	222,44	266,92	311,41	355,90	400,39	37,41	36,47	34,97	33,29	30,86	27,68	23,38	18,70
    46	87,08	130,62	174,16	217,70	261,24	304,79	348,33	391,87	35,83	34,94	33,50	31,89	29,56	26,51	22,39	17,92
    45	85,19	127,78	170,38	212,97	255,57	298,16	340,75	383,35	34,29	33,43	32,06	30,52	28,29	25,37	21,43	17,14
    44	83,30	124,94	166,59	208,24	249,89	291,53	333,18	374,83	32,78	31,96	30,65	29,18	27,05	24,26	20,49	16,39
    43	81,40	122,10	162,80	203,51	244,21	284,91	325,61	366,31	31,31	30,53	29,27	27,87	25,83	23,17	19,57	15,65
    42	79,51	119,26	159,02	198,77	238,53	278,28	318,04	357,79	29,87	29,12	27,93	26,58	24,64	22,10	18,67	14,94
    41	77,62	116,42	155,23	194,04	232,85	271,66	310,46	349,27	28,46	27,75	26,61	25,33	23,48	21,06	17,79	14,23
    40	75,72	113,58	151,45	189,31	227,17	265,03	302,89	340,75	27,09	26,42	25,33	24,11	22,35	20,05	16,93	13,55
    39	73,83	110,75	147,66	184,58	221,49	258,41	295,32	332,24	25,76	25,11	24,08	22,92	21,25	19,06	16,10	12,88
    38	71,94	107,91	143,87	179,84	215,81	251,78	287,75	323,72	24,45	23,84	22,86	21,76	20,17	18,09	15,28	12,23
    37	70,04	105,07	140,09	175,11	210,13	245,15	280,18	315,20	23,18	22,60	21,67	20,63	19,12	17,15	14,49	11,59
    36	68,15	102,23	136,30	170,38	204,45	238,53	272,60	306,68	21,95	21,40	20,52	19,53	18,11	16,24	13,72	10,97
    35	66,26	99,39	132,52	165,64	198,77	231,90	265,03	298,16	20,74	20,22	19,40	18,46	17,11	15,35	12,96	10,37
    34	64,36	96,55	128,73	160,91	193,09	225,28	257,46	289,64	19,57	19,09	18,30	17,42	16,15	14,49	12,23	9,79
    33	62,47	93,71	124,94	156,18	187,41	218,65	249,89	281,12	18,44	17,98	17,24	16,41	15,21	13,65	11,53	9,22
    32	60,58	90,87	121,16	151,45	181,74	212,02	242,31	272,60	17,34	16,91	16,21	15,43	14,31	12,83	10,84	8,67
    31	58,69	88,03	117,37	146,71	176,06	205,40	234,74	264,08	16,27	15,87	15,22	14,48	13,43	12,04	10,17	8,14
    30	56,79	85,19	113,58	141,98	170,38	198,77	227,17	255,57	15,24	14,86	14,25	13,56	12,57	11,28	9,52	7,62
*/
