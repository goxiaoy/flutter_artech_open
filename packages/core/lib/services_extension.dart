import 'package:artech_core/app_module_base.dart';
import 'package:get_it/get_it.dart';

extension ServicesExtensions on AppModuleMixin {
  void ifNotRegistered<T extends Object>(void Function(GetIt services) f) {
    if (!services.isRegistered<T>()) {
      f(services);
    }
  }

  void configTyped<T extends Object>(
      {void Function(T c)? configurator, T Function()? creator}) {
    if (!services.isRegistered<T>()) {
      if (creator == null) {
        throw Exception(
            'Configure object must create sync and ready immediately');
      }
      services.registerSingleton(creator());
    }
    final o = services.get<T>();
    if (configurator != null) {
      configurator(o);
    }
  }
}
