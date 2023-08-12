import 'package:flutter/material.dart';

class CustomRoute<T> extends MaterialPageRoute<T>{
  CustomRoute({required WidgetBuilder builder, required RouteSettings settings}) : super(builder: builder, settings: settings);

}