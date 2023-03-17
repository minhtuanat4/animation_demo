import 'dart:math';

import 'intro_pikachu_flame_game.dart';

enum CheckLoop {
  noFirst,
  noLast,
  noFirstLast,
  hasFirstLast,
}

bool checkLineY(num xFirst, num xSecond, num y,
    List<List<PikachuObj>> pikachuMap, CheckLoop checkLoop) {
  final x1 = min(xFirst, xSecond);
  final x2 = max(xFirst, xSecond);
  switch (checkLoop) {
    case CheckLoop.noFirstLast:
      for (var x = x1 + 1; x <= x2 - 1; x++) {
        if (pikachuMap[x.toInt()][y.toInt()].isActive) {
          return false;
        }
      }
      break;
    case CheckLoop.hasFirstLast:
      for (var x = x1; x <= x2; x++) {
        if (pikachuMap[x.toInt()][y.toInt()].isActive) {
          return false;
        }
      }
      break;
    default:
  }
  return true;
}

bool checkLineX(num yFirst, num ySecond, num x,
    List<List<PikachuObj>> pikachuMap, CheckLoop checkLoop) {
  final y1 = min(yFirst, ySecond);
  final y2 = max(yFirst, ySecond);
  switch (checkLoop) {
    case CheckLoop.noFirstLast:
      for (var y = y1 + 1; y <= y2 - 1; y++) {
        if (pikachuMap[x.toInt()][y.toInt()].isActive) {
          return false;
        }
      }
      break;
    case CheckLoop.hasFirstLast:
      for (var y = y1; y <= y2; y++) {
        if (pikachuMap[x.toInt()][y.toInt()].isActive) {
          return false;
        }
      }
      break;
    default:
  }
  return true;
}

int checkLineXHasMore(
    num xFirst,
    num xSecond,
    num y,
    List<List<PikachuObj>> pikachuMap,
    CheckLoop checkLoop,
    int type,
    int totalRow) {
  var yIndex = y.toInt() + type;

  while (pikachuMap[xFirst.toInt()][yIndex.toInt()].isActive != true &&
      pikachuMap[xSecond.toInt()][yIndex.toInt()].isActive != true) {
    if (checkLineY(xFirst, xSecond, yIndex, pikachuMap, checkLoop)) {
      return yIndex.toInt();
    }
    yIndex += type;
  }
  return -1;
}

int checkLineYHasMore(
    num yFirst,
    num ySecond,
    num x,
    List<List<PikachuObj>> pikachuMap,
    CheckLoop checkLoop,
    int type,
    int totalColumn) {
  var xIndex = x.toInt() + type;

  while (pikachuMap[xIndex.toInt()][yFirst.toInt()].isActive != true &&
      pikachuMap[xIndex.toInt()][ySecond.toInt()].isActive != true) {
    if (checkLineX(yFirst, ySecond, xIndex, pikachuMap, checkLoop)) {
      return xIndex.toInt();
    }
    xIndex += type;
  }
  return -1;
}

int checkRectY(Point point1, Point point2, List<List<PikachuObj>> pikachuMap) {
  var pointMin = point1;
  var pointMax = point2;
  if (point1.x > point2.x) {
    pointMin = point2;
    pointMax = point1;
  }
  final x1 = pointMin.x;
  final x2 = pointMax.x;
  final y1 = pointMin.y;
  final y2 = pointMax.y;
  pikachuMap[x1.toInt()][y1.toInt()].isActive = false;
  pikachuMap[x2.toInt()][y2.toInt()].isActive = false;
  for (var x = x1; x <= x2; x++) {
    if ((checkLineY(x1, x, y1, pikachuMap, CheckLoop.hasFirstLast) &&
        checkLineX(y1, y2, x, pikachuMap, CheckLoop.hasFirstLast) &&
        checkLineY(x, x2, y2, pikachuMap, CheckLoop.hasFirstLast))) {
      print('X : $x ');
      pikachuMap[x1.toInt()][y1.toInt()].isActive = true;
      pikachuMap[x2.toInt()][y2.toInt()].isActive = true;
      return x.toInt();
    }
  }
  pikachuMap[x1.toInt()][y1.toInt()].isActive = true;
  pikachuMap[x2.toInt()][y2.toInt()].isActive = true;
  return -1;
}

int checkRectX(Point point1, Point point2, List<List<PikachuObj>> pikachuMap) {
  var pointMin = point1;
  var pointMax = point2;
  if (point1.y > point2.y) {
    pointMin = point2;
    pointMax = point1;
  }
  final x1 = pointMin.x;
  final x2 = pointMax.x;
  final y1 = pointMin.y;
  final y2 = pointMax.y;
  pikachuMap[x1.toInt()][y1.toInt()].isActive = false;
  pikachuMap[x2.toInt()][y2.toInt()].isActive = false;
  for (var y = y1; y <= y2; y++) {
    if (checkLineX(y1, y, x1, pikachuMap, CheckLoop.hasFirstLast) &&
        checkLineY(x1, x2, y, pikachuMap, CheckLoop.hasFirstLast) &&
        checkLineX(y, y2, x2, pikachuMap, CheckLoop.hasFirstLast)) {
      print('Y : $y ');
      pikachuMap[x1.toInt()][y1.toInt()].isActive = true;
      pikachuMap[x2.toInt()][y2.toInt()].isActive = true;
      return y.toInt();
    }
  }
  pikachuMap[x1.toInt()][y1.toInt()].isActive = true;
  pikachuMap[x2.toInt()][y2.toInt()].isActive = true;
  return -1;
}

// Point? checkLLLCoordinateLine(
//     Point point1, Point point2, List<List<PikachuObj>> pikachuMap, int type) {
//   final x1 = point1.x;
//   final x2 = point2.x;
//   final y1 = point1.y;
//   final y2 = point2.y;
// // pikachuMap[x1.toInt()][y1.toInt()].isActive = false;
// //   pikachuMap[x2.toInt()][y2.toInt()].isActive = false;
//   var x = x1;
//   var y = y2;
//   if (type == -1) {
//     x = x2;
//     y = y1;
//   }

//   if (!pikachuMap[x.toInt()][y.toInt()].isActive) {
//     if (checkLineY(x1, x2, y, pikachuMap, CheckLoop.no_first_last)) {
//       if (checkLineX(y1, y2, x, pikachuMap, CheckLoop.no_first_last)) {
//         return Point(x, y);
//       }
//     }
//   }
//   return null;
// }

int checkMoreLineY(Point point1, Point point2,
    List<List<PikachuObj>> pikachuMap, int totalRow, int type) {
  var pointMin = point1;
  var pointMax = point2;
  if (point1.x > point2.x) {
    pointMin = point2;
    pointMax = point1;
  }

  final x1 = pointMin.x;
  final x2 = pointMax.x;
  final y1 = pointMin.y;
  final y2 = pointMax.y;
  pikachuMap[x1.toInt()][y1.toInt()].isActive = false;
  pikachuMap[x2.toInt()][y2.toInt()].isActive = false;
  var col = pointMin.y;
  var x = pointMax.x;
  if (type == -1) {
    col = pointMax.y;
    x = pointMin.x;
  }

  if (checkLineY(x1, x2, col, pikachuMap, CheckLoop.hasFirstLast)) {
    while (pikachuMap[x.toInt()][y1.toInt()].isActive != true &&
        pikachuMap[x.toInt()][y2.toInt()].isActive != true) {
      if (checkLineX(y1, y2, x, pikachuMap, CheckLoop.noFirstLast)) {
        pikachuMap[x1.toInt()][y1.toInt()].isActive = true;
        pikachuMap[x2.toInt()][y2.toInt()].isActive = true;
        return x.toInt();
      }
      x += type;
    }
  }
  pikachuMap[x1.toInt()][y1.toInt()].isActive = true;
  pikachuMap[x2.toInt()][y2.toInt()].isActive = true;
  return -1;
}

int checkMoreLineX(Point point1, Point point2,
    List<List<PikachuObj>> pikachuMap, int totalColumn, int type) {
  var pointMin = point1;
  var pointMax = point2;
  if (point1.y > point2.y) {
    pointMin = point2;
    pointMax = point1;
  }
  final x1 = pointMin.x;
  final x2 = pointMax.x;
  final y1 = pointMin.y;
  final y2 = pointMax.y;
  pikachuMap[x1.toInt()][y1.toInt()].isActive = false;
  pikachuMap[x2.toInt()][y2.toInt()].isActive = false;
  var row = pointMin.x;
  var y = pointMax.y;
  if (type == -1) {
    y = pointMin.y;
    row = pointMax.x;
  }
  if (checkLineX(y1, y2, row, pikachuMap, CheckLoop.hasFirstLast)) {
    while (pikachuMap[x1.toInt()][y.toInt()].isActive != true &&
        pikachuMap[x2.toInt()][y.toInt()].isActive != true) {
      if (checkLineY(x1, x2, y, pikachuMap, CheckLoop.noFirstLast)) {
        pikachuMap[x1.toInt()][y1.toInt()].isActive = true;
        pikachuMap[x2.toInt()][y2.toInt()].isActive = true;
        return y.toInt();
      }
      y += type;
    }
  }
  pikachuMap[x1.toInt()][y1.toInt()].isActive = true;
  pikachuMap[x2.toInt()][y2.toInt()].isActive = true;
  return -1;
}

List<Point> myPoint(Point point1, Point point2,
    List<List<PikachuObj>> pikachuMap, int totalRow, int totalColumn) {
  // Point? lCoordinateLine;
  if (point1.x == point2.x) {
    print('checkLineY');

    if (checkLineX(
        point1.y, point2.y, point1.x, pikachuMap, CheckLoop.noFirstLast)) {
      return [point1, point2];
    } else {
      int tmp = -1;

      if ((tmp = checkLineYHasMore(point1.y, point2.y, point1.x, pikachuMap,
              CheckLoop.noFirstLast, 1, totalRow)) !=
          -1) {
        print('checkLineYHasMore 1');
        return [point1, Point(tmp, point1.y), Point(tmp, point2.y), point2];
      } else if ((tmp = checkLineYHasMore(point1.y, point2.y, point1.x,
              pikachuMap, CheckLoop.noFirstLast, -1, totalRow)) !=
          -1) {
        print('checkLineYHasMore -1');
        return [point1, Point(tmp, point1.y), Point(tmp, point2.y), point2];
      }
    }
  } else if (point1.y == point2.y) {
    print('checkLineX');

    if (checkLineY(
        point1.x, point2.x, point1.y, pikachuMap, CheckLoop.noFirstLast)) {
      return [point1, point2];
    } else {
      int tmp = -1;

      if ((tmp = checkLineXHasMore(point1.x, point2.x, point1.y, pikachuMap,
              CheckLoop.noFirstLast, 1, totalColumn)) !=
          -1) {
        print('checkLineXHasMore 1');
        return [point1, Point(point1.x, tmp), Point(point2.x, tmp), point2];
      } else if ((tmp = checkLineXHasMore(point1.x, point2.x, point1.y,
              pikachuMap, CheckLoop.noFirstLast, -1, totalColumn)) !=
          -1) {
        print('checkLineXHasMore -1');
        return [point1, Point(point1.x, tmp), Point(point2.x, tmp), point2];
      }
    }
  } else {
    int temp = -1;
    if ((temp = checkRectX(point1, point2, pikachuMap)) != -1) {
      print('checkRectX');
      return [point1, Point(point1.x, temp), Point(point2.x, temp), point2];
    }
    if ((temp = checkRectY(point1, point2, pikachuMap)) != -1) {
      print('checkRectY');
      return [point1, Point(temp, point1.y), Point(temp, point2.y), point2];
    }

    // if ((lCoordinateLine =
    //         checkLLLCoordinateLine(point1, point2, pikachuMap, 1)) !=
    //     null) {
    //   print('checkLLLCoordinateLine 1');
    //   return [point1, lCoordinateLine!, point2];
    // }
    // if ((lCoordinateLine =
    //         checkLLLCoordinateLine(point1, point2, pikachuMap, -1)) !=
    //     null) {
    //   print('checkLLLCoordinateLine -1');
    //   return [point1, lCoordinateLine!, point2];
    // }
    if ((temp = checkMoreLineX(point1, point2, pikachuMap, totalColumn, 1)) !=
        -1) {
      print('checkMoreLineX 1');
      if (temp == point1.y) {
        return [point1, Point(point2.x, temp), point2];
      } else if (temp == point2.y) {
        return [point1, Point(point1.x, temp), point2];
      }
      return [point1, Point(point1.x, temp), Point(point2.x, temp), point2];
    }
    if ((temp = checkMoreLineX(point1, point2, pikachuMap, totalColumn, -1)) !=
        -1) {
      print('checkMoreLineX -1');
      if (temp == point1.y) {
        return [point1, Point(point2.x, temp), point2];
      } else if (temp == point2.y) {
        return [point1, Point(point1.x, temp), point2];
      }
      return [point1, Point(point1.x, temp), Point(point2.x, temp), point2];
    }

    if ((temp = checkMoreLineY(point1, point2, pikachuMap, totalRow, 1)) !=
        -1) {
      print('checkMoreLineY 1');

      if (temp == point1.x) {
        return [point1, Point(temp, point2.y), point2];
      } else if (temp == point2.x) {
        return [point1, Point(temp, point1.y), point2];
      }
      return [point1, Point(temp, point1.y), Point(temp, point2.y), point2];
    }
    if ((temp = checkMoreLineY(point1, point2, pikachuMap, totalRow, -1)) !=
        -1) {
      print('checkMoreLineY -1');
      if (temp == point1.x) {
        return [point1, Point(temp, point2.y), point2];
      } else if (temp == point2.x) {
        return [point1, Point(temp, point1.y), point2];
      }
      return [point1, Point(temp, point1.y), Point(temp, point2.y), point2];
    }
  }

  return [];
}
