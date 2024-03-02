import 'package:flutter/widgets.dart' show BuildContext, ModalRoute;

//  this extension adds a getArguments<T>() method to BuildContext
//that allows you to retrieve the arguments passed to the current route in a type-safe manner.
extension GetArguments on BuildContext {
  T? getArguments<T>() {
    final modalRoute = ModalRoute.of(this);
    if (modalRoute != null) {
      final args = modalRoute.settings.arguments;
      if (args != null && args is T) {
        return args as T;
      }
    }
    return null;
  }
}
