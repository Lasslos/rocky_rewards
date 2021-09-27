import 'dart:ui';

class ColumnCoordinates {
  final double x;
  final double width;
  const ColumnCoordinates(this.x, this.width);

  Rect getRect(RowCoordinates row) => _getRect(this, row);
}

class RowCoordinates {
  final double y;
  final double height;
  const RowCoordinates(this.y, this.height);

  Rect getRect(ColumnCoordinates column) => _getRect(column, this);
}

Rect _getRect(ColumnCoordinates column, RowCoordinates row) => Rect.fromLTWH(
  column.x, 
  row.y, 
  column.width,
  row.height,
);