import 'dart:ui';

class RouteColor {
  final String color;

  RouteColor(this.color);

  Color get colorCode {
    switch (color) {
      case 'black':
        return Color(0xFF000000);
      case 'blue':
        return Color(0xFF0000FF);
      case 'green':
        return Color(0xFF00FF00);
      case 'lightBlue':
        return Color(0xFF00CCCC);
      case 'orange':
        return Color(0xFFFF8000);
      case 'pink':
        return Color(0xFFE6007E);
      case 'purple':
        return Color(0xFF4C0099);
      case 'red':
        return Color(0xFFFF0000);
      case 'white':
        return Color(0xFFDDDDDD);
      case 'yellow':
        return Color(0xFFFFFF00);
      default:
        return Color(0xFF000000);
    }
  }
}
