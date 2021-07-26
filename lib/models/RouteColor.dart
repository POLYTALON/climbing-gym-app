import 'package:equatable/equatable.dart';

class RouteColor extends Equatable {
  final String color;
  final int colorCode;

  RouteColor({this.color = 'default', this.colorCode = 0x00000000});

  @override
  List<Object> get props => [color, colorCode];

  factory RouteColor.fromFirestore(String color, String colorCode) {
    return RouteColor(
        color: color ?? '', colorCode: int.parse(colorCode ?? 0x00000000));
  }
}
