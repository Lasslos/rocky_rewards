import 'dart:ui';

class ColumnCoordinates {
  const ColumnCoordinates(this.x, this.width);

  final double x;
  final double width;

  Rect getRect(RowCoordinates row) => _getRect(this, row);
}

class RowCoordinates {
  const RowCoordinates(this.y, this.height);
  final double y;
  final double height;

  Rect getRect(ColumnCoordinates column) => _getRect(column, this);
}

Rect _getRect(ColumnCoordinates column, RowCoordinates row) => Rect.fromLTWH(
      column.x,
      row.y,
      column.width,
      row.height,
    );
